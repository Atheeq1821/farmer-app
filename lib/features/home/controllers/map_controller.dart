import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapController extends ChangeNotifier {


  final String apiKey = 'AIzaSyCfaOlzOME-gQcLszO880_63wt-J8QjA-8';

  bool _tripStarted = false;
  bool get tripStarted => _tripStarted;

  void Function(LatLng reached)? _arrivalCallback;
  set onArrival(void Function(LatLng p) cb) => _arrivalCallback = cb;

  Position? currentPosition;

  final List<LatLng> _destinations = [
    LatLng(13.0827, 80.2707), // Chennai Central
    LatLng(13.0639, 80.2439), // Egmore
    LatLng(13.0500, 80.2500), // Anna Salai
    LatLng(13.0725, 80.2239), // Guindy
    LatLng(13.0878, 80.2780), // T Nagar
    LatLng(13.0620, 80.2070), // Saidapet
    LatLng(13.0800, 80.1800), // Koyambedu
  ];

  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

 
  Future<void> initMarkers() async {
    _markers.clear();
    for (int i = 0; i < _destinations.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId('dest_$i'),
        position: _destinations[i],
        infoWindow: InfoWindow(title: 'Farmer ${i + 1}'),
        onTap: () => _drawRouteTo(_destinations[i]),
      ));
    }
    notifyListeners();
  }

  Future<void> startTrip() async {
    if (_tripStarted) return;
    _tripStarted = true;

    await _ensureLocationStream();
    _drawRouteTo(_nearestDestination());
    notifyListeners();
  }

  Future<void> optimizeRoute() async {
    if (!_tripStarted || currentPosition == null || _destinations.isEmpty) return;

    final waypoints =
        _destinations.map((e) => '${e.latitude},${e.longitude}').join('|');

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${currentPosition!.latitude},${currentPosition!.longitude}'
      '&destination=${_destinations.last.latitude},${_destinations.last.longitude}'
      '&waypoints=optimize:true|$waypoints'
      '&key=$apiKey',
    );

    final data = json.decode((await http.get(url)).body);
    if (data['status'] != 'OK') return;

    _setPolyline(_decodePolyline(data['routes'][0]['overview_polyline']['points']),
        id: 'optimized', color: Colors.green);
  }

  Future<void> _ensureLocationStream() async {
    if (currentPosition != null) return; 

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
    }
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
      return; 
    }

    currentPosition = await Geolocator.getCurrentPosition();
    notifyListeners();

    Geolocator.getPositionStream().listen((pos) {
      currentPosition = pos;
      _checkArrival();
      notifyListeners();
    });
  }

  LatLng _nearestDestination() {
    _destinations.sort((a, b) {
      final da = Geolocator.distanceBetween(
          currentPosition!.latitude, currentPosition!.longitude, a.latitude, a.longitude);
      final db = Geolocator.distanceBetween(
          currentPosition!.latitude, currentPosition!.longitude, b.latitude, b.longitude);
      return da.compareTo(db);
    });
    return _destinations.first;
  }

  Future<void> _drawRouteTo(LatLng dest) async {
    if (currentPosition == null) return;

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${currentPosition!.latitude},${currentPosition!.longitude}'
      '&destination=${dest.latitude},${dest.longitude}'
      '&key=$apiKey',
    );

    final data = json.decode((await http.get(url)).body);
    if (data['status'] != 'OK') return;

    _setPolyline(_decodePolyline(data['routes'][0]['overview_polyline']['points']),
        id: 'route', color: Colors.blue);
  }

  void _setPolyline(List<LatLng> pts,
      {required String id, required Color color}) {
    _polylines
      ..clear()
      ..add(Polyline(
        polylineId: PolylineId(id),
        points: pts,
        color: color,
        width: 5,
      ));
    notifyListeners();
  }

  void _checkArrival() {
    if (currentPosition == null || _destinations.isEmpty) return;

    for (var dest in List<LatLng>.from(_destinations)) {
      final dist = Geolocator.distanceBetween(
        currentPosition!.latitude,
        currentPosition!.longitude,
        dest.latitude,
        dest.longitude,
      );

      if (dist < 50) {
        _destinations.remove(dest);
        _markers.removeWhere((m) => m.position == dest);
        _polylines.clear();
        _arrivalCallback?.call(dest);

        if (_destinations.isNotEmpty) {
          _drawRouteTo(_nearestDestination());
        }
        break;
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    int index = 0, len = encoded.length, lat = 0, lng = 0;
    final List<LatLng> out = [];

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      out.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return out;
  }
}

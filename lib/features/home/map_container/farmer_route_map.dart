import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent_plus/android_intent.dart';

class FarmerRouteMap extends StatefulWidget {
  const FarmerRouteMap({Key? key}) : super(key: key);

  @override
  State<FarmerRouteMap> createState() => _FarmerRouteMapState();
}

class _FarmerRouteMapState extends State<FarmerRouteMap> {
  late GoogleMapController _mapController;

  final List<LatLng> farmerLocations = [
    LatLng(11.0457494, 79.5509829),
    LatLng(11.0539359, 79.5935277),
    LatLng(11.0751833, 79.5953117),
    LatLng(11.0738617, 79.5895533),
    LatLng(11.0303194, 79.560918),
    LatLng(11.0597099, 79.5837416),
  ];

  Set<Marker> _markers = {};
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};
  final String googleAPIKey = 'YOUR_GOOGLE_API_KEY'; // Replace this

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getDirections();
  }

  void _setMarkers() {
    for (int i = 0; i < farmerLocations.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId("farmer_$i"),
        position: farmerLocations[i],
        infoWindow: InfoWindow(title: "Farmer ${i + 1}"),
      ));
    }
  }

  Future<void> _getDirections() async {
    String origin = "${farmerLocations.first.latitude},${farmerLocations.first.longitude}";
    String destination = "${farmerLocations.last.latitude},${farmerLocations.last.longitude}";
    String waypoints = farmerLocations
        .sublist(1, farmerLocations.length - 1)
        .map((e) => "${e.latitude},${e.longitude}")
        .join('|');

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&waypoints=optimize:true|$waypoints&key=$googleAPIKey';

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    if (data['status'] == 'OK') {
      var points = PolylinePoints().decodePolyline(data['routes'][0]['overview_polyline']['points']);
      polylineCoordinates = points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId("route"),
          points: polylineCoordinates,
          color: Colors.blue,
          width: 4,
        ));
      });
    } else {
      print("Directions API error: ${data['status']}");
    }
  }

  void _launchMultiStopNavigation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      String origin = "${position.latitude},${position.longitude}";
      String destination = "${farmerLocations.last.latitude},${farmerLocations.last.longitude}";
      String waypoints = farmerLocations
          .sublist(0, farmerLocations.length - 1)
          .map((e) => "${e.latitude},${e.longitude}")
          .join('|');

      final url = Uri.encodeFull(
          "https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&waypoints=$waypoints&travelmode=driving");

      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: url,
        package: 'com.google.android.apps.maps',
      );

      await intent.launch();
    } catch (e) {
      print('Error launching intent: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch Google Maps navigation.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Container(
          height: 300,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: farmerLocations[0],
                zoom: 12,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (controller) => _mapController = controller,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _launchMultiStopNavigation,
          icon: Icon(Icons.navigation),
          label: Text("Start Navigation"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}

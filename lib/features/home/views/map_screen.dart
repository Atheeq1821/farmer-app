import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key,this.autoStart = false});
  final bool autoStart;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final MapController _ctrl;

  @override
  void initState() {
    super.initState();

    _ctrl = MapController()..initMarkers();

    _ctrl.onArrival = (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arrived at destination!')),
      );
    };
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ctrl.startTrip());
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) {
        final pos = _ctrl.currentPosition;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Live Route Tracker'),
            actions: [
              IconButton(
                icon: const Icon(Icons.alt_route),
                tooltip: 'Optimise Route',
                onPressed: _ctrl.tripStarted ? _ctrl.optimizeRoute : null,
              ),
            ],
          ),

          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: pos == null
                  ? const LatLng(13.0827, 80.2707) 
                  : LatLng(pos.latitude, pos.longitude),
              zoom: 13,
            ),
            myLocationEnabled: _ctrl.tripStarted,
            myLocationButtonEnabled: true,
            markers: _ctrl.markers,
            polylines: _ctrl.polylines,
          ),

          floatingActionButton: _ctrl.tripStarted
              ? null
              : FloatingActionButton.extended(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Trip'),
                  onPressed: () async {
                    await _ctrl.startTrip();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Trip started')),
                    );
                  },
                ),
        );
      },
    );
  }
}

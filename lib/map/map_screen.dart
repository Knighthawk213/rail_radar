import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rail Radar India'),
      ),
      body: FlutterMap(options: const MapOptions(initialCenter: LatLng(22.5937, 78.9629),
      initialZoom: 5,
      ),
          children:[TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.rail_radar',
          ),
          ],
      ),
    );
  }
}
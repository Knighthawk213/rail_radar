import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rail_radar/state/train_provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rail Radar India'),
      ),
      body: FlutterMap(options: const MapOptions(
        initialCenter: LatLng(22.5937, 78.9629),
        initialZoom: 5,
      ),
          children:[
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.rail_radar',
            ),
            
            Consumer<TrainProvider>(
                builder: (context, provider, _){
                  return MarkerLayer(
                      markers: provider.trains.map((train) {
                        return Marker(
                            point: train.position,
                            child: const Icon(Icons.train, color:Colors.red),
                        );
                      }).toList(),
                  );
                },
            )
          ],
      ),
    );
  }
}
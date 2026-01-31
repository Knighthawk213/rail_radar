import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:rail_radar/data/models/route_model.dart';
import 'package:rail_radar/data/services/route_service.dart';
import 'package:rail_radar/state/train_provider.dart';

class MapScreen extends StatefulWidget{
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  final RouteService _routeService = RouteService();
  RouteModel? route;
  Timer? _timer;

  @override
  void initState(){
    super.initState();

    _routeService.getRoute('delhi_mumbai').then((r) {
      setState(() {
        route = r;
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (_) async{
      final provider = context.read<TrainProvider>();

      if (provider.trains.isEmpty || route == null) return;

      await provider.moveSmoothly(
          provider.trains.first,
          route!,
      );
    });
  }
  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }

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

            if(route != null)
              PolylineLayer(
                  polylines: [
                    Polyline(
                        points: route!.coordinates,
                      strokeWidth: 4,
                      color: Colors.blue,
                    ),
                  ],
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(heroTag: 'pause',
              onPressed: () => context.read<TrainProvider>().pause(),
          child: const Icon(Icons.pause),
          ),
          const SizedBox(height: 10,),
          FloatingActionButton(heroTag: 'resume',
              onPressed: () => context.read<TrainProvider>().resume(),
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}
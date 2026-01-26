import 'package:latlong2/latlong.dart';

class RouteModel {
  final String id;
  final String name;
  final List<LatLng> coordinates;

  RouteModel({
    required this.id,
    required this.name,
    required this.coordinates,
  });

  factory RouteModel.fromFirestore(String id, Map<String, dynamic> data){
    final raw = data['coordinates'] as List<dynamic>;

    final coords = raw.map((point) {
      return LatLng(
          (point['lat'] as num).toDouble(),
          (point['lng'] as num).toDouble(),
      );
    }).toList();

    return RouteModel(
        id: id,
        name: data['name'],
        coordinates: coords,
    );
  }
}
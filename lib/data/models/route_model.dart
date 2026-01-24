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
}
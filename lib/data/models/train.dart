import 'package:latlong2/latlong.dart';

class Train {
  final String id;
  final String name;
  final double speed;
  final String status;
  final String routeId;
  final LatLng position;

  Train({
    required this.id,
    required this.name,
    required this.speed,
    required this.status,
    required this.routeId,
    required this.position,
  });

  factory Train.fromFirestore(String id, Map<String, dynamic> data) {
    final pos = data['position'];

    return Train(
      id: id,
      name: data['name'],
      speed: (data['speed'] as num).toDouble(),
      status: data['status'],
      routeId: data['routeId'],
      position: LatLng(
        (pos['lat'] as num).toDouble(),
        (pos['lng'] as num).toDouble(),
      ),
    );
  }
}

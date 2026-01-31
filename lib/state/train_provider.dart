import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong2/latlong.dart';
import 'package:rail_radar/data/models/route_model.dart';
import 'package:rail_radar/data/models/train.dart';
import 'package:rail_radar/data/services/firestore_service.dart';

class TrainProvider extends ChangeNotifier{
  final FirestoreService _service = FirestoreService();

  List<Train> trains = [];

  TrainProvider() {
    _service.getTrains().listen((data) {
      trains = data;
      notifyListeners();
    });
  }

  bool isPaused = false;
  bool _isMoving = false;
  int _currentIndex = 0;
  bool _forward = true;

  void pause(){
    isPaused = true;
  }

  void resume(){
    isPaused = false;
  }

  LatLng _lerp(LatLng a, LatLng b, double t){
    return LatLng(
        a.latitude + (b.latitude - a.latitude) * t,
        a.longitude + (b.longitude - a.longitude)* t,
    );
  }

  Duration speedtoDelay(double speed){
    if(speed >= 120) return const Duration(milliseconds: 120);
    if(speed >= 80 ) return const Duration(milliseconds: 180);
    return const Duration(milliseconds: 250);
  }

  Future<void> moveSmoothly(
      Train train,
      RouteModel route, {
        int steps = 12,
  }) async {
    if(isPaused || _isMoving) return;

    _isMoving = true;

    if(_forward && _currentIndex >= route.coordinates.length - 1){
      _forward = false;
    } else if(!_forward && _currentIndex <= 0){
      _forward = true;
    }

    final int nextIndex =
        _forward ? _currentIndex + 1 : _currentIndex - 1;

    final start = route.coordinates[_currentIndex];
    final end = route.coordinates[nextIndex];

    final delay = speedtoDelay(train.speed);

    for(int i = 0;i <= steps;i++){
      if (isPaused) break;

      final t = i / steps;
      final point = _lerp(start, end, t);

      await FirebaseFirestore.instance
        .collection('trains')
        .doc(train.id)
        .update({
      'position.lat' : point.latitude,
      'position.lng' : point.longitude,
      });

      await Future.delayed(delay);
    }

    _currentIndex = nextIndex;
    _isMoving = false;
  }
}
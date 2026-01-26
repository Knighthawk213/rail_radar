import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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

  int _currentIndex = 0;

  void moveTrainAlongRoute(Train train, RouteModel route) async{
    if(_currentIndex >= route.coordinates.length) {
      _currentIndex = 0;
    }

    final nextPoint = route.coordinates[_currentIndex];
    _currentIndex++;

    await FirebaseFirestore.instance
        .collection('trains')
        .doc(train.id)
        .update({
      'position.lat': nextPoint.latitude,
      'position.lng': nextPoint.longitude,
    });
  }
}
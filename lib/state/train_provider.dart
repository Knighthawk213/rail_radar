import 'package:flutter/cupertino.dart';
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
}
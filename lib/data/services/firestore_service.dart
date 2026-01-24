import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rail_radar/data/models/train.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Train>> getTrains(){
    return _db.collection('trains').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Train.fromFirestore(doc.id,doc.data()))
          .toList();
    });
  }
}
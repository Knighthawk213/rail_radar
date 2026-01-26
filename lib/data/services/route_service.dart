import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rail_radar/data/models/route_model.dart';

class RouteService {
  final _db = FirebaseFirestore.instance;

  Future<RouteModel> getRoute(String routeId) async{
    final doc = await _db.collection('routes').doc(routeId).get();
    return RouteModel.fromFirestore(doc.id, doc.data()!);
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/trip.dart';

class TripService {
  Future<List<Trip>> readAllTrips() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('trips').get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['tripid'] = doc.id;
      return Trip.fromJson(data);
    }).toList();
  }
}

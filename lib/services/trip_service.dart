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

  Future<Trip?> readTripByTripId(String tripId) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('trips')
          .doc(tripId)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      final data = docSnapshot.data()!;
      data['tripid'] = docSnapshot.id;
      return Trip.fromJson(data);
    } catch (e) {
      print('Error reading trip by ID: $e');
      return null;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_link_carpooling/models/location.dart';

class RideService {
  Future<DocumentReference> createTempRide({
    required Location from,
    required Location to,
    required DateTime date,
    required DateTime time,
    required int seatNumber,
    required double price,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not signed in');
    }
    
    final rideData = {
      'creatorId': user.uid,
      'from': from.toJson(),
      'to': to.toJson(),
      'date': date,
      'time': time,
      'seats': seatNumber,
      'price': price,
      'created_at': FieldValue.serverTimestamp(),
    };

    return await FirebaseFirestore.instance
        .collection('temp_rides')
        .add(rideData);
  }

  Future<Map<String, dynamic>> readCreatorTempRide(String rideId) async {
    final docRef = FirebaseFirestore.instance.collection('temp_rides').doc(rideId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception('Ride not found');
    }

    return docSnapshot.data() as Map<String, dynamic>;
  }

  ///Search for rides matching query
  Future<List<Map<String, dynamic>>> searchRides({
    required Location from,
    required Location to,
    required DateTime date,
    required int seatsNeeded,
    required DateTime time,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // Step 1: Run the filtered query
    final querySnapshot = await firestore
        .collection('temp_rides')
        .where('from.name', isEqualTo: from.name)
        .where('to.name', isEqualTo: to.name)
        .where('date',
            isEqualTo: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day)))
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }

    // Step 2: Fallback — get ALL rides if no match found
    final fallbackSnapshot = await firestore.collection('temp_rides').get();

    return fallbackSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}
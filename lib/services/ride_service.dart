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
        .collection('trips')
        .add(rideData);
  }

  Future<Map<String, dynamic>> readCreatorTempRide(String rideId) async {
    final docRef =
        FirebaseFirestore.instance.collection('trips').doc(rideId);
    final docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      throw Exception('Ride not found');
    }

    return docSnapshot.data() as Map<String, dynamic>;
  }

  /// Search for rides matching query
  Future<List<Map<String, dynamic>>> searchRides({
    required String from,
    required String to,
    required DateTime date,
    required DateTime time,
    required int seatsNeeded,
  }) async {
    final firestore = FirebaseFirestore.instance;

    // Define the start and end of the day to search trips for the whole day
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Adjust this: use the correct collection name!
    final querySnapshot = await firestore
        .collection('trips')
        .where('origin', isEqualTo: from)
        .where('destination', isEqualTo: to)
        .where('departureTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('availableSeats', isGreaterThanOrEqualTo: seatsNeeded)
        .where('status', isEqualTo: 'scheduled')
        .get();

    print('Query found ${querySnapshot.docs.length} trips.');

    // If query returns results, attach rideId and return
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['rideId'] = doc.id;
        return data;
      }).toList();
    }

    // If no results, fallback: return ALL trips so you can debug
    final fallbackSnapshot = await firestore.collection('trips').get();
    print('Fallback fetched ${fallbackSnapshot.docs.length} total trips.');

    final fallbackRides = fallbackSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['rideId'] = doc.id;
      return data;
    }).toList();

    return fallbackRides;
  }
  //Get all rides (Admin)
}

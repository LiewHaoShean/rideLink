import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/rating.dart';

class RatingService {
  final CollectionReference ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');

  // Create a new rating
  Future<void> createRating(Rating rating) async {
    try {
      final docRef = await ratingsCollection.add(rating.toJson());
      await docRef.update({'ratingId': docRef.id});
      print('Rating created successfully with ID: ${docRef.id}');
    } catch (e) {
      print('Error creating rating: $e');
      rethrow;
    }
  }

  // Fetch all ratings by driver ID
  Future<List<Rating>> fetchAllRatingsByDriverId(String driverId) async {
    try {
      final querySnapshot = await ratingsCollection
          .where('driverId', isEqualTo: driverId)
          .orderBy('datetime', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ratingId'] = doc.id;
        return Rating.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error fetching ratings by driver ID: $e');
      return [];
    }
  }

  // Get average rating by driver ID
  Future<double> getAverageRatingByDriverId(String driverId) async {
    try {
      final querySnapshot =
          await ratingsCollection.where('driverId', isEqualTo: driverId).get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0; // No ratings found
      }

      double totalRating = 0.0;
      int count = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRating += (data['rating'] ?? 0.0).toDouble();
        count++;
      }

      return count > 0 ? totalRating / count : 0.0;
    } catch (e) {
      print('Error getting average rating by driver ID: $e');
      return 0.0;
    }
  }

  // Get average ratings by trip ID
  Future<double> getAverageRatingsByTripId(String tripId) async {
    try {
      final querySnapshot =
          await ratingsCollection.where('tripId', isEqualTo: tripId).get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0; // No ratings found
      }

      double totalRating = 0.0;
      int count = 0;

      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        totalRating += (data['rating'] ?? 0.0).toDouble();
        count++;
      }

      return count > 0 ? totalRating / count : 0.0;
    } catch (e) {
      print('Error getting average ratings by trip ID: $e');
      return 0.0;
    }
  }

  // Get rating by rating ID
  Future<Rating?> getRatingById(String ratingId) async {
    try {
      final doc = await ratingsCollection.doc(ratingId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data() as Map<String, dynamic>;
      data['ratingId'] = doc.id;
      return Rating.fromJson(data);
    } catch (e) {
      print('Error getting rating by ID: $e');
      return null;
    }
  }

  // Get all ratings
  Future<List<Rating>> getAllRatings() async {
    try {
      final querySnapshot =
          await ratingsCollection.orderBy('datetime', descending: true).get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['ratingId'] = doc.id;
        return Rating.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting all ratings: $e');
      return [];
    }
  }

  // Update rating
  Future<void> updateRating(String ratingId, double newRating) async {
    try {
      await ratingsCollection.doc(ratingId).update({
        'rating': newRating,
        'datetime': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Error updating rating: $e');
      rethrow;
    }
  }

  // Delete rating
  Future<void> deleteRating(String ratingId) async {
    try {
      await ratingsCollection.doc(ratingId).delete();
    } catch (e) {
      print('Error deleting rating: $e');
      rethrow;
    }
  }
}

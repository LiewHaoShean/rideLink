import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/car_information.dart';
import '../models/trip.dart';
import '../models/booking.dart';
import '../models/transaction.dart';
import '../models/review.dart';
import '../models/balance.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// USERS
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toJson());
  }

  /// CARS
  Future<void> addCar(CarInformation car) async {
    await _db.collection('cars').doc(car.carId).set(car.toJson());
  }

  Future<List<CarInformation>> getCarsByOwner(String ownerId) async {
    final snapshot = await _db
        .collection('cars')
        .where('ownerId', isEqualTo: ownerId)
        .get();

    print("Firestore returned ${snapshot.docs.length} docs");
    return snapshot.docs
        .map((doc) => CarInformation.fromJson(doc.data()))
        .toList();
  }

  Future<CarInformation?> getCarById(String carId) async {
    final doc = await _db.collection('cars').doc(carId).get();
    if (doc.exists) {
      return CarInformation.fromJson(doc.data()!);
    }
    return null;
  }

  /// TRIPS
  Future<void> createTrip(Trip trip) async {
    await _db.collection('trips').doc(trip.tripId).set(trip.toJson());
  }

  Future<List<Trip>> getTrips() async {
    final snapshot = await _db.collection('trips').get();
    return snapshot.docs.map((doc) => Trip.fromJson(doc.data())).toList();
  }

  Future<void> updateTrip(Trip trip) async {
    await _db.collection('trips').doc(trip.tripId).update(trip.toJson());
  }

  /// BOOKINGS
  Future<void> createBooking(Booking booking) async {
    await _db
        .collection('bookings')
        .doc(booking.bookingId)
        .set(booking.toJson());
  }

  Future<List<Booking>> getBookingsByPassenger(String passengerId) async {
    final snapshot = await _db
        .collection('bookings')
        .where('passengerId', isEqualTo: passengerId)
        .get();

    return snapshot.docs.map((doc) => Booking.fromJson(doc.data())).toList();
  }

  /// TRANSACTIONS
  Future<void> createTransaction(TransactionModel transaction) async {
    await _db
        .collection('transactions')
        .doc(transaction.transactionId)
        .set(transaction.toJson());
  }

  Future<List<TransactionModel>> getTransactionsByUser(String userId) async {
    final snapshot = await _db
        .collection('transactions')
        .where('passengerId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromJson(doc.data()))
        .toList();
  }

  /// REVIEWS
  Future<void> addReview(Review review) async {
    await _db.collection('reviews').doc(review.reviewId).set(review.toJson());
  }

  Future<List<Review>> getReviewsForRider(String riderId) async {
    final snapshot = await _db
        .collection('reviews')
        .where('riderId', isEqualTo: riderId)
        .get();

    return snapshot.docs.map((doc) => Review.fromJson(doc.data())).toList();
  }

  /// BALANCE
  Future<void> updateBalance(Balance balance) async {
    await _db.collection('balances').doc(balance.userId).set(balance.toJson());
  }

  Future<Balance?> getBalance(String userId) async {
    final doc = await _db.collection('balances').doc(userId).get();
    if (doc.exists) {
      return Balance.fromJson(doc.data()!);
    }
    return null;
  }
}

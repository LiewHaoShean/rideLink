import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';
import '../models/car_information.dart';
import '../models/trip.dart';
import '../models/booking.dart';
import '../models/transaction.dart';

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
    final snapshot =
        await _db.collection('cars').where('ownerId', isEqualTo: ownerId).get();

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
}

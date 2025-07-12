import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Booking {
  final String bookingId;
  final String tripId;
  final String passengerId;
  final String status; // 'pending', 'confirmed', etc.
  final DateTime createdAt;

  Booking({
    required this.bookingId,
    required this.tripId,
    required this.passengerId,
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      tripId: json['tripId'],
      passengerId: json['passengerId'],
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'tripId': tripId,
      'passengerId': passengerId,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

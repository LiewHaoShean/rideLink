import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String ratingId;
  final String userId;
  final String driverId;
  final String tripId;
  final DateTime datetime;
  final double rating;

  Rating({
    required this.ratingId,
    required this.userId,
    required this.driverId,
    required this.tripId,
    required this.datetime,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    // Handle timestamp conversion
    Timestamp? timestamp = json['datetime'];
    DateTime datetime = timestamp?.toDate() ?? DateTime.now();

    return Rating(
      ratingId: json['ratingId'] ?? '',
      userId: json['userId'] ?? '',
      driverId: json['driverId'] ?? '',
      tripId: json['tripId'] ?? '',
      datetime: datetime,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ratingId': ratingId,
      'userId': userId,
      'driverId': driverId,
      'tripId': tripId,
      'datetime': Timestamp.fromDate(datetime),
      'rating': rating,
    };
  }
}

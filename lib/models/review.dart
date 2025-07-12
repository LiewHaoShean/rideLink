import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String reviewId;
  final String riderId;
  final String passengerId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.riderId,
    required this.passengerId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      riderId: json['riderId'],
      passengerId: json['passengerId'],
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'riderId': riderId,
      'passengerId': passengerId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt,
    };
  }
}

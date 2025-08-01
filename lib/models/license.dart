import 'package:cloud_firestore/cloud_firestore.dart';

class License {
  final String licenseId;
  final String vehicleId;
  final String userId;
  final String status; // 'pending', 'verified', 'rejected'
  final bool isInformed;
  final DateTime createdAt;

  License({
    required this.licenseId,
    required this.vehicleId,
    required this.userId,
    required this.status,
    this.isInformed = true, // Default to true
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory License.fromJson(Map<String, dynamic> json) {
    // Handle timestamp conversion
    Timestamp? timestamp = json['createdAt'];
    DateTime createdAt = timestamp?.toDate() ?? DateTime.now();

    return License(
      licenseId: json['licenseId'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? 'pending',
      isInformed: json['isInformed'] ?? true,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseId': licenseId,
      'vehicleId': vehicleId,
      'userId': userId,
      'status': status,
      'isInformed': isInformed,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

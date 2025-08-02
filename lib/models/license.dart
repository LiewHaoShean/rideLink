import 'package:cloud_firestore/cloud_firestore.dart';

class License {
  final String licenseId;
  final String vehicleId;
  final String userId;
  final String status; // 'pending', 'verified', 'rejected'
  final bool isInformed;
  final DateTime createdAt;
  final String? pdfUrl;
  final String? title;
  final String? description;
  final String? fileName;

  License({
    required this.licenseId,
    required this.vehicleId,
    required this.userId,
    required this.status,
    this.isInformed = true, // Default to true
    DateTime? createdAt,
    this.pdfUrl,
    this.title,
    this.description,
    this.fileName,
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
        pdfUrl: json['pdfUrl'],
        title: json['title'],
        description: json['description'],
        fileName: json['fileName']);
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseId': licenseId,
      'vehicleId': vehicleId,
      'userId': userId,
      'status': status,
      'isInformed': isInformed,
      'createdAt': Timestamp.fromDate(createdAt),
      'pdfUrl': pdfUrl,
      'title': title,
      'description': description,
      'fileName': fileName
    };
  }
}

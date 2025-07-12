import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class AppNotification {
  final String notificationId;
  final String userId;
  final String title;
  final String body;
  final bool seen;
  final DateTime createdAt;

  AppNotification({
    required this.notificationId,
    required this.userId,
    required this.title,
    required this.body,
    required this.seen,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      notificationId: json['notificationId'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
      seen: json['seen'] ?? false,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'title': title,
      'body': body,
      'seen': seen,
      'createdAt': createdAt,
    };
  }
}

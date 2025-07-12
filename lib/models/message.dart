import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Message {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String? tripId;
  final String text;
  final DateTime sentAt;
  final bool read;

  Message({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    this.tripId,
    required this.text,
    required this.sentAt,
    required this.read,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      tripId: json['tripId'],
      text: json['text'],
      sentAt: (json['sentAt'] as Timestamp).toDate(),
      read: json['read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'tripId': tripId,
      'text': text,
      'sentAt': sentAt,
      'read': read,
    };
  }
}

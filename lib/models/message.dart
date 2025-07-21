import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Message {
  final String messageId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime sentAt;
  final bool isRead;
  final String chatId;

  Message({
    required this.messageId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.sentAt,
    required this.isRead,
    required this.chatId,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
        messageId: json['messageId'],
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        text: json['text'],
        sentAt: (json['sentAt'] as Timestamp).toDate(),
        isRead: json['read'] ?? false,
        chatId: json['chatId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'sentAt': sentAt,
      'read': isRead,
      'chatId': chatId
    };
  }
}

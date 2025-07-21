import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Chat {
  final String chatId;
  final List<String> participants;
  final DateTime lastUpdated;
  final bool isAdmin;

  Chat(
      {required this.chatId,
      required this.participants,
      required this.lastUpdated,
      required this.isAdmin});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
        chatId: json['chatId'],
        participants: List<String>.from(json['participants'] ?? []),
        lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
        isAdmin: json['isAdmin']);
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'participants': participants,
      'lastUpdated': lastUpdated,
      'isAdmin': isAdmin
    };
  }
}

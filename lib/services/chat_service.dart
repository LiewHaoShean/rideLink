import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Chat>> getChatsByUserId(String userId) async {
    final snapshot = await _db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .where('isAdmin', isEqualTo: false)
        .orderBy('lastUpdated', descending: false)
        .get();
    return snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList();
  }

  Future<List<Chat>> getChatsByAdminId(String userId) async {
    final snapshot = await _db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .where('isAdmin', isEqualTo: true)
        .orderBy('lastUpdated', descending: false)
        .get();
    return snapshot.docs.map((doc) => Chat.fromJson(doc.data())).toList();
  }

  Future<void> createChat(Chat chat) async {
    await _db.collection('chats').doc(chat.chatId).set(chat.toJson());
  }

  Future<String?> getAdminChatIdByUser(String userId) async {
    final snapshot = await _db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .where('isAdmin', isEqualTo: true)
        .limit(1)
        .get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data()['chatId'] as String;
    }
    return null;
  }
}

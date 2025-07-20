import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ride_link_carpooling/models/message.dart';

class MessageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Create a new message (isRead is always false on creation)
  Future<void> createMessage(Message message) async {
    final docRef = _db.collection('messages').doc(message.messageId);
    await docRef.set({
      ...message.toJson(),
      'read': false, // Ensure isRead is false on creation
      'sentAt': FieldValue.serverTimestamp(),
    });

    await _db.collection('chats').doc(message.chatId).update({
      'lastUpdated': DateTime.now(),
    });
  }

  // Fetch all messages for a chatId, ordered by sentAt
  Future<List<Message>> getMessagesByChatId(String chatId) async {
    final snapshot = await _db
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('sentAt', descending: false)
        .get();
    return snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList();
  }

  // Mark a message as read
  Future<void> markMessageAsRead(String messageId) async {
    await _db.collection('messages').doc(messageId).update({'read': true});
  }
}

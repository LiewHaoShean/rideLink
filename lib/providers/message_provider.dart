import 'package:flutter/material.dart';
import '../models/message.dart';
import '../services/message_service.dart';

class MessageProvider with ChangeNotifier {
  final MessageService _messageService = MessageService();

  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all messages for a chat
  Future<void> loadMessagesByChatId(String chatId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _messages = await _messageService.getMessagesByChatId(chatId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new message
  Future<void> createMessage(Message message) async {
    try {
      await _messageService.createMessage(message);
      // Optionally reload messages for the chat
      await loadMessagesByChatId(message.chatId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Mark a message as read
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _messageService.markMessageAsRead(messageId);
      // Optionally update local state
      final index = _messages.indexWhere((m) => m.messageId == messageId);
      if (index != -1) {
        _messages[index] = Message(
          messageId: _messages[index].messageId,
          senderId: _messages[index].senderId,
          receiverId: _messages[index].receiverId,
          text: _messages[index].text,
          sentAt: _messages[index].sentAt,
          isRead: true,
          chatId: _messages[index].chatId,
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

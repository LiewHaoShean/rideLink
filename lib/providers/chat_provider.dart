import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';
import 'package:nanoid/nanoid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<Chat> _chats = [];
  bool _isLoading = false;
  String? _error;

  List<Chat> get chats => _chats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChatsByUserId(String userId, String type) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    if (type.toLowerCase() == 'user') {
      try {
        _chats = await _chatService.getChatsByUserId(userId);
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    } else {
      try {
        _chats = await _chatService.getChatsByAdminId(userId);
      } catch (e) {
        _error = e.toString();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  void clearChats() {
    _chats = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<String> createChat(
      {required String senderId,
      required String receiverId,
      required bool isAdmin}) async {
    String chatId = nanoid();
    final chat = Chat(
        chatId: chatId,
        participants: [senderId, receiverId],
        lastUpdated: DateTime.now(),
        isAdmin: isAdmin);
    await _chatService.createChat(chat);
    return chatId;
  }

  Future<String?> getCustomerServiceChatId(String userId) async {
    return await _chatService.getAdminChatIdByUser(userId);
  }

  Future<String?> searchChatByReceiverAndSenderId({
    required String senderId,
    required String receiverId,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final chatId = await _chatService.searchChatByReceiverAndSenderId(
        senderId: senderId,
        receiverId: receiverId,
      );

      return chatId;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

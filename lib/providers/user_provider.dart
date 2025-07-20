import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService = UserService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _error;
  String? _userId;

  // Getters
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _userId;

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  // Load all users
  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _userService.readAllUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear users
  void clearUsers() {
    _users = [];
    notifyListeners();
  }

  // Get user by ID
  UserModel? getUserById(String uid) {
    try {
      return _users.firstWhere((user) => user.uid == uid);
    } catch (e) {
      print("Error:");
      print(e);
      return null;
    }
  }

  // Filter users by role
  List<UserModel> getUsersByRole(String role) {
    return _users.where((user) => user.userRole == role).toList();
  }

  // Search users by name or email
  List<UserModel> searchUsers(String query) {
    if (query.isEmpty) return _users;

    return _users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

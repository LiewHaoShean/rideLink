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
      print("here");
      print(_users);
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

  Future<UserModel?> getAdminById(String adminId) async {
    try {
      print(adminId);
      return await _userService.getAdminById(adminId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<UserModel?> getUserDetails(String userId) async {
    try {
      return await _userService.getUserDetails(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<double> getUserCredit(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credit = await _userService.getUserCredit(userId);
      return credit;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add credit to a user
  Future<void> addCredit(String userId, double amount) async {
    try {
      await _userService.addCredit(userId, amount);
      // Optionally update the local user list
      final user = _users.firstWhere((u) => u.uid == userId);
      if (user != null) {
        user.credit += amount;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  //add profit
  Future<void> addProfit(String userId, double amount) async {
    print(userId);
    print(amount);
    try {
      await _userService.addProfit(userId, amount);
      // Optionally update the local user list
      final user = _users.firstWhere((u) => u.uid == userId);
      if (user != null) {
        user.profit += amount;
        notifyListeners();
      }
    } catch (e) {
      print("error: ");
      _error = e.toString();
      print(_error);
      notifyListeners();
    }
  }

  Future<bool> withdrawCredit(String userId, double amount) async {
    try {
      bool success = await _userService.withdrawCredit(userId, amount);
      if (success) {
        // Optionally update local user if you want, or just rely on Firestore
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  //Withdraw
  Future<bool> withdrawProfit(String userId, double amount) async {
    try {
      bool success = await _userService.withdrawProfit(userId, amount);
      if (success) {
        // Optionally update local user if you want, or just rely on Firestore
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateUserDetailsById({
    required String userId,
    String? name,
    String? phone,
    String? icNumber,
    String? gender,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool success = await _userService.updateUserDetailsById(
        userId: userId,
        name: name,
        phone: phone,
        icNumber: icNumber,
        gender: gender,
      );

      if (success) {
        // Update the local user list if the user exists in the list
        final userIndex = _users.indexWhere((user) => user.uid == userId);
        if (userIndex != -1) {
          final currentUser = _users[userIndex];
          final updatedUser = UserModel(
            uid: currentUser.uid,
            name: name ?? currentUser.name,
            email: currentUser.email,
            userRole: currentUser.userRole,
            nic: icNumber ?? currentUser.nic,
            phone: phone ?? currentUser.phone,
            gender: gender ?? currentUser.gender,
            credit: currentUser.credit,
            profit: currentUser.profit,
            isEmailVerified: currentUser.isEmailVerified,
          );
          _users[userIndex] = updatedUser;
        }
        notifyListeners();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateUserSuspendStatus(String userId, bool isBanned) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      bool success =
          await _userService.updateUserSuspendStatus(userId, isBanned);

      if (success) {
        // Update the local user list if the user exists in the list
        final userIndex = _users.indexWhere((user) => user.uid == userId);
        if (userIndex != -1) {
          final currentUser = _users[userIndex];
          final updatedUser = UserModel(
            uid: currentUser.uid,
            name: currentUser.name,
            email: currentUser.email,
            userRole: currentUser.userRole,
            nic: currentUser.nic,
            phone: currentUser.phone,
            gender: currentUser.gender,
            credit: currentUser.credit,
            profit: currentUser.profit,
            isEmailVerified: currentUser.isEmailVerified,
            isBanned: isBanned, // Use the passed parameter
          );
          _users[userIndex] = updatedUser;
        }
        notifyListeners();
      }

      return success;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeUserRole(String userId, String userRole) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userService.changeUserRole(userId, userRole);

      // Update the local user list if the user exists
      final userIndex = _users.indexWhere((user) => user.uid == userId);
      if (userIndex != -1) {
        final currentUser = _users[userIndex];
        final updatedUser = UserModel(
          uid: currentUser.uid,
          name: currentUser.name,
          email: currentUser.email,
          userRole: userRole, // Updated role
          nic: currentUser.nic,
          phone: currentUser.phone,
          gender: currentUser.gender,
          credit: currentUser.credit,
          profit: currentUser.profit,
          isEmailVerified: currentUser.isEmailVerified,
          isBanned: currentUser.isBanned,
        );
        _users[userIndex] = updatedUser;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e; // Re-throw so the calling code can handle the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

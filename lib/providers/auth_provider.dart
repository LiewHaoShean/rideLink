import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await _authService.signUp(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    notifyListeners();
  }

  // Future<void> verifyOtp({
  //   required String email,
  //   required String otp,
  // }) async {
  //   await _authService.verifyOtp(
  //     email: email,
  //     enteredOtp: otp,
  //   );
  //   notifyListeners();
  // }
}

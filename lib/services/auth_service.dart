import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Send OTP and save pending signup to Firestore
  Future<void> signUp({
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      throw Exception('Passwords do not match.');
    }

    try {
      // Example: You should implement your real OTP logic
      // final otp = await _sendOtp(email);

      await _firestore.collection('pending_signups').doc(email).set({
        'email': email,
        'password': password,
        // 'otp': otp,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Maybe handle sign in or throw
        throw FirebaseAuthException(
            code: e.code, message: 'Email is already in use.');
      } else {
        throw e;
      }
    }
  }


  /// Call this when the user taps "Login".
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final auth = FirebaseAuth.instance;

    // Sign in
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Reload the user to get latest verification status
    await userCredential.user?.reload();
    final user = auth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for this email.',
      );
    }

    if (user.emailVerified) {
      // ✅ Update Firestore flag if you store isEmailVerified
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'isEmailVerified': true,
      });
    } else {
      // Optionally send them a new link
      await user.sendEmailVerification();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email. A new link has been sent!',
      );
    }
  }


  /// Verify OTP and complete signup
  Future<void> verifyOtp({
    required String email,
    required String enteredOtp,
  }) async {
    final pendingDoc =
        await _firestore.collection('pending_signups').doc(email).get();
    final pendingData = pendingDoc.data();

    if (pendingData == null) {
      throw Exception('No pending signup found for this email.');
    }

    final savedOtp = pendingData['otp'] ?? '';
    final password = pendingData['password'] ?? '';

    if (enteredOtp != savedOtp) {
      throw Exception('Invalid OTP.');
    }

    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection('pending_signups').doc(email).delete();
  }


  /// This should be your real OTP implementation
  Future<String> _sendOtp(String email) async {
    final generatedOtp = '123456'; // Replace with your logic
    print('Generated OTP: $generatedOtp');
    return generatedOtp;
  }
}

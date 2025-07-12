import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

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
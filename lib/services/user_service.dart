import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_link_carpooling/models/user.dart';

class UserService {
  Future<List<UserModel>> readAllUsers() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    return querySnapshot.docs
        .map((doc) {
          final data = doc.data();
          data['uid'] = doc.id; // Add the document ID as uid
          return UserModel.fromJson(data);
        })
        .where((user) => user.userRole != 'admin') // <-- Exclude admins
        .toList();
  }
}

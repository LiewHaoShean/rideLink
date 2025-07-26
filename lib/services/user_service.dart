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

  Future<UserModel?> getAdminById(String adminId) async {
    print(adminId);
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(adminId).get();
    print("here");
    print(doc);
    if (!doc.exists) return null;
    final data = doc.data()!;
    data['uid'] = doc.id;
    if (data['userRole'] == 'admin') {
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<UserModel?> getUserDetails(String userId) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    // print("heree");
    // print(doc.data());
    if (!doc.exists) return null;
    final data = doc.data()!;
    // print(data);
    data['uid'] = doc.id;
    // print("here");
    // print(UserModel.fromJson(data));
    return UserModel.fromJson(data);
  }

  // Add credit to a user
  Future<void> addCredit(String userId, int amount) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data()!;
    int currentCredit = (data['credit'] ?? 0) as int;
    await docRef.update({'credit': currentCredit + amount});
  }

  // Withdraw profit from a user
  Future<bool> withdrawProfit(String userId, int amount) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await docRef.get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    int currentProfit = (data['profit'] ?? 0) as int;
    if (currentProfit < amount) {
      // Not enough profit, do not deduct
      return false;
    }
    await docRef.update({'profit': currentProfit - amount});
    return true;
  }

  // Update user details by ID
  Future<bool> updateUserDetailsById({
    required String userId,
    String? name,
    String? phone,
    String? icNumber,
    String? gender,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        return false;
      }

      Map<String, dynamic> updateData = {};
      
      if (name != null) updateData['name'] = name;
      if (phone != null) updateData['phone'] = phone;
      if (icNumber != null) updateData['nic'] = icNumber; // nic field in Firestore corresponds to icNumber
      if (gender != null) updateData['gender'] = gender;

      if (updateData.isNotEmpty) {
        await docRef.update(updateData);
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error updating user details: $e');
      return false;
    }
  }
}

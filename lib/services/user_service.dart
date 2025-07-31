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

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Add credit to a user
  Future<void> addCredit(String userId, double amount) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data()!;
    double currentCredit = _parseDouble(data['credit']);
    await docRef.update({'credit': currentCredit + amount});
  }

  //add profit
  Future<void> addProfit(String userId, double amount) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await docRef.get();
    if (!doc.exists) return;
    final data = doc.data()!;
    print("service: ");
    print(data);
    double currentProfit = _parseDouble(data['profit']);
    await docRef.update({'profit': currentProfit + amount});
  }

  //withdraw credit
  Future<bool> withdrawCredit(String userId, double amount) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await docRef.get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    double currentCredit = _parseDouble(data['credit']);
    if (currentCredit < amount) {
      // Not enough credit, do not deduct
      return false;
    }
    await docRef.update({'credit': currentCredit - amount});
    return true;
  }

  // Withdraw profit from a user
  Future<bool> withdrawProfit(String userId, double amount) async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
    final doc = await docRef.get();
    if (!doc.exists) return false;
    final data = doc.data()!;
    double currentProfit = _parseDouble(data['profit']);
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
      if (icNumber != null)
        updateData['nic'] =
            icNumber; // nic field in Firestore corresponds to icNumber
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

  Future<double> getUserCredit(String userId) async {
    try {
      final doc = FirebaseFirestore.instance.collection('users').doc(userId);
      final docSnapshot = await doc.get();

      if (!docSnapshot.exists) {
        return 0.0; // Return 0 if user doesn't exist
      }

      final data = docSnapshot.data()!;
      return _parseDouble(data['credit']);
    } catch (e) {
      print('Error getting user credit: $e');
      return 0.0; // Return 0 on error
    }
  }

  //ban user
  Future<bool> updateUserSuspendStatus(String userId, bool isBanned) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        return false;
      }

      await docRef.update({'isBanned': isBanned});
      return true;
    } catch (e) {
      print('Error updating user ban status: $e');
      return false;
    }
  }

// Change user role
  Future<void> changeUserRole(String userId, String userRole) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'userRole': userRole});
      print(
          'User role changed successfully for user: $userId to role: $userRole');
    } catch (e) {
      print('Error changing user role: $e');
      rethrow;
    }
  }
}

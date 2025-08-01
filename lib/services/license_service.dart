import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/license.dart';

class LicenseService {
  final CollectionReference licensesCollection =
      FirebaseFirestore.instance.collection('licenses');

  // Get all licenses
  Future<List<License>> getAllLicense() async {
    final querySnapshot = await licensesCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['licenseId'] = doc.id; // Add the document ID as licenseId
      return License.fromJson(data);
    }).toList();
  }

  // Get license by license ID
  Future<License?> getLicenseByLicenseId(String licenseId) async {
    try {
      final doc = await licensesCollection.doc(licenseId).get();
      if (!doc.exists) {
        return null;
      }
      final data = doc.data() as Map<String, dynamic>;
      data['licenseId'] = doc.id;
      return License.fromJson(data);
    } catch (e) {
      print('Error getting license by ID: $e');
      return null;
    }
  }

  // Get licenses by status
  Future<List<License>> getLicenseByStatus(String status) async {
    final querySnapshot =
        await licensesCollection.where('status', isEqualTo: status).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['licenseId'] = doc.id;
      return License.fromJson(data);
    }).toList();
  }

  // Get licenses by user ID
  Future<List<License>> getLicenseByUserId(String userId) async {
    final querySnapshot =
        await licensesCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['licenseId'] = doc.id;
      return License.fromJson(data);
    }).toList();
  }

  // Get license status by user ID (returns the most recent license status)
  Future<String> getLicenseStatusByUserId(String userId) async {
    try {
      final querySnapshot = await licensesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true) // Get the most recent license
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 'none'; // No license found
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return data['status'] ?? 'pending';
    } catch (e) {
      print('Error getting license status by user ID: $e');
      return 'none'; // Return 'none' on error
    }
  }

  // Create a new license (check if user already has a license first)
  Future<void> createLicense(License license) async {
    try {
      // Check if user already has a license
      final existingLicenses = await licensesCollection
          .where('userId', isEqualTo: license.userId)
          .get();

      if (existingLicenses.docs.isNotEmpty) {
        throw Exception(
            'User already has a license. Cannot create duplicate license.');
      }

      // If no existing license, create new one
      final docRef = await licensesCollection.add(license.toJson());
      await docRef.update({'licenseId': docRef.id});
    } catch (e) {
      print('Error creating license: $e');
      rethrow;
    }
  }

  // Get license informed status by user ID
  Future<bool> getLicenseIsInformedStatus(String userId) async {
    try {
      final querySnapshot = await licensesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true) // Get the most recent license
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return true; // Default to true if no license found
      }

      final doc = querySnapshot.docs.first;
      final data = doc.data() as Map<String, dynamic>;
      return data['isInformed'] ?? true;
    } catch (e) {
      print('Error getting license informed status: $e');
      return true; // Default to true
    }
  }

  // Change license informed status by user ID
  Future<void> changeLicenseInformedStatus(String userId, bool status) async {
    try {
      final querySnapshot = await licensesCollection
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true) // Get the most recent license
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('No license found for user: $userId');
      }

      final doc = querySnapshot.docs.first;
      await licensesCollection.doc(doc.id).update({'isInformed': status});
    } catch (e) {
      print('Error changing license informed status: $e');
      rethrow;
    }
  }

  // Get licenses with user names
  Future<List<Map<String, dynamic>>> getLicensesWithUserNames() async {
    try {
      final licenses = await getAllLicense();
      List<Map<String, dynamic>> licensesWithNames = [];

      for (License license in licenses) {
        try {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(license.userId)
              .get();

          String userName = 'Unknown User';
          if (userDoc.exists) {
            final userData = userDoc.data()!;
            userName = userData['name'] ?? 'Unknown User';
          }

          licensesWithNames.add({
            'license': license,
            'userName': userName,
          });
        } catch (e) {
          print('Error getting user name for license ${license.licenseId}: $e');
          licensesWithNames.add({
            'license': license,
            'userName': 'Unknown User',
          });
        }
      }

      return licensesWithNames;
    } catch (e) {
      print('Error getting licenses with user names: $e');
      return [];
    }
  }

  // Update license status
  Future<void> updateLicenseStatus(String licenseId, String status) async {
    await licensesCollection.doc(licenseId).update({'status': status});
  }
}

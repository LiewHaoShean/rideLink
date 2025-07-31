import 'package:flutter/material.dart';
import '../services/license_service.dart';
import '../models/license.dart';

class LicenseProvider with ChangeNotifier {
  final LicenseService _licenseService = LicenseService();

  List<License> _licenses = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<License> get licenses => _licenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear licenses
  void clearLicenses() {
    _licenses = [];
    notifyListeners();
  }

  // Get all licenses
  Future<void> getAllLicense() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _licenses = await _licenseService.getAllLicense();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get license by license ID
  Future<License?> getLicenseByLicenseId(String licenseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final license = await _licenseService.getLicenseByLicenseId(licenseId);
      return license;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get licenses by status
  Future<List<License>> getLicenseByStatus(String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final licenses = await _licenseService.getLicenseByStatus(status);
      return licenses;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get licenses by user ID
  Future<List<License>> getLicenseByUserId(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final licenses = await _licenseService.getLicenseByUserId(userId);
      return licenses;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get license status by user ID
  Future<String> getLicenseStatusByUserId(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final status = await _licenseService.getLicenseStatusByUserId(userId);
      return status;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 'none'; // Return 'none' on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new license
  Future<void> createLicense(License license) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _licenseService.createLicense(license);
      await getAllLicense(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e; // Re-throw so the calling code can handle the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get license informed status by user ID
  Future<bool> getLicenseIsInformedStatus(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final isInformed =
          await _licenseService.getLicenseIsInformedStatus(userId);
      return isInformed;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return true; // Default to true
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Change license informed status by user ID
  Future<void> changeLicenseInformedStatus(String userId, bool status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _licenseService.changeLicenseInformedStatus(userId, status);
      await getAllLicense(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e; // Re-throw so the calling code can handle the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get licenses with user names
  Future<List<Map<String, dynamic>>> getLicensesWithUserNames() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final licensesWithNames =
          await _licenseService.getLicensesWithUserNames();
      return licensesWithNames;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update license status
  Future<void> updateLicenseStatus(String licenseId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _licenseService.updateLicenseStatus(licenseId, status);
      await getAllLicense(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

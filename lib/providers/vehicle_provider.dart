import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/car_information.dart';

class VehicleProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<CarInformation> _vehicles = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<CarInformation> get vehicles => _vehicles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all vehicles (if needed)
  Future<void> loadVehicles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      // You may want to implement a getAllCars in FirestoreService if needed
      // For now, just clear the list
      _vehicles = [];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get vehicle by user ID (ownerId)
  Future<CarInformation?> getUserVehicle(String userId) async {
    try {
      final vehicles = await _firestoreService.getCarsByOwner(userId);
      if (vehicles.isNotEmpty) {
        return vehicles.first;
      }
      return null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear vehicles
  void clearVehicles() {
    _vehicles = [];
    notifyListeners();
  }
}

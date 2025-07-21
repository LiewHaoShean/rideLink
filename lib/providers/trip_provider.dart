import 'package:flutter/material.dart';
import '../services/trip_service.dart';
import '../models/trip.dart';

class TripProvider with ChangeNotifier {
  final TripService _tripService = TripService();

  List<Trip> _trips = [];
  bool _isLoading = false;
  String? _error;

  //Getters
  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  //Load all trips
  Future<void> loadTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _trips = await _tripService.readAllTrips();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Trip> searchTrips(String query) {
    if (query.isEmpty) return _trips;

    return _trips.where((trip) {
      return trip.origin.toLowerCase().contains(query.toLowerCase()) ||
          trip.destination.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

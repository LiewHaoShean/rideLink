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
      print(trips);
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

  List<Trip> searchTripsByStatus(String status) {
    if (status.isEmpty) return _trips;

    return _trips.where((trip) {
      return trip.status.toLowerCase() == status.toLowerCase();
    }).toList();
  }

  // Future<Trip?> loadTripByTripId(String tripId) async {
  //   _isLoading = true;
  //   _error = null;
  //   notifyListeners();

  //   try {
  //     final trip = await _tripService.readTripByTripId(tripId);
  //     return trip;
  //   } catch (e) {
  //     _error = e.toString();
  //     return null;
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Trip? loadTripByTripId(String tripId) {
    try {
      print(_trips);
      return _trips.firstWhere((trip) => trip.tripid == tripId);
    } catch (e) {
      print("Error:");
      print(e);
      return null;
    }
  }
}

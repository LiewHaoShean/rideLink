import 'package:flutter/material.dart';
import '../services/rating_service.dart';
import '../models/rating.dart';

class RatingProvider with ChangeNotifier {
  final RatingService _ratingService = RatingService();

  List<Rating> _ratings = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Rating> get ratings => _ratings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Clear ratings
  void clearRatings() {
    _ratings = [];
    notifyListeners();
  }

  // Create a new rating
  Future<void> createRating(Rating rating) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ratingService.createRating(rating);
      await getAllRatings(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e; // Re-throw so the calling code can handle the error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch all ratings by driver ID
  Future<List<Rating>> fetchAllRatingsByDriverId(String driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final ratings = await _ratingService.fetchAllRatingsByDriverId(driverId);
      return ratings;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get average rating by driver ID
  Future<double> getAverageRatingByDriverId(String driverId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final averageRating =
          await _ratingService.getAverageRatingByDriverId(driverId);
      return averageRating;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get average ratings by trip ID
  Future<double> getAverageRatingsByTripId(String tripId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final averageRating =
          await _ratingService.getAverageRatingsByTripId(tripId);
      return averageRating;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get all ratings
  Future<void> getAllRatings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _ratings = await _ratingService.getAllRatings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get rating by ID
  Future<Rating?> getRatingById(String ratingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final rating = await _ratingService.getRatingById(ratingId);
      return rating;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update rating
  Future<void> updateRating(String ratingId, double newRating) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ratingService.updateRating(ratingId, newRating);
      await getAllRatings(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete rating
  Future<void> deleteRating(String ratingId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _ratingService.deleteRating(ratingId);
      await getAllRatings(); // Refresh the list
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      throw e;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

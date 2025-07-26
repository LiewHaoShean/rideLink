import 'package:flutter/material.dart';
import '../models/card.dart';
import '../services/card_service.dart';

class CardProvider with ChangeNotifier {
  final CardService _cardService = CardService();

  List<CardModel> _cards = [];
  bool _isLoading = false;
  String? _error;

  List<CardModel> get cards => _cards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all cards for a user
  Future<void> fetchCardsByUserId(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cards = await _cardService.fetchCardsByUserId(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new card
  Future<void> createCard(CardModel card) async {
    try {
      final createdCard = await _cardService.createCard(card);
      // Optionally, add the new card to the list
      _cards.add(createdCard);
      // Optionally, refresh the list after adding
      await fetchCardsByUserId(card.userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Delete a card by cardId
  Future<void> deleteCardByCardId(String cardId, String userId) async {
    try {
      await _cardService.deleteCardByCardId(cardId);
      _cards.removeWhere((card) => card.cardId == cardId);
      // Optionally, refresh the list after deleting
      await fetchCardsByUserId(userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}

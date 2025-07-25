// lib/services/card_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/card.dart';

class CardService {
  final CollectionReference cardsCollection =
      FirebaseFirestore.instance.collection('cards');

  // Create a new card and return the CardModel with cardId
  Future<CardModel> createCard(CardModel card) async {
    final docRef = await cardsCollection.add(card.toJson());
    await docRef.update({'cardId': docRef.id});
    return CardModel(
      cardId: docRef.id,
      userId: card.userId,
      cardNumber: card.cardNumber,
      expiryDate: card.expiryDate,
      cvv: card.cvv,
    );
  }

  // Fetch all cards by userId
  Future<List<CardModel>> fetchCardsByUserId(String userId) async {
    final querySnapshot =
        await cardsCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) =>
            CardModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Delete a card by cardId
  Future<void> deleteCardByCardId(String cardId) async {
    await cardsCollection.doc(cardId).delete();
  }
}

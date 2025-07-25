// lib/models/card.dart

class CardModel {
  final String cardId; // Firestore document ID
  final String userId;
  final String cardNumber;
  final String expiryDate;
  final String cvv;

  CardModel({
    required this.cardId,
    required this.userId,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
  });

  factory CardModel.fromJson(Map<String, dynamic> json, String id) {
    return CardModel(
      cardId: id,
      userId: json['userId'],
      cardNumber: json['cardNumber'],
      expiryDate: json['expiryDate'],
      cvv: json['cvv'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
    };
  }
}

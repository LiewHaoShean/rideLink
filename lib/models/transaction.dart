import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class TransactionModel {
  final String transactionId;
  final String? rideId;
  final String userId;
  final double amount;
  final String type; // 'rider', 'top-up', 'withdraw', 'passenger'
  final DateTime timestamp;

  TransactionModel({
    required this.transactionId,
    this.rideId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.timestamp,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'],
      rideId: json['rideId'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'rideId': rideId,
      'userId': userId,
      'amount': amount,
      'type': type,
      'timestamp': timestamp,
    };
  }
}

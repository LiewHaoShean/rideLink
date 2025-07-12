import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class TransactionModel {
  final String transactionId;
  final String passengerId;
  final String riderId;
  final String? rideId;
  final double amount;
  final String status; // 'pending', 'completed', etc.
  final DateTime createdAt;

  TransactionModel({
    required this.transactionId,
    required this.passengerId,
    required this.riderId,
    this.rideId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      transactionId: json['transactionId'],
      passengerId: json['passengerId'],
      riderId: json['riderId'],
      rideId: json['rideId'],
      amount: (json['amount'] as num).toDouble(),
      status: json['status'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'passengerId': passengerId,
      'riderId': riderId,
      'rideId': rideId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt,
    };
  }
}

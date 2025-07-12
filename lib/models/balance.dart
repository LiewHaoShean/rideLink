import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Balance {
  final String userId;
  final double currentBalance;
  final double totalEarned;
  final double totalSpent;
  final DateTime lastUpdated;

  Balance({
    required this.userId,
    required this.currentBalance,
    required this.totalEarned,
    required this.totalSpent,
    required this.lastUpdated,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      userId: json['userId'],
      currentBalance: (json['currentBalance'] as num).toDouble(),
      totalEarned: (json['totalEarned'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentBalance': currentBalance,
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'lastUpdated': lastUpdated,
    };
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart';

class TransactionService {
  final CollectionReference transactionsCollection =
      FirebaseFirestore.instance.collection('transactions');

  // Create a new transaction
  Future<void> createTransaction(TransactionModel transaction) async {
    final docRef = await transactionsCollection.add(transaction.toJson());
    await docRef.update({'transactionId': docRef.id});
  }

  // Fetch all transactions
  Future<List<TransactionModel>> fetchAllTransaction() async {
    final querySnapshot = await transactionsCollection
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<TransactionModel>> fetchAllTransactionByUserId(
      String userId) async {
    final querySnapshot = await transactionsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<TransactionModel?> getTransactionById(String transactionId) async {
    try {
      final doc = await transactionsCollection.doc(transactionId).get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data() as Map<String, dynamic>;
      return TransactionModel.fromJson(data);
    } catch (e) {
      print('Error getting transaction by ID: $e');
      return null;
    }
  }

  // Calculate total transaction amount
  Future<double> calculateTotalTransactionAmount() async {
    final querySnapshot = await transactionsCollection.get();
    double totalAmount = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] as num).toDouble();
      totalAmount += amount;
    }

    return totalAmount;
  }

  // Calculate total transaction amount by user ID
  Future<double> calculateTotalTransactionAmountByUserId(String userId) async {
    final querySnapshot =
        await transactionsCollection.where('userId', isEqualTo: userId).get();
    double totalAmount = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] as num).toDouble();
      totalAmount += amount;
    }

    return totalAmount;
  }

  // Calculate monthly transaction amount
  Future<double> calculateMonthlyTransactionAmount() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final querySnapshot = await transactionsCollection
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('timestamp', isLessThanOrEqualTo: endOfMonth)
        .get();

    double totalAmount = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] as num).toDouble();
      totalAmount += amount;
    }

    return totalAmount;
  }

  // Calculate monthly transaction amount by user ID
  Future<double> calculateMonthlyTransactionAmountByUserId(
      String userId) async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    final querySnapshot = await transactionsCollection
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThanOrEqualTo: startOfMonth)
        .where('timestamp', isLessThanOrEqualTo: endOfMonth)
        .get();

    double totalAmount = 0.0;

    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final amount = (data['amount'] as num).toDouble();
      totalAmount += amount;
    }

    return totalAmount;
  }
}

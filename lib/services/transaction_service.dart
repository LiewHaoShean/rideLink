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
    final querySnapshot = await transactionsCollection.get();
    return querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<TransactionModel>> fetchAllTransactionByUserId(
      String userId) async {
    final querySnapshot =
        await transactionsCollection.where('userId', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) =>
            TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

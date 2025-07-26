import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all transactions
  Future<void> fetchAllTransaction() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _transactions = await _transactionService.fetchAllTransaction();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new transaction
  Future<void> createTransaction(TransactionModel transaction) async {
    try {
      await _transactionService.createTransaction(transaction);
      await fetchAllTransaction();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchAllTransactionByUserId(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _transactions =
          await _transactionService.fetchAllTransactionByUserId(userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

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

  Future<TransactionModel?> getTransactionById(String transactionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final transaction =
          await _transactionService.getTransactionById(transactionId);
      return transaction;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate total transaction amount
  Future<double> calculateTotalTransactionAmount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final totalAmount =
          await _transactionService.calculateTotalTransactionAmount();
      return totalAmount;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate total transaction amount by user ID
  Future<double> calculateTotalTransactionAmountByUserId(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final totalAmount = await _transactionService
          .calculateTotalTransactionAmountByUserId(userId);
      return totalAmount;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate monthly transaction amount
  Future<double> calculateMonthlyTransactionAmount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final monthlyAmount =
          await _transactionService.calculateMonthlyTransactionAmount();
      return monthlyAmount;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate monthly transaction amount by user ID
  Future<double> calculateMonthlyTransactionAmountByUserId(
      String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final monthlyAmount = await _transactionService
          .calculateMonthlyTransactionAmountByUserId(userId);
      return monthlyAmount;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return 0.0;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

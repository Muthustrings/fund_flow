import 'package:flutter/material.dart';
import 'package:fund_flow/user_session.dart'; // Import user_session

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category; // Add category field

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    this.category = 'Uncategorized', // Default category
  });

  // Helper to check if the transaction is an income
  bool get isIncome => type == TransactionType.income;
}

enum TransactionType { income, expense }

class TransactionService extends ChangeNotifier {
  final UserSession userSession; // Add UserSession
  final List<Transaction> _transactions = [];

  TransactionService({required this.userSession}); // Constructor to inject UserSession

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  double getTotalIncome() {
    return _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double getTotalExpenses() {
    return _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  List<Transaction> getRecentTransactions({int limit = 5}) {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    return _transactions.take(limit).toList();
  }

  List<Transaction> getAllTransactions() {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(_transactions);
  }
}

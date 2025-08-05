import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fund_flow/transaction_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilterChip(
                  label: const Text('Date'),
                  onSelected: (bool selected) {},
                ),
                FilterChip(
                  label: const Text('Type'),
                  onSelected: (bool selected) {},
                ),
                FilterChip(
                  label: const Text('Category'),
                  onSelected: (bool selected) {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Consumer<TransactionService>(
                builder: (context, transactionService, child) {
                  final allTransactions = transactionService
                      .getAllTransactions();
                  if (allTransactions.isEmpty) {
                    return const Center(child: Text('No transactions yet.'));
                  }
                  return ListView.builder(
                    itemCount: allTransactions.length,
                    itemBuilder: (context, index) {
                      final item = allTransactions[index];
                      return TransactionTile(
                        icon: item.type == TransactionType.income
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: item.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                        title: item.description,
                        type: item.type == TransactionType.income
                            ? 'INCOME'
                            : 'EXPENSE',
                        amount: '₹${item.amount.toStringAsFixed(2)}',
                        date:
                            '${item.date.day}/${item.date.month}/${item.date.year}',
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final String type;
  final String amount;
  final String date;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    required this.type,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(type, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            if (subtitle != null) Text(subtitle!),
            Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        trailing: Text(
          amount,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}

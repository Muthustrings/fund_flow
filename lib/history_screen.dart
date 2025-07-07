import 'package:flutter/material.dart';

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
              child: ListView(
                children: const [
                  TransactionTile(
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                    title: 'Salary',
                    type: 'INCOME',
                    amount: '₹50,000',
                    date: 'Today',
                  ),
                  TransactionTile(
                    icon: Icons.arrow_downward,
                    color: Colors.red,
                    title: 'Food',
                    subtitle: 'Lunch with friends',
                    type: 'EXPENSE',
                    amount: '₹350',
                    date: 'Today',
                  ),
                  TransactionTile(
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                    title: 'Gift',
                    type: 'INCOME',
                    amount: '₹2,000',
                    date: 'Yesterday',
                  ),
                  TransactionTile(
                    icon: Icons.arrow_downward,
                    color: Colors.red,
                    title: 'Shopping',
                    type: 'EXPENSE',
                    amount: '₹1,200',
                    date: 'Yesterday',
                  ),
                  TransactionTile(
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                    title: 'Freelance',
                    type: 'INCOME',
                    amount: '₹1,500',
                    date: '22 Apr 2024',
                  ),
                ],
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

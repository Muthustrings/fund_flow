import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fund_flow/home_screen.dart';
import 'package:fund_flow/user_session.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _expenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _incomeController.text = userSession.monthlyIncomeTarget?.toStringAsFixed(0) ?? '60000';
    _expenseController.text = userSession.monthlyExpenseLimit?.toStringAsFixed(0) ?? '40000';
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(userName: userSession.name ?? 'User'),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'FundFlow',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      HomeScreen(userName: userSession.name ?? 'User'),
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget & Savings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                _buildTargetCard(
                  icon: Icons.attach_money,
                  title: 'Monthly Income Target',
                  controller: _incomeController,
                ),
                const SizedBox(height: 16),
                _buildTargetCard(
                  icon: Icons.arrow_forward,
                  title: 'Monthly Expense Limit',
                  controller: _expenseController,
                ),
                const SizedBox(height: 32),
                _buildSavingsGoal(),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveBudget,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Save & Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveBudget() async {
    final income = double.tryParse(_incomeController.text);
    final expense = double.tryParse(_expenseController.text);

    if (income != null && expense != null) {
      await userSession.saveBudget(incomeTarget: income, expenseLimit: expense);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget saved successfully!')),
      );
      setState(() {}); // Rebuild to update savings goal
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numbers for budget.')),
      );
    }
  }

  Widget _buildTargetCard({
    required IconData icon,
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: '₹ ',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              suffixIcon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsGoal() {
    final income = userSession.monthlyIncomeTarget ?? 0;
    final expense = userSession.monthlyExpenseLimit ?? 0;
    final savings = income - expense;
    final total = income;

    double savingsPercentage = 0;
    double expensePercentage = 0;

    if (total > 0) {
      savingsPercentage = (savings / total) * 100;
      expensePercentage = (expense / total) * 100;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.savings, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Monthly Savings Goal',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: savingsPercentage,
                          title: '',
                          radius: 20,
                        ),
                        PieChartSectionData(
                          color: Colors.grey.shade300,
                          value: expensePercentage,
                          title: '',
                          radius: 20,
                        ),
                      ],
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${expensePercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text('Expenses'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text('${savingsPercentage.toStringAsFixed(0)}% Savings')),
        ],
      ),
    );
  }
}

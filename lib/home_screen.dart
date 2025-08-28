import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import flutter_svg
import 'package:fund_flow/add_expense_screen.dart';
import 'package:fund_flow/add_income_screen.dart'; // Add this import
import 'package:fund_flow/app_theme.dart';
import 'package:fund_flow/budget_screen.dart';
import 'package:fund_flow/history_screen.dart';
import 'package:fund_flow/profile_screen.dart';
import 'package:fund_flow/transaction_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final String userName;
  const HomeScreen({super.key, required this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions(BuildContext context, String userName) =>
      <Widget>[
        HomeScreenContent(userName: userName),
        const HistoryScreen(),
        const AddIncomeScreen(), // This will be replaced by a modal or direct navigation
        const BudgetScreen(),
        const ProfileScreen(),
      ];

  void _onItemTapped(int index) {
    if (index == 2) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            color: AppColors.cardBackground,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.arrow_upward, color: AppColors.primary),
                    title: const Text('Add Income', style: TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.arrow_downward, color: Colors.red),
                    title: const Text('Add Expense', style: TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _widgetOptions(context, widget.userName).elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/home.svg', colorFilter: ColorFilter.mode(_selectedIndex == 0 ? AppColors.primary : Colors.grey, BlendMode.srcIn), height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/history.svg', colorFilter: ColorFilter.mode(_selectedIndex == 1 ? AppColors.primary : Colors.grey, BlendMode.srcIn), height: 24),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/budget.svg', colorFilter: ColorFilter.mode(_selectedIndex == 3 ? AppColors.primary : Colors.grey, BlendMode.srcIn), height: 24),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/icons/profile.svg', colorFilter: ColorFilter.mode(_selectedIndex == 4 ? AppColors.primary : Colors.grey, BlendMode.srcIn), height: 24),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  final String userName;
  const HomeScreenContent({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, $userName 👋',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildBalanceCard(context),
            const SizedBox(height: 20),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            _buildRecentTransactions(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 200,
          child: Consumer<TransactionService>(
            builder: (context, transactionService, child) {
              final monthlyIncome = transactionService.transactions
                  .where((t) => t.isIncome)
                  .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
              final monthlyExpenses = transactionService.transactions
                  .where((t) => !t.isIncome)
                  .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);

              final List<BarChartGroupData> barGroups = [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: monthlyIncome,
                      color: AppColors.primary,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: monthlyExpenses,
                      color: AppColors.accent,
                      width: 16,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                  showingTooltipIndicators: [0],
                ),
              ];

              return BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          String text;
                          switch (value.toInt()) {
                            case 0:
                              text = 'Income';
                              break;
                            case 1:
                              text = 'Expenses';
                              break;
                            default:
                              text = '';
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 4,
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                        reservedSize: 20,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '₹${value.toInt()}',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  gridData: const FlGridData(show: false),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '₹${rod.toY.toStringAsFixed(0)}',
                          const TextStyle(color: AppColors.textPrimary),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0, // Remove elevation for a flatter look
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), // More rounded corners
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Consumer<TransactionService>(
          builder: (context, transactionService, child) {
            final monthlyIncome = transactionService.transactions
                .where((t) => t.isIncome)
                .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
            final monthlyExpenses = transactionService.transactions
                .where((t) => !t.isIncome)
                .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
            final savings = monthlyIncome - monthlyExpenses;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Monthly Income',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${monthlyIncome.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Icon(Icons.arrow_downward, color: AppColors.primary, size: 20),
                      ],
                    ),
                    const SizedBox(width: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.red, size: 28),
                            Text(
                            ' ${monthlyExpenses.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Expenses',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: monthlyIncome > 0 ? (savings / monthlyIncome).clamp(0.0, 1.0) : 0.0,
                            strokeWidth: 6,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                          Text(
                            '${(monthlyIncome > 0 ? (savings / monthlyIncome) * 100 : 0).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          Icons.add,
          'Add Income',
          AppColors.primary,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
            );
          },
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          context,
          Icons.add,
          'Add Expense',
          AppColors.accent,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, Color color, VoidCallback onPressed) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Spending Breakdown',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        _buildSpendingChart(context), // Pie Chart
        const SizedBox(height: 20),
        _buildBarChart(context), // Bar Chart
      ],
    );
  }

  Widget _buildSpendingChart(BuildContext context) {
    return Card(
      color: AppColors.cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 200,
          child: Consumer<TransactionService>(
            builder: (context, transactionService, child) {
              final monthlyIncome = transactionService.transactions
                  .where((t) => t.isIncome)
                  .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
              final monthlyExpenses = transactionService.transactions
                  .where((t) => !t.isIncome)
                  .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);
              final travelExpenses = transactionService.transactions
                  .where((t) => !t.isIncome && t.category == 'Travel')
                  .fold<double>(0.0, (sum, transaction) => sum + transaction.amount);

              final List<PieChartSectionData> sections = [
                PieChartSectionData(
                  color: AppColors.primary,
                  value: monthlyIncome,
                  title: '',
                  radius: 60,
                ),
                PieChartSectionData(
                  color: AppColors.accent,
                  value: monthlyExpenses,
                  title: '',
                  radius: 60,
                ),
                PieChartSectionData(
                  color: AppColors.secondaryAccent,
                  value: travelExpenses,
                  title: '',
                  radius: 60,
                ),
              ];

              return Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 0,
                        sectionsSpace: 0,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(
                        color: AppColors.primary,
                        text: 'Income',
                        value: '₹${monthlyIncome.toStringAsFixed(0)}',
                      ),
                      _LegendItem(
                        color: AppColors.accent,
                        text: 'Expense',
                        value: '₹${monthlyExpenses.toStringAsFixed(0)}',
                      ),
                      _LegendItem(
                        color: AppColors.secondaryAccent,
                        text: 'Travel',
                        value: '₹${travelExpenses.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.text,
    required this.value,
  });

  final Color color;
  final String text;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 50, // Adjust width as needed
            child: Text(text, style: const TextStyle(color: AppColors.textPrimary)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

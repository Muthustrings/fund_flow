import 'package:flutter/material.dart';
import 'package:fund_flow/home_screen.dart'; // Import HomeScreen
import 'package:fund_flow/transaction_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  _AddIncomeScreenState createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final Uuid uuid = const Uuid();

  @override
  void dispose() {
    _sourceController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveIncome() {
    if (_formKey.currentState!.validate()) {
      final transactionService = Provider.of<TransactionService>(
        context,
        listen: false,
      );
      final newTransaction = Transaction(
        id: uuid.v4(),
        description: _sourceController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate,
        type: TransactionType.income,
      );
      transactionService.addTransaction(newTransaction);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(userName: transactionService.userSession.name ?? 'User'),
        ),
        (route) => false, // Remove all routes below the new route
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Income'),
        backgroundColor: Colors.teal.shade50,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.teal.shade50,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField(
                  controller: _sourceController,
                  labelText: 'Source of Income',
                  hintText: 'Salary, Freelance',
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _amountController,
                  labelText: 'Amount',
                  hintText: '₹0.00',
                  icon: Icons.currency_rupee,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                _buildDateField(context),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _notesController,
                  labelText: 'Notes',
                  hintText: 'Add some notes',
                  icon: Icons.note_outlined,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saveIncome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A69A),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Save Income',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Recent Income',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Consumer<TransactionService>(
                  builder: (context, transactionService, child) {
                    final recentIncomes = transactionService.transactions
                        .where((t) => t.type == TransactionType.income)
                        .take(5)
                        .toList();
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: recentIncomes.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text('No recent income added.'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: recentIncomes.length,
                              itemBuilder: (context, index) {
                                final item = recentIncomes[index];
                                return ListTile(
                                  title: Text(item.description),
                                  trailing: Text(
                                    '₹ ${item.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        if (keyboardType == TextInputType.number) {
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date',
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
        ),
        child: Text(
          '${_selectedDate.toLocal()}'.split(' ')[0],
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

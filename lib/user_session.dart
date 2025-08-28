import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() => _instance;

  UserSession._internal();

  String? name;
  String? email;
  String? password;
  double? monthlyIncomeTarget;
  double? monthlyExpenseLimit;

  Future<void> saveUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPassword', password);
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('userName');
    email = prefs.getString('userEmail');
    password = prefs.getString('userPassword');
    monthlyIncomeTarget = prefs.getDouble('monthlyIncomeTarget');
    monthlyExpenseLimit = prefs.getDouble('monthlyExpenseLimit');
  }

  Future<void> saveBudget({
    required double incomeTarget,
    required double expenseLimit,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('monthlyIncomeTarget', incomeTarget);
    await prefs.setDouble('monthlyExpenseLimit', expenseLimit);
    monthlyIncomeTarget = incomeTarget;
    monthlyExpenseLimit = expenseLimit;
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userPassword');
    await prefs.remove('monthlyIncomeTarget');
    await prefs.remove('monthlyExpenseLimit');
    name = null;
    email = null;
    password = null;
    monthlyIncomeTarget = null;
    monthlyExpenseLimit = null;
  }
}

final userSession = UserSession();

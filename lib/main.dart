import 'package:flutter/material.dart';
import 'package:fund_flow/splash_screen.dart';
import 'package:fund_flow/transaction_service.dart';
import 'package:fund_flow/user_session.dart'; // Import UserSession
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await userSession.loadUser(); // Load user data at app start

  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionService(userSession: userSession),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FundFlow',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Poppins'),
      home: const SplashScreen(),
    );
  }
}

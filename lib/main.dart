import 'package:flutter/material.dart';
import 'package:fund_flow/home_screen.dart';
import 'package:fund_flow/splash_screen.dart';
import 'package:fund_flow/transaction_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TransactionService(),
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

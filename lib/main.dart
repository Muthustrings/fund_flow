import 'package:flutter/material.dart';
import 'package:fund_flow/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FundFlow',
      theme: ThemeData(primarySwatch: Colors.teal, fontFamily: 'Poppins'),
      home: const HomeScreen(userName: 'Guest'), // Always show HomeScreen first
    );
  }
}

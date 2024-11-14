import 'package:flutter/material.dart';
import 'package:kasir/cashier_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cashier App',
      home: const CashierPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:app/components/Paymentmethod.dart';
import '../components/Lottery.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            PaymentMethod(),
            // แสดง component Lottery
          ],
        ),
      ),
    );
  }
}

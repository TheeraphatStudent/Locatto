import 'package:app/components/MainLayout.dart';
import 'package:app/components/Paymentmethod.dart';
import 'package:app/components/TotalPrice.dart';
import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Page")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TotalPrice(
              price: 1500,
              coin: 20,
              itemCount: 5,
              onPay: () {
                // ใส่ logic เมื่อกดปุ่มชำระเงิน
              },
            ),
            // แสดง component Lottery
          ],
        ),
      ),
    );
  }
}

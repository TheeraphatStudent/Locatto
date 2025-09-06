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
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('แจ้งเตือน'),
                    content: const Text('คุณกดปุ่มชำระเงินแล้ว!'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('ปิด'),
                      ),
                    ],
                  ),
                );
              },
            ),
            // แสดง component Lottery
          ],
        ),
      ),
    );
  }
}

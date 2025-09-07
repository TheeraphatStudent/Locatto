import 'package:app/components/TotalPrice.dart';
import 'package:app/components/statusLottery.dart';
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
            StatusLottery(
              period: '31 สิงหาคม 2565',
              status: 'กำลังรอ...',
              rewards: [
                {'number': '871955', 'type': '-', 'amount': 1, 'prize': '-'},
                {'number': '871945', 'type': '-', 'amount': 12, 'prize': '-'},
              ],
              backgroundColor: Colors.red.shade50, // สีพื้นหลัง
              statusColor: Colors.yellow.shade200, // สีของ status
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

// class PurchasePage extends StatelessWidget {
//   const PurchasePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

//     final purchase = args?['purchase'] ?? {};
//     final payment = args?['payment'] ?? {};
//     final lottery = args?['lottery'] ?? '';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('สำเร็จ'),
//         backgroundColor: Colors.green,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Icon(
//               Icons.check_circle,
//               color: Colors.green,
//               size: 64,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'การซื้อหวยสำเร็จ!',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'รายละเอียดการซื้อ:',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             _buildDetailRow('เลขหวย:', lottery),
//             _buildDetailRow('จำนวนใบ:', purchase['lot_amount']?.toString() ?? 'N/A'),
//             _buildDetailRow('ราคารวม:', '฿${payment['revenue']?.toString() ?? 'N/A'}'),
//             _buildDetailRow('ผู้ให้บริการ:', payment['provider'] ?? 'N/A'),
//             _buildDetailRow('รหัสการซื้อ:', purchase['pid']?.toString() ?? 'N/A'),
//             const SizedBox(height: 32),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.popUntil(context, ModalRoute.withName('/'));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//                 ),
//                 child: const Text(
//                   'กลับสู่หน้าหลัก',
//                   style: TextStyle(color: Colors.white, fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }
// }

class SuccessPage extends StatefulWidget {
  const SuccessPage({super.key});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  int _countdown = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown >= 1) {
          _countdown--;
        } else {
          _timer?.cancel();
          Navigator.pushReplacementNamed(context, '/purchase');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              alignment: Alignment.center,
              'assets/images/thankyou_2.png',
              width: 256,
            ),
            SizedBox(height: 64),
            Text(
              '$_countdown',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 12,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 2),
            Text(
              textAlign: TextAlign.center,
              'ขอบคุณสำหรับการสั่งซื้อเมี๋ยวว~~',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 18,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                _timer?.cancel();
                Navigator.pushReplacementNamed(context, '/purchase');
              },
              child: Text(
                'ดูรายการสั่งซื้อที่นี่',
                style: TextStyle(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

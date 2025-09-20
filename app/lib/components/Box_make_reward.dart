import 'package:flutter/material.dart';
import 'package:app/service/lottery/post.dart'; // Import LotteryService

class Box_make_reward extends StatelessWidget {
  final TextEditingController numberController =
      TextEditingController(); // Controller สำหรับ TextField

  Box_make_reward({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "สร้างรางวัล (สุ่มตามจำนวน)",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // TextField สำหรับกรอกจำนวน
          TextField(
            controller: numberController, // เชื่อมต่อกับ Controller
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "จำนวน",
              suffixText: "ใบ",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ปุ่มดำเนินการและยกเลิก
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // ยกเลิกและกลับไปหน้าก่อนหน้า
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text("ยกเลิก", style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      if (numberController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('กรุณากรอกจำนวน')),
                        );
                        return;
                      }
                      final int count = int.parse(
                        numberController.text,
                      ); // ดึงค่าจาก TextField
                      final lotteryService =
                          LotteryService(); // สร้าง instance ของ LotteryService
                      final response = await lotteryService.generateLotteries(
                        count,
                      ); // เรียก API
                      print('Lotteries generated: $response');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'สร้างรางวัลสำเร็จ: ${response['message']}',
                          ),
                        ),
                      );
                    } catch (e) {
                      print('Failed to generate lotteries: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "ดำเนินการ",
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

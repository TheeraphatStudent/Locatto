import 'dart:ui'; // สำหรับเบลอพื้นหลัง
import 'package:app/components/Tag.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class PurchaseLotteryCard extends StatelessWidget {
  final String period; // งวด
  final String status; // สถานะ
  final List<Map<String, dynamic>> rewards; // รายละเอียดรางวัล
  final Color backgroundColor; // สีพื้นหลัง
  final Color? statusColor; // สีของ status (optional เพราะจะใช้ auto color)

  const PurchaseLotteryCard({
    super.key,
    required this.period,
    required this.status,
    required this.rewards,
    this.backgroundColor = Colors.white, // ค่าเริ่มต้นเป็นสีขาว
    this.statusColor, // ไม่ต้องกำหนดค่าเริ่มต้น จะใช้ auto color
  });

  // Helper function สำหรับแปลง status text
  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case "win":
        return "ถูกรางวัล";
      case "pending":
        return "กำลังรอ";
      case "fail":
      case "lose":
        return "ไม่ถูกรางวัล";
      default:
        return status;
    }
  }

  // Helper function สำหรับกำหนดสี status
  Color _getStatusColor(String status) {
    if (statusColor != null) return statusColor!; // ถ้าส่งสีมาให้ใช้สีนั้น

    switch (status.toLowerCase()) {
      case "win":
        return AppColors.success;
      case "pending":
        return AppColors.secondary;
      case "fail":
      case "lose":
        return AppColors.primary;
      default:
        return Colors.grey;
    }
  }

  // Helper function สำหรับจัดรูปแบบวันที่
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 16, right: 16),
      decoration: BoxDecoration(
        color: backgroundColor, // ใช้สีพื้นหลังที่รับมา
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // งวดและสถานะ
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDate(period), // ใช้ _formatDate เพื่อจัดรูปแบบวันที่
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Tag(
                text: _getStatusText(status), // ใช้ text ที่แปลงแล้ว
                textColor: Colors.white, // ใช้ตัวอักษรสีขาว
                backgroundColor: _getStatusColor(
                  status,
                ), // ใช้สีที่เหมาะสมกับ status
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              // Replace or remove the undefined method call
              print("Show status lottery dialog logic here");
            },
            child: const Text(
              'รายละเอียด',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // หัวข้อ
          Row(
            children: [
              Expanded(
                flex: 2,
                child: const Text(
                  'เลขรางวัล',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: const Text(
                  'ประเภทรางวัล',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: const Text(
                  'จำนวน',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: const Text(
                  'รางวัล',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // รายละเอียดรางวัล
          Column(
            children: rewards.map((reward) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        reward['number'] ?? '-',
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        _getStatusText(
                          reward['type'] ?? '-',
                        ), // แปลง status ในรายการด้วย
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'x${reward['amount'] ?? '-'}',
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        reward['prize'] ?? '-',
                        style: const TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const Divider(color: Colors.grey, thickness: 1, height: 16),
          // วิธีรับรางวัล
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'วิธีรับรางวัล',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  // ใส่ logic สำหรับการรับรางวัล
                },
                child: const Text(
                  'รับเอง',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
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

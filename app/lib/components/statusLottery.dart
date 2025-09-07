import 'dart:ui'; // สำหรับเบลอพื้นหลัง
import 'package:flutter/material.dart';

void showStatusLotteryDialog(
  BuildContext context,
  StatusLottery statusLottery,
) {
  showDialog(
    context: context,
    barrierDismissible: true, // กดพื้นที่นอก dialog เพื่อปิดได้
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // เบลอพื้นหลัง
        child: Dialog(
          insetPadding: EdgeInsets.zero, // ลบ padding รอบ Dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width, // กว้าง
            height: MediaQuery.of(context).size.height * 0.4, //สูง
            child: statusLottery,
          ),
        ),
      );
    },
  );
}

class StatusLottery extends StatelessWidget {
  final String period; // งวด
  final String status; // สถานะ
  final List<Map<String, dynamic>> rewards; // รายละเอียดรางวัล
  final Color backgroundColor; // สีพื้นหลัง
  final Color statusColor; // สีของ status

  const StatusLottery({
    super.key,
    required this.period,
    required this.status,
    required this.rewards,
    this.backgroundColor = Colors.white, // ค่าเริ่มต้นเป็นสีขาว
    this.statusColor = Colors.yellow, // ค่าเริ่มต้นเป็นสีเหลือง
  });

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
                period,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor, // ใช้สีของ status ที่รับมา
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
              showStatusLotteryDialog(
                context,
                StatusLottery(
                  period: period,
                  status: status,
                  rewards: rewards,
                  backgroundColor: backgroundColor,
                  statusColor: statusColor,
                ),
              );
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
                    fontSize: 14,
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
                    fontSize: 14,
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
                    fontSize: 14,
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
                    fontSize: 14,
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
                        reward['type'] ?? '-',
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

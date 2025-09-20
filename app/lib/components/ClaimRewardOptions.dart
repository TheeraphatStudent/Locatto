import 'package:flutter/material.dart';

/// A widget to display reward claiming options in a styled card.
class ClaimRewardOptions extends StatefulWidget {
  const ClaimRewardOptions({super.key});

  @override
  State<ClaimRewardOptions> createState() => _ClaimRewardOptionsState();
}

class _ClaimRewardOptionsState extends State<ClaimRewardOptions> {
  String? selectedMethod;

  final List<Map<String, dynamic>> rewardOptions = [
    {'method': 'รับเอง', 'fee': 'ฟรี'},
    {'method': 'รับผ่าน Lotto Coin', 'fee': 'ฟรี'},
    {'method': 'รับผ่านธนาคาร', 'fee': '40 บาท'},
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350, // กำหนดความกว้างของการ์ด
        height: 200, // กำหนดความสูงของการ์ดเพื่อป้องกันการขยายเต็มจอ
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'วิธีรับรางวัล',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF45171D),
                    fontSize: 20, // เพิ่มขนาดตัวอักษร
                  ),
                ),
                Text(
                  'ค่าบริการ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF45171D),
                    fontSize: 20, // เพิ่มขนาดตัวอักษร
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            ...rewardOptions.map(
              (option) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedMethod = option['method'];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            selectedMethod == option['method']
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: Colors.pink,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            option['method'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        option['fee'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

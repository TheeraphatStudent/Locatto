import 'package:flutter/material.dart';

/// A widget to display selected lottery numbers.
class ShowNumberSelect extends StatelessWidget {
  const ShowNumberSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16.0),
        SelectedNumberCard(
          selectedNumbers: [
            {'number': '871955', 'count': 1},
            {'number': '871945', 'count': 12},
            {'number': '871955', 'count': 1},
          ],
        ),
      ],
    );
  }
}

class SelectedNumberCard extends StatelessWidget {
  final List<Map<String, dynamic>> selectedNumbers;

  const SelectedNumberCard({super.key, required this.selectedNumbers});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // กำหนดความกว้างของการ์ด
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF8F8F8),
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
                'เลขรางวัล',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF45171D),
                  fontSize: 20,
                ),
              ),
              Text(
                'จำนวน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF45171D),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          ...selectedNumbers.map(
            (number) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  number['number'],
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18, // เพิ่มขนาดตัวอักษร
                  ),
                ),
                Text(
                  'x${number['count']}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 18, // เพิ่มขนาดตัวอักษร
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

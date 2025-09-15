import 'package:flutter/material.dart';

class RandomLotto extends StatelessWidget {
  const RandomLotto({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          MediaQuery.of(context).size.width *
          0.85, // กำหนดความกว้าง 85% ของหน้าจอ
      constraints: const BoxConstraints(
        maxHeight: 400, // จำกัดความสูงไม่เกิน 400
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // สีพื้นหลัง
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
          // หัวข้อ
          Row(
            children: [
              Expanded(
                flex: 2, // กำหนด flex ให้เหมือนกับคอลัมน์ด้านล่าง
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
                flex: 3, // กำหนด flex ให้เหมือนกับคอลัมน์ด้านล่าง
                child: const Text(
                  'เลขรางวัล',
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
          // รายการรางวัล
          Column(
            children: [
              _buildRewardRow('รางวัลที่ 1', '-'),
              _buildRewardRow('รางวัลที่ 2', '-'),
              _buildRewardRow('รางวัลที่ 3', '-'),
              _buildRewardRow('เลขท้าย 3 ตัว', '-'),
              _buildRewardRow('เลขท้าย 2 ตัว', '-'),
            ],
          ),
          const SizedBox(height: 16),
          // ปุ่มสุ่มรางวัลทันทีและตามเลขที่ถูกขาย
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Logic สำหรับสุ่มรางวัลทันที
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: const Text(
                  'สุ่มรางวัลทันที',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logic สำหรับตามเลขที่ถูกขาย
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: const Text(
                  'ตามเลขที่ถูกขาย',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardRow(String rewardType, String rewardNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2, // กำหนด flex ให้เหมือนกับหัวข้อด้านบน
            child: Text(
              rewardType,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 3, // กำหนด flex ให้เหมือนกับหัวข้อด้านบน
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rewardNumber,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

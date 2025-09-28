import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class ShowCoins extends StatelessWidget {
  final int coinCount; // จำนวนเหรียญที่จะแสดง

  const ShowCoins({super.key, required this.coinCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 102),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ), // ลด padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.0), // ลดความมน
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 18, // ลดขนาด
            height: 18, // ลดขนาด
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.secondaryLight, AppColors.secondaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                'assets/images/coin.png',
                width: 14,
                height: 14,
              ),
            ),
          ),
          const SizedBox(width: 6), // ลดระยะห่าง
          Text(
            coinCount > 0 ? '$coinCount' : 'ยังไม่มีเหรีญ?',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12, // ลดขนาดฟอนต์
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ShowCoins extends StatelessWidget {
  final int coinCount; // จำนวนเหรียญที่จะแสดง

  const ShowCoins({super.key, required this.coinCount});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10.0, // ปรับตำแหน่งให้ต่ำลงอีก
      left: 16.0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/coin.png', width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              coinCount > 0
                  ? 'เหรียญที่มี: $coinCount'
                  : 'ยังไม่มีเหรียญ?', // แสดงข้อความตามจำนวนเหรียญ
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

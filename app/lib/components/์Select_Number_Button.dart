import 'package:flutter/material.dart';

class Select_Number_Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const Select_Number_Button ({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180, // กำหนดขนาดตามภาพ (ปรับได้)
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[100], // สีพื้นหลังตามภาพ
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // ขอบโค้ง
          ),
          elevation: 3, // เงาเล็กน้อย
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

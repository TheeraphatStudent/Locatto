import 'package:flutter/material.dart';

class ActiveButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ActiveButton({
    required this.label,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // กว้างเต็มความกว้างของ container แม่ (เหมือนปุ่ม login ส่วนใหญ่)
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 239, 69, 80), // ปุ่มสีฟ้าแบบ login ทั่วไป
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // มุมโค้งเล็กน้อย
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

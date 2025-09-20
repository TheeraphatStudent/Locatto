import 'package:flutter/material.dart';

class UserNavigator extends StatelessWidget {
  final String currentPage; // ข้อความที่แสดงในส่วนตรงกลาง
  final String confirmText; // ข้อความที่แสดงในปุ่มยืนยัน
  final Color centerColor; // สีของส่วนตรงกลาง
  final VoidCallback onConfirm; // ฟังก์ชันที่เรียกเมื่อกดปุ่มยืนยัน

  const UserNavigator({
    super.key,
    required this.currentPage,
    required this.confirmText,
    this.centerColor = Colors.white, // สีเริ่มต้นของส่วนตรงกลาง
    required this.onConfirm, // กำหนดฟังก์ชัน callback
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ), // เพิ่มระยะห่างจากขอบหน้าจอ
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // นำทางกลับไปหน้าก่อนหน้า
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "<",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ),
          ),
          SizedBox(width: 7), // เพิ่มระยะห่างระหว่างปุ่มซ้ายและส่วนตรงกลาง
          Expanded(
            flex: 3, // เพิ่ม flex ของส่วนตรงกลางเพื่อให้ปุ่มข้างเล็กลง
            child: Container(
              width: double.infinity,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: centerColor, // ใช้สีที่กำหนดใน centerColor
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  currentPage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18, // เพิ่มขนาดตัวอักษร
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 7), // เพิ่มระยะห่างระหว่างส่วนตรงกลางและปุ่มขวา
          Expanded(
            flex: 1,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed:
                    onConfirm, // เรียกฟังก์ชัน callback เมื่อกดปุ่มยืนยัน
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ">",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      confirmText,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

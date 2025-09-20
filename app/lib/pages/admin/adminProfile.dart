import 'package:app/components/MainLayout.dart';
import 'package:app/components/adminFooter.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ข้อมูลโปรไฟล์ผู้ดูแลระบบ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'ชื่อ: Admin',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              'อีเมล: admin@locatto.com',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            SizedBox(height: 8),
            Text(
              'บทบาท: ผู้ดูแลระบบ',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

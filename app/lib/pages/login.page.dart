import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow, // เปลี่ยนเป็นสีเหลือง
      body: SafeArea(
        child: Stack(
          children: [
            // พื้นหลังแดงแบบโค้ง
            Positioned.fill(child: CustomPaint(painter: _RedCurvePainter())),
            // เนื้อหาเดิม
            SingleChildScrollView(
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Logo & Title
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: 0,
                            ), // ปรับ margin เป็น 0
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/images/logo_primary.png',
                                  height: 80,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Lotcatto',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF5A5F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 150), // ขยับฟิลด์ลงมาจากโลโก้
                          // Email Input
                          TextField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'อีเมลล์',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '* โปรดกรอกอีเมลล์ หรือ เบอร์โทรศัพท์',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Password Input
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'รหัสผ่าน',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '* อย่าลืมกรอกรหัสผ่านนะ',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'จำรหัสผ่านได้มั้ยนะ?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // ปุ่มและข้อความด้านล่างสุด
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            // ปุ่มไม่มีบัญชี
                            onPressed: () {},
                            child: const Text(
                              'ยังไม่มีบัญชีหรอ?',
                              style: TextStyle(
                                color: Colors.yellow,
                                decoration: TextDecoration.underline,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFFFF5A5F),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                elevation: 4,
                                alignment: Alignment.centerLeft, // ปุ่มชิดซ้าย
                              ),
                              //action ปุ่ม
                              onPressed: () {},
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // ขยับข้อความไปตรงกลาง
                                children: [
                                  const Text(
                                    'ไปกันเลย!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFFFF5A5F),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

// เปลี่ยนชื่อคลาสและสี
class _RedCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFFE5654); // สีแดง
    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width,
      size.height * 0.05,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

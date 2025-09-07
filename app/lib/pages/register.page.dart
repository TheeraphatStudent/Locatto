import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFE5654),
        child: CustomPaint(
          painter: YellowAccentPainter(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                const Center(
                  child: SizedBox(width: 500, height: 120, child: Avatar()),
                ),
                const SizedBox(height: 50),
                const Input(
                  labelText: "ชื่อ-นามสกุล",
                  hintText: "โปรดระบุชื่อ-สกุล",
                ),
                const SizedBox(height: 10),
                Text(
                  "*โปรดระบุชื่อ-นามสกุล",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.yellow),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Input(
                            labelText: "เลขบัตรประชาชน",
                            hintText: "โปรดระบุเลขบัตรประชาชน",
                          ),
                          const Text(
                            "* โปรดระบุเลขบัตรประชาชน",
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Input(
                            labelText: "เบอร์โทร",
                            hintText: "000-000-0000",
                          ),
                          const Text(
                            "* โปรดระบุเบอร์โทร",
                            style: TextStyle(color: Colors.yellow),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Input(labelText: "อีเมล", hintText: "โปรดระบุอีเมล"),
                    const Text(
                      "* โปรดระบุอีเมล",
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Input(
                      labelText: "รหัสผ่าน",
                      hintText: "อย่าลืมกรอกรหัสผ่านนะ",
                    ),
                    const Text(
                      "* อย่าลืมกรอกรหัสผ่านนะ",
                      style: TextStyle(color: Colors.yellow),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    "มีบัญชีแล้ว?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ButtonActions(
                  text: "สมัครเลย",
                  onPressed: () {
                    // Handle registration logic
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class YellowAccentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

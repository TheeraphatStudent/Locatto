import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/Dialogue.dart';
import 'package:app/service/auth.dart';
import 'package:app/type/register.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _cardIdController = TextEditingController();
  final _telnoController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _creditController = TextEditingController();
  final _role = TextEditingController();

  final _auth = Auth();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullnameController.dispose();
    _cardIdController.dispose();
    _telnoController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _creditController.dispose();
    super.dispose();
  }

  String? _validateFullname(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกชื่อ-นามสกุล';
    }
    if (value.length < 2) {
      return 'ชื่อ-นามสกุลต้องมีอย่างน้อย 2 ตัวอักษร';
    }
    return null;
  }

  String? _validateCardId(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกเลขบัตรประชาชน';
    }
    if (value.length != 13) {
      return 'เลขบัตรประชาชนต้องมี 13 หลัก';
    }
    if (!RegExp(r'^\d{13}$').hasMatch(value)) {
      return 'เลขบัตรประชาชนต้องเป็นตัวเลขเท่านั้น';
    }
    return null;
  }

  String? _validateTelno(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกเบอร์โทรศัพท์';
    }
    if (value.length != 10) {
      return 'เบอร์โทรศัพท์ต้องมี 10 หลัก';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'เบอร์โทรศัพท์ต้องเป็นตัวเลขเท่านั้น';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมลล์';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'กรุณากรอกอีเมลล์ที่ถูกต้อง';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกชื่อผู้ใช้';
    }
    if (value.length < 3) {
      return 'ชื่อผู้ใช้ต้องมีอย่างน้อย 3 ตัวอักษร';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกรหัสผ่าน';
    }
    if (value.length < 6) {
      return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
    }
    return null;
  }

  String? _validateCredit(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกจำนวนเครดิต';
    }
    final credit = int.tryParse(value);
    if (credit == null) {
      return 'จำนวนเครดิตต้องเป็นตัวเลข';
    }
    if (credit < 0) {
      return 'จำนวนเครดิตต้องไม่ติดลบ';
    }
    return null;
  }

  void _showCreditDialog() {
    _creditController.clear();
    DynamicDialog.show(
      context,
      title: 'จำนวนเครดิตเริ่มต้น',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'กรุณากรอกจำนวนเครดิตที่ต้องการให้ผู้ใช้เริ่มต้น',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF45171D),
              fontFamily: 'Kanit',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _creditController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'จำนวนเครดิต',
              hintText: '0',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: _validateCredit,
          ),
        ],
      ),
      actions: [
        DialogButton(
          text: 'ยกเลิก',
          onPressed: () => Navigator.of(context).pop(),
          backgroundColor: const Color(0xFF6C757D),
        ),
        DialogButton(
          text: 'ดำเนินการ',
          onPressed: () {
            Navigator.of(context).pop();
            _handleRegistration();
          },
          backgroundColor: const Color(0xFF28A745),
        ),
      ],
    );
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Validate credit input
    final creditValidation = _validateCredit(_creditController.text);
    if (creditValidation != null) {
      setState(() {
        _errorMessage = creditValidation;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final registerData = Register(
        fullname: _fullnameController.text.trim(),
        telno: _telnoController.text,
        cardId: _cardIdController.text,
        email: _emailController.text.trim(),
        img: '',
        username: _usernameController.text.trim(),
        password: _passwordController.text,
        credit: int.parse(_creditController.text),
      );

      final response = await _auth.register(registerData);

      if (response['success'] == true) {
        if (mounted) {
          DialogHelper.showSuccess(
            context,
            title: 'สมัครสมาชิกสำเร็จ!',
            message: 'บัญชีของคุณถูกสร้างเรียบร้อยแล้ว',
            actions: [
              DialogButton(
                text: 'เข้าสู่ระบบ',
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          );
        }
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'การสมัครสมาชิกล้มเหลว';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการสมัครสมาชิก';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFE5654),
        child: CustomPaint(
          painter: YellowAccentPainter(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const Center(
                    child: SizedBox(width: 500, height: 120, child: Avatar()),
                  ),
                  const SizedBox(height: 50),
                  Input(
                    controller: _fullnameController,
                    labelText: "ชื่อ-นามสกุล",
                    hintText: "โปรดระบุชื่อ-สกุล",
                    validator: _validateFullname,
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
                              controller: _cardIdController,
                              labelText: "เลขบัตรประชาชน",
                              hintText: "โปรดระบุเลขบัตรประชาชน",
                              validator: _validateCardId,
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
                              controller: _telnoController,
                              labelText: "เบอร์โทร",
                              hintText: "000-000-0000",
                              validator: _validateTelno,
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
                      Input(
                        controller: _emailController,
                        labelText: "อีเมล",
                        hintText: "โปรดระบุอีเมล",
                        validator: _validateEmail,
                      ),
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
                      Input(
                        controller: _usernameController,
                        labelText: "ชื่อผู้ใช้",
                        hintText: "โปรดระบุชื่อผู้ใช้",
                        validator: _validateUsername,
                      ),
                      const Text(
                        "* โปรดระบุชื่อผู้ใช้",
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Input(
                        controller: _passwordController,
                        labelText: "รหัสผ่าน",
                        hintText: "อย่าลืมกรอกรหัสผ่านนะ",
                        obscureText: true,
                        validator: _validatePassword,
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
                  // Error message display
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontFamily: 'Kanit',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  if (_errorMessage != null) const SizedBox(height: 16),
                  ButtonActions(
                    text: _isLoading ? "กำลังดำเนินการ..." : "สมัครเลย",
                    onPressed: _isLoading ? null : _showCreditDialog,
                  ),
                ],
              ),
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

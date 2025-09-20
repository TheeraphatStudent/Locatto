import 'dart:developer';

import 'package:app/components/Alert.dart';
import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/Dialogue.dart';
import 'package:app/components/redcurve.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:app/style/theme.dart';
import 'package:app/type/register.dart';
import 'package:app/utils/response_helper.dart';
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
  final _creditController = TextEditingController(text: '100');
  // final _role = TextEditingController();

  final responseHelper = ResponseHelper();
  AlertMessage alert = AlertMessage();

  final _auth = Auth();
  final _userService = UserService();
  bool _isLoading = false;

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

  Future<void> _handleRegistration() async {
    log('=== _handleRegistration called ===');

    if (!_formKey.currentState!.validate()) {
      log('Form validation failed');
      return;
    }

    final email = _emailController.text.trim();
    final isAdmin = email.contains('admin');

    log('Email: $email, isAdmin: $isAdmin');

    if (!isAdmin) {
      log('Showing credit dialog for non-admin user');
      showCreateMoneyDialog(context, (value) {
        log('Credit dialog confirmed with value: $value');
        _creditController.text = value;
        _performRegistration();
      }, initialValue: _creditController.text);
      return;
    }

    log('Admin user detected, proceeding directly to registration');
    await _performRegistration();
  }

  Future<void> _performRegistration() async {
    log('=== _performRegistration called ===');
    log('Credit controller text: ${_creditController.text}');

    final creditValidation = _validateCredit(_creditController.text);

    if (creditValidation != null) {
      log('Credit validation failed: $creditValidation');
      alert.showError(context, creditValidation);
      return;
    }

    log('Setting loading state to true');
    setState(() {
      _isLoading = true;
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

      log('Register data prepared: ${registerData.toJson()}');

      final response = await _auth.register(registerData);

      log('Registration response received');
      log('Response: $response');
      log('Response status code: ${response['statusCode']}');

      if (responseHelper.isSuccess(response['statusCode'] as int)) {
        log('Registration successful');
        if (mounted) {
          alert.showSuccess(context, 'สมัครสมาชิกสำเร็จ!');

          final userData = response['data']?['user'] ?? response['user'];
          if (userData != null) {
            await _userService.storeUserData(userData);
            final credit =
                userData['credit']?.toString() ?? _creditController.text;
            await _userService.storeUserCredit(credit);
          }

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              log('Navigating to login page');
              Navigator.pushNamed(context, '/login');
            }
          });
        }
      } else {
        log('Registration failed with status: ${response['statusCode']}');
        if (mounted) {
          alert.showError(
            context,
            response['message'] ?? 'การสมัครสมาชิกล้มเหลว',
          );
        }
      }
    } catch (e) {
      log('Registration error: $e');
      if (mounted) {
        alert.showError(context, 'เกิดข้อผิดพลาดในการสมัครสมาชิก');
      }
    } finally {
      log('Setting loading state to false');
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
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Stack(
          children: [
            // พื้นหลังแดงแบบโค้ง
            Positioned.fill(child: CustomPaint(painter: RedCurvePainter())),
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
                    children: [
                      // const Center(
                      //   child: SizedBox(
                      //     width: 500,
                      //     height: 120,
                      //     child: Avatar(),
                      //   ),
                      // ),

                      // const SizedBox(height: 20),
                      Expanded(
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(child: Avatar()),

                                const SizedBox(height: 20),
                                // Full Name Field
                                Input(
                                  controller: _fullnameController,
                                  labelText: "ชื่อ-นามสกุล",
                                  hintText: "โปรดระบุชื่อ-สกุล",
                                  materialIcon: Icons.person,
                                  validator: _validateFullname,
                                ),
                                const SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: Input(
                                        controller: _cardIdController,
                                        labelText: "เลขบัตรประชาชน",
                                        hintText: "โปรดระบุเลขบัตรประชาชน",
                                        materialIcon: Icons.credit_card,
                                        validator: _validateCardId,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Input(
                                        controller: _telnoController,
                                        labelText: "เบอร์โทร",
                                        hintText: "000-000-0000",
                                        materialIcon: Icons.phone,
                                        validator: _validateTelno,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Email Field
                                Input(
                                  controller: _emailController,
                                  labelText: "อีเมล",
                                  hintText: "โปรดระบุอีเมล",
                                  materialIcon: Icons.email,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 16),

                                // Username Field
                                Input(
                                  controller: _usernameController,
                                  labelText: "ชื่อผู้ใช้",
                                  hintText: "โปรดระบุชื่อผู้ใช้",
                                  materialIcon: Icons.account_circle,
                                  validator: _validateUsername,
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                Input(
                                  controller: _passwordController,
                                  labelText: "รหัสผ่าน",
                                  hintText: "อย่าลืมกรอกรหัสผ่านนะ",
                                  materialIcon: Icons.lock,
                                  obscureText: true,
                                  validator: _validatePassword,
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Action buttons at bottom
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: const Text(
                              'มีบัญชีแล้ว?',
                              style: TextStyle(
                                color: Colors.yellow,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.yellow,
                                fontSize: 16,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ButtonActions(
                            text: _isLoading ? "กำลังดำเนินการ..." : "สมัครเลย",
                            onPressed: _isLoading ? null : _handleRegistration,
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

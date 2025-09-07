import 'dart:developer';

import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/redcurve.dart';
import 'package:app/service/auth.dart';
import 'package:app/style/theme.dart';
import 'package:app/type/login.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = Auth();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณากรอกอีเมลล์หรือเบอร์โทรศัพท์';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'กรุณากรอกอีเมลล์หรือเบอร์โทรศัพท์ที่ถูกต้อง';
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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final loginData = Login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final response = await _auth.login(loginData);

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('เข้าสู่ระบบสำเร็จ'),
              backgroundColor: Colors.green,
            ),
          );

          final role = response['role'];

          switch (role) {
            case 'admin':
              Navigator.pushReplacementNamed(context, '/admin');
              break;
            default:
              Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        log(response.toString());

        setState(() {
          _errorMessage = response['message'] ?? 'เข้าสู่ระบบล้มเหลว';
        });
      }
    } catch (e) {
      log(e.toString());

      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
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
                      // Logo at top
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
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF5A5F),
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Centered input section with full height
                      Expanded(
                        child: Center(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Username/Email Field
                                Input(
                                  controller: _usernameController,
                                  labelText: 'อีเมลล์หรือเบอร์',
                                  hintText: 'กรุณากรอกอีเมลล์',
                                  materialIcon: Icons.email,
                                  validator: _validateUsername,
                                  onChanged: (value) {
                                    if (_errorMessage != null) {
                                      setState(() {
                                        _errorMessage = null;
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 16),
                                // Password Field
                                Input(
                                  controller: _passwordController,
                                  labelText: 'รหัสผ่าน',
                                  hintText: 'กรุณากรอกรหัสผ่าน',
                                  materialIcon: Icons.lock,
                                  obscureText: true,
                                  validator: _validatePassword,
                                  onChanged: (value) {
                                    if (_errorMessage != null) {
                                      setState(() {
                                        _errorMessage = null;
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 8),
                                // Error Message Display
                                if (_errorMessage != null)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary.withOpacity(
                                        0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                    child: Text(
                                      _errorMessage!,
                                      style: const TextStyle(
                                        color: AppColors.secondary,
                                        fontFamily: 'Kanit',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
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
                              Navigator.pushNamed(context, '/register');
                            },
                            child: const Text(
                              'ยังไม่มีบัญชี?',
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
                            text: 'เข้าสู่ระบบ',
                            onPressed: _isLoading ? null : _handleLogin,
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

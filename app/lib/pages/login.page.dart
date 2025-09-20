import 'dart:developer';

import 'package:app/components/Alert.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/redcurve.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:app/style/theme.dart';
import 'package:app/type/login.dart';
import 'package:app/utils/response_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  AlertMessage alert = AlertMessage();

  final _auth = Auth();
  final responseHelper = ResponseHelper();
  final _userService = UserService();

  bool _isLoading = false;

  _LoginPageState() {
    alert = AlertMessage();
  }

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
    log('Handle login work');

    if (!_formKey.currentState!.validate()) {
      log('Form is not valid');
      alert.showError(context, 'กรุณากรอกอีเมลล์หรือเบอร์โทรศัพท์และรหัสผ่าน');
      return;
    }

    log('Form is valid');

    setState(() {
      _isLoading = true;
    });

    try {
      final loginData = Login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final response = await _auth.login(loginData);

      log('Login response: $response');
      log('Status code: ${response['statusCode']}');

      if (responseHelper.isSuccess(response['statusCode'] as int)) {
        if (mounted) {
          alert.showSuccess(context, 'เข้าสู่ระบบสำเร็จ');

          final userData = response['data']?['user'] ?? response['user'];
          if (userData != null) {
            final credit = userData['credit']?.toString() ?? '0';

            await _userService.storeUserCredit(credit);
            await _userService.storeUserData(userData);

            final role = userData['role'];

            switch (role) {
              case 'admin':
                Navigator.pushReplacementNamed(context, '/adminHome');
                break;
              default:
                Navigator.pushReplacementNamed(context, '/home');
            }
          } else {
            log('User data not found in response');
            alert.showError(context, 'ข้อมูลผู้ใช้ไม่ถูกต้อง');
          }
        }
      } else {
        log('Login failed with response: $response');

        if (mounted) {
          final errorMessage =
              response['message'] ??
              response['data']?['message'] ??
              'เข้าสู่ระบบล้มเหลว';
          alert.showError(context, errorMessage);
        }
      }
    } catch (e) {
      log('Login error: $e');

      if (mounted) {
        alert.showError(context, 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ');
      }
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
                            text: _isLoading
                                ? 'กำลังเข้าสู่ระบบ...'
                                : 'เข้าสู่ระบบ',
                            onPressed: _isLoading
                                ? null
                                : () {
                                    log('Button pressed, calling _handleLogin');
                                    _handleLogin();
                                  },
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

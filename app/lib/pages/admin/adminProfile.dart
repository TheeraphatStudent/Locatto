import 'package:app/components/MainLayout.dart';
import 'package:app/components/Button.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final Auth _auth = Auth();
  final UserService _userService = UserService();
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() {
      _isLoggingOut = true;
    });

    try {
      final response = await _auth.logout();

      log('Logout response: $response');

      await _userService.clearUserData();

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      log('Logout error: $e');
      if (mounted) {
        await _userService.clearUserData();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ข้อมูลโปรไฟล์ผู้ดูแลระบบ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'ชื่อ: Admin',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              'อีเมล: admin@locatto.com',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            const Text(
              'บทบาท: ผู้ดูแลระบบ',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 48),
            ButtonActions(
              variant: ButtonVariant.primary,
              hasShadow: true,
              text: _isLoggingOut ? 'กำลังออกจากระบบ...' : 'ออกจากระบบ',
              icon: Icons.logout,
              onPressed: _isLoggingOut ? null : _handleLogout,
            ),
          ],
        ),
      ),
    );
  }
}

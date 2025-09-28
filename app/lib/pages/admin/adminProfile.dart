import 'package:app/components/MainLayout.dart';
import 'package:app/components/Button.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/components/Avatar.dart';
import 'dart:developer';
import 'package:app/pages/admin/adminProfile_detail.dart';

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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 20),
          Center(child: Avatar(state: AvatarState.view, size: 120)),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: () {
              log('Navigating to AdminProfileDetail'); // เพิ่ม log เพื่อตรวจสอบ
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminProfileDetail()),
              );
            },
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: 100, minHeight: 100),
              child: Container(
                width: double.infinity,
                height: 100,
                padding: const EdgeInsets.all(6),
                decoration: ShapeDecoration(
                  color: const Color(0x33FD5553),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFFFFE2E2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 27,
                  children: [
                    Text(
                      'ข้อมูลส่วนตัว',
                      style: TextStyle(
                        color: AppColors.onBackground /* Lottocat-Black */,
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
    );
  }
}

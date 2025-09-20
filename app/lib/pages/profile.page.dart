import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

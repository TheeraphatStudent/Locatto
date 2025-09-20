import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:app/pages/profile_detail.dart';
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
          ///////////////////////////
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const Profile_Detail()),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0,50,0,50),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 206, 197),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const Text(
                "ข้อมูลส่วนตัว",
                style: TextStyle(
                  fontSize: 18, 
                  //fontWeight: FontWeight.bold,                
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          ////////////////////////////
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

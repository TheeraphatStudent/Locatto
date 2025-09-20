import 'package:app/components/Showcoins.dart';
import 'package:app/service/user.dart';
import 'package:app/style/theme.dart';
import 'package:app/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:developer';
import '../providers/user_provider.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {
  late Timer _timer;
  String _currentTime = '';
  String _userRole = 'user';

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _updateTime();
    _loadUserRole();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  Future<void> _loadUserRole() async {
    final role = await _userService.getUserRole();

    log("Role: ${role.toString()}");

    if (role != null && mounted) {
      setState(() {
        _userRole = role;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();

    final thaiYear = now.year + 543;
    final thaiMonth = thaiMonths[now.month];
    final day = now.day;
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');

    setState(() {
      _currentTime = '$day $thaiMonth $thaiYear | $hour:$minute น.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_userRole == 'admin')
              GestureDetector(
                onTap: () {
                  _showResetSystemDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.onPrimary, // Gold color
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  // child: const Text(
                  //   'รีเซ็ตระบบ',
                  //   style: TextStyle(
                  //     color: Color(0xFF45171D),
                  //     fontSize: 14,
                  //     fontFamily: 'Kanit',
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  child: Flexible(
                    child: Text(
                      'รีเซ็ตระบบ',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              )
            else
              Consumer<UserProvider>(
                builder: (context, provider, child) =>
                    ShowCoins(coinCount: provider.credit),
              ),
            Flexible(
              child: Text(
                _currentTime,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetSystemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset System'),
          content: const Text(
            'Are you sure you want to reset the system? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Handle reset system logic here
                _handleSystemReset();
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _handleSystemReset() {
    // Implement system reset logic here
    // This could include clearing data, resetting configurations, etc.
    log('System reset initiated by admin');
    // For now, just show a success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('System reset completed'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

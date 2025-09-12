import 'package:app/components/Showcoins.dart';
import 'package:app/service/user.dart';
import 'package:app/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
  int _userCredit = 0;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _updateTime();
    _loadUserCredit();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadUserCredit() async {
    final creditString = await _userService.getUserCredit();
    if (creditString != null) {
      final credit = double.tryParse(creditString)?.toInt() ?? 0;
      setState(() {
        _userCredit = credit;
      });
    }
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
            // ShowCoins(coinCount: 0),
            ShowCoins(coinCount: _userCredit),
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
}

import 'package:app/components/Input.dart';
import 'package:app/components/Showcoins.dart';
import 'package:app/components/Tag.dart';
import 'package:app/components/Button.dart'; // Add this import for ButtonAction
import 'package:app/pages/admin/adminHome.dart';
import 'package:app/service/user.dart';
import 'package:app/service/system-admin.dart';
import 'package:app/style/theme.dart';
import 'package:app/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final SystemAdmin _systemAdmin = SystemAdmin();
  final TextEditingController _confirmToDelete = TextEditingController();
  bool _isConfirmationValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _loadUserRole();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });

    _confirmToDelete.addListener(_validateConfirmation);
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
    _confirmToDelete.removeListener(_validateConfirmation);
    _confirmToDelete.dispose();
    super.dispose();
  }

  void _validateConfirmation() {
    setState(() {
      _isConfirmationValid = _confirmToDelete.text.trim() == 'delete_lottocat';
    });
  }

  String? _validateConfirmToDelete(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณาพิมพ์ข้อความยืนยัน';
    }
    if (value.trim() != 'delete_lottocat') {
      return 'ข้อความยืนยันไม่ถูกต้อง';
    }
    return null;
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
                child: Tag(
                  text: 'รีเซ็ตระบบ',
                  backgroundColor: AppColors.onPrimary,
                  textColor: AppColors.primary,
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
    // Reset the confirmation state when dialog opens
    _confirmToDelete.clear();
    _isConfirmationValid = false;
    _isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('ยืนยันการีเซ็ตระบบ'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 325,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'โปรดเข้าใจว่าหากคุณซีเซ็ตระบบ\n',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: 'ข้อมูลผู้ใช้ทั้งหมด จะหายไป',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: ' และไม่สามารถดู้คืนได้',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const CircularProgressIndicator()
                  else
                    Input(
                      controller: _confirmToDelete,
                      labelText: 'พิมพ์ "delete_lottocat" เพื่อยืนยัน',
                      materialIcon: Icons.security,
                      validator: _validateConfirmToDelete,
                      onChanged: (value) {
                        setDialogState(() {
                          _isConfirmationValid =
                              value.trim() == 'delete_lottocat';
                        });
                      },
                    ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ButtonActions(
                        onPressed: _isLoading
                            ? null
                            : () => Navigator.of(context).pop(),
                        text: "ยกเลิก",
                        variant: ButtonVariant.primary,
                        // backgroundColor: Colors.grey.shade300,
                        // textColor: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonActions(
                        text: _isLoading ? 'กำลังรีเซ็ต...' : 'ยืนยัน',
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_isConfirmationValid) {
                                  setDialogState(() {
                                    _isLoading = true;
                                  });
                                  _handleSystemReset(setDialogState);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('ข้อความยืนยันไม่ถูกต้อง'),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _handleSystemReset(StateSetter setDialogState) async {
    log('System reset initiated by admin');

    final result = await _systemAdmin.resetSystem();

    if (result['success']) {
      if (mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('System reset completed'),
            backgroundColor: AppColors.success,
          ),
        );

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, _, __) => const AdminHomePage(),
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
    } else {
      if (mounted) {
        setDialogState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${result['message']}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

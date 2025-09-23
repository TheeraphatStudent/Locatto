import 'dart:developer';

import 'package:app/components/Alert.dart';
import 'package:app/pages/home.page.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Usernavigator.dart';
import 'package:app/components/Avatar.dart';
import 'package:app/service/auth.dart';
import 'package:app/components/Input.dart';

class Profile_Detail extends StatefulWidget {
  const Profile_Detail({super.key});

  @override
  State<Profile_Detail> createState() => _Profile_DetailPageState();
}

class _Profile_DetailPageState extends State<Profile_Detail> {
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _idController = TextEditingController(text: "");
  final TextEditingController _phoneController = TextEditingController(
    text: "",
  );
  final TextEditingController _emailController = TextEditingController();

  final Auth _auth = Auth();
  AlertMessage alert = AlertMessage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await _auth.getMe();

      log("User data: ${response.toString()}");

      if (response['statusCode'] == 200) {
        final user = response['data']['user'];
        setState(() {
          _nameController.text = user['name'] ?? '';
          _idController.text = user['card_id'] ?? '';
          _phoneController.text = user['telno'] ?? '';
          _emailController.text = user['email'] ?? '';
        });
      }
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = {
        'fullname': _nameController.text,
        'telno': _phoneController.text,
        'cardId': _idController.text,
        'email': _emailController.text,
      };

      final response = await _auth.updateMe(data);
      if (response['statusCode'] == 200) {
        alert.showSuccess(context, 'อัปเดตโปรไฟล์สำเร็จ');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        alert.showError(context, 'อัปเดตโปรไฟล์ล้มเหลว');
      }
    } catch (e) {
      alert.showError(context, 'เกิดข้อผิดพลาดในการอัปเดต');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          UserNavigator(
            currentPage: "ข้อมูลส่วนตัว",
            confirmText: _isLoading ? "กำลังอัปเดต..." : "ยืนยัน",
            centerColor: const Color.fromARGB(255, 250, 204, 192)!,
            onConfirm: () {
              if (!_isLoading) {
                _updateProfile();
              }
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),
                const Avatar(),
                const SizedBox(height: 30),
                
                ///ชื่อ - นามสกุล
                const Text(
                  "ชื่อ - นามสกุล",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                Input(
                  controller: _nameController,                  
                ),
                  const SizedBox(height: 12),

                  ///เลขบัตรประชานชน
                  const Text(
                  "เลขบัตรประชาชน",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                Input(
                  controller: _idController,
                ),
                  const SizedBox(height: 12),

                  ///เบอร์โทร
                  const Text(
                  "เบอร์โทร",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                Input(
                  controller: _phoneController,
                ),
                  const SizedBox(height: 12),

                  ///Email
                  const Text(
                  "อีเมลล์",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 6),
                Input(
                  controller: _emailController,
                ),
                  const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

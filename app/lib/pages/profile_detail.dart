import 'dart:developer';

import 'package:app/components/Alert.dart';
import 'package:app/pages/home.page.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Usernavigator.dart';
import 'package:app/components/Avatar.dart';
import 'package:app/service/auth.dart';

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
  
  String? _currentImageUrl;
  String? _uploadedImageUrl;

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
          _currentImageUrl = user['img'];
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
        'img': _uploadedImageUrl ?? _currentImageUrl ?? '',
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
                Avatar(
                  initialImagePath: _currentImageUrl,
                  onImageUploaded: (imageUrl) {
                    setState(() {
                      _uploadedImageUrl = imageUrl;
                    });
                  },
                ),
                const SizedBox(height: 30),
                _buildTextField("ชื่อ - นามสกุล", _nameController),
                _buildTextField("เลขบัตรประชาชน", _idController),
                _buildTextField("เบอร์โทร", _phoneController),
                _buildTextField("อีเมล", _emailController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}

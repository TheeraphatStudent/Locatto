import 'dart:developer';

import 'package:app/components/Alert.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Usernavigator.dart';
import 'package:app/components/Avatar.dart';
import 'package:app/service/auth.dart';

class AdminProfileDetail extends StatefulWidget {
  const AdminProfileDetail({super.key});

  @override
  State<AdminProfileDetail> createState() => _AdminProfileDetailPageState();
}

class _AdminProfileDetailPageState extends State<AdminProfileDetail> {
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _idController = TextEditingController(text: "");
  final TextEditingController _phoneController = TextEditingController(
    text: "",
  );
  final TextEditingController _emailController = TextEditingController();

  final Auth _auth = Auth();
  AlertMessage alert = AlertMessage();
  bool _isLoading = false;
  bool _isEditing = false; // เพิ่มสถานะสำหรับการแก้ไข

  @override
  void initState() {
    super.initState();
    log('มาแล้ว'); // เพิ่ม log เพื่อตรวจสอบว่าเข้ามาในหน้านี้
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
        setState(() {
          _isEditing = false; // ปิดโหมดแก้ไขหลังจากอัปเดตสำเร็จ
        });
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
            confirmText: _isEditing
                ? (_isLoading ? "กำลังอัปเดต..." : "ยืนยัน")
                : "แก้ไข",
            centerColor: const Color.fromARGB(255, 250, 204, 192)!,
            onConfirm: () {
              if (_isEditing) {
                if (!_isLoading) {
                  _updateProfile(); // กดปุ่มยืนยันเพื่ออัปเดตข้อมูล
                }
              } else {
                setState(() {
                  _isEditing = true; // เปิดโหมดแก้ไข
                });
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
                _buildTextField("ชื่อ - นามสกุล", _nameController, _isEditing),
                _buildTextField("เลขบัตรประชาชน", _idController, _isEditing),
                _buildTextField("เบอร์โทร", _phoneController, _isEditing),
                _buildTextField("อีเมล", _emailController, _isEditing),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool isEditable,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        enabled: isEditable, // กำหนดให้แก้ไขได้เฉพาะเมื่ออยู่ในโหมดแก้ไข
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: isEditable
              ? Colors.white
              : Colors.grey[200], // เปลี่ยนสีพื้นหลังเมื่อแก้ไขไม่ได้
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

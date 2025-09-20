import 'package:app/pages/home.page.dart';
import 'package:flutter/material.dart';
import 'package:app/components/mainlayout.dart';
import 'package:app/components/Usernavigator.dart';
import 'package:app/components/Avatar.dart';

class Profile_Detail extends StatefulWidget {
  const Profile_Detail({super.key});

  @override
  State<Profile_Detail> createState() => _Profile_DetailPageState();
}

class _Profile_DetailPageState extends State<Profile_Detail> {
  final TextEditingController _nameController =
      TextEditingController(text: "");
  final TextEditingController _idController =
      TextEditingController(text: "");
  final TextEditingController _phoneController =
      TextEditingController(text: "");
  final TextEditingController _emailController = TextEditingController();

@override
Widget build(BuildContext context) {
  return MainLayout(
    body: Column(
      children: [
        UserNavigator(
          currentPage: "ข้อมูลส่วนตัว",
          confirmText: "ยืนยัน",       
          centerColor: const Color.fromARGB(255, 250, 204, 192)!,
          onConfirm: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 10),
              const Avatar(),
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
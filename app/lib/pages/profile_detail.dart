import 'package:flutter/material.dart';
import 'package:app/components/mainlayout.dart';

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
      //ใช้MainLayoutไม่ได้
      /*appBar: AppBar(
        backgroundColor: const Color(0xFFFDEEEA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "ข้อมูลส่วนตัว",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: save logic
            },
            child: const Text(
              "ยืนยัน",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),*/
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 70, color: Colors.white),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.edit, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          _buildTextField("ชื่อ - นามสกุล", _nameController),

          _buildTextField("เลขบัตรประชาชน", _idController),

          _buildTextField("เบอร์โทร", _phoneController),

          _buildTextField("อีเมล", _emailController),
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
            borderRadius: BorderRadius.circular(12),
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

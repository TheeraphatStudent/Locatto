import 'package:app/components/MainLayout.dart';
import 'package:flutter/material.dart';
import 'package:app/components/adminFooter.dart'; // Import AdminFooter
import 'package:app/components/Box_make_reward.dart'; // Import Box_make_reward
import 'package:app/components/PrizeSetup.dart'; // Import PrizeSetup
import 'package:app/components/RandomLotto.dart'; // Import RandomLotto
import 'package:app/components/Button.dart'; // Import ButtonTab

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0; // ตัวแปรเก็บสถานะปุ่มที่ถูกเลือก

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index; // อัปเดตปุ่มที่ถูกเลือก
    });
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return Box_make_reward(); // แสดง Box_make_reward เมื่อเลือก "จัดการรางวัล"
      case 1:
        return PrizesetupPage(); // แสดง PrizeSetup เมื่อเลือก "เงินรางวัล"
      case 2:
        return RandomLotto(); // แสดง RandomLotto เมื่อเลือก "สุ่มรางวัล"
      default:
        return const SizedBox(); // กรณีไม่มีอะไรถูกเลือก
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ButtonTab(
                text: 'จัดการรางวัล',
                isActive: _selectedIndex == 0,
                onTap: () => _onButtonPressed(0),
              ),
              const SizedBox(width: 6),
              ButtonTab(
                text: 'เงินรางวัล',
                isActive: _selectedIndex == 1,
                onTap: () => _onButtonPressed(1),
              ),
              const SizedBox(width: 6),
              ButtonTab(
                text: 'สุ่มรางวัล',
                isActive: _selectedIndex == 2,
                onTap: () => _onButtonPressed(2),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildContent(),

          // Expanded(child: _buildContent()),
        ],
      ),
    );
  }
}

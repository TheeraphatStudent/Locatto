import 'package:flutter/material.dart';
import 'package:app/components/adminFooter.dart'; // Import AdminFooter
import 'package:app/components/Box_make_reward.dart'; // Import Box_make_reward
import 'package:app/components/PrizeSetup.dart'; // Import PrizeSetup
import 'package:app/components/RandomLotto.dart'; // Import RandomLotto

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        automaticallyImplyLeading: false, // ปิดปุ่ม Back
      ),
      body: Column(
        children: [
          // ปุ่มแท็บด้านบน
          const SizedBox(height: 100),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _onButtonPressed(0), // กดปุ่มเพื่อเลือก "จัดการรางวัล"
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 0
                          ? Colors
                                .redAccent // สีแดงเมื่อถูกเลือก
                          : Colors.grey.shade300, // สีเทาเมื่อไม่ได้ถูกเลือก
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // มุมโค้ง
                      ),
                    ),
                    child: Text(
                      'จัดการรางวัล',
                      style: TextStyle(
                        color: _selectedIndex == 0
                            ? Colors
                                  .white // สีขาวเมื่อถูกเลือก
                            : Colors.black, // สีดำเมื่อไม่ได้ถูกเลือก
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // ระยะห่างระหว่างปุ่ม
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _onButtonPressed(1), // กดปุ่มเพื่อเลือก "เงินรางวัล"
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 1
                          ? Colors
                                .redAccent // สีแดงเมื่อถูกเลือก
                          : Colors.grey.shade300, // สีเทาเมื่อไม่ได้ถูกเลือก
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // มุมโค้ง
                      ),
                    ),
                    child: Text(
                      'เงินรางวัล',
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? Colors
                                  .white // สีขาวเมื่อถูกเลือก
                            : Colors.black, // สีดำเมื่อไม่ได้ถูกเลือก
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // ระยะห่างระหว่างปุ่ม
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _onButtonPressed(2), // กดปุ่มเพื่อเลือก "สุ่มรางวัล"
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == 2
                          ? Colors
                                .redAccent // สีแดงเมื่อถูกเลือก
                          : Colors.grey.shade300, // สีเทาเมื่อไม่ได้ถูกเลือก
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // มุมโค้ง
                      ),
                    ),
                    child: Text(
                      'สุ่มรางวัล',
                      style: TextStyle(
                        color: _selectedIndex == 2
                            ? Colors
                                  .white // สีขาวเมื่อถูกเลือก
                            : Colors.black, // สีดำเมื่อไม่ได้ถูกเลือก
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // เนื้อหาด้านล่าง
          const SizedBox(height: 20),
          Expanded(
            child: _buildContent(), // แสดงเนื้อหาตามปุ่มที่ถูกเลือก
          ),
        ],
      ),
      bottomNavigationBar: const AdminFooter(), // เพิ่ม AdminFooter
    );
  }
}

class HomePage {
  const HomePage();
}

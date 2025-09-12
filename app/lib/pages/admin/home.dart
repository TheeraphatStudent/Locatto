import 'dart:developer';

import 'package:app/components/List.dart';
import 'package:app/service/lottery/post.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LotteryService _lotteryService = LotteryService();
  final TextEditingController _countController = TextEditingController(
    text: '1000',
  );
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  final List<LotteryData> _mockLotteryData = [
    LotteryData(lottery: '123456', reward: ''),
    LotteryData(lottery: '234567', reward: ''),
    LotteryData(lottery: '345678', reward: ''),
    LotteryData(lottery: '456789', reward: ''),
    LotteryData(lottery: '567890', reward: ''),
    LotteryData(lottery: '678901', reward: ''),
    LotteryData(lottery: '789012', reward: ''),
    LotteryData(lottery: '890123', reward: ''),
  ];

  @override
  void dispose() {
    _countController.dispose();
    super.dispose();
  }

  Future<void> _generateLotteries() async {
    final count = int.tryParse(_countController.text) ?? 0;

    if (count <= 0) {
      setState(() {
        _errorMessage = 'กรุณากรอกจำนวนที่มากกว่า 0';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final response = await _lotteryService.generateLotteries(count);

      if (response['success'] == true) {
        setState(() {
          _successMessage = 'สร้างล็อตเตอรี่สำเร็จ ${count} ใบ';
          _countController.text = '1000'; // Reset to default
        });

        // Show success snackbar
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('สร้างล็อตเตอรี่สำเร็จ ${count} ใบ'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          _errorMessage =
              response['message'] ?? 'เกิดข้อผิดพลาดในการสร้างล็อตเตอรี่';
        });
      }
    } catch (e) {
      log('Error generating lotteries: $e');
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการสร้างล็อตเตอรี่';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onCountChanged(String value) {
    if (_errorMessage != null) {
      setState(() {
        _errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tab Bar
            Row(
              children: [
                ButtonTab(text: 'จัดการรางวัล', isActive: true),
                const SizedBox(width: 6),
                ButtonTab(text: 'เงินรางวัล', isActive: false),
                const SizedBox(width: 6),
                ButtonTab(text: 'สุ่มรางวัล', isActive: false),
              ],
            ),

            const SizedBox(height: 16),

            // Main Content Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: ShapeDecoration(
                color: const Color(0x7FFFF8F8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'สร้างรางวัล',
                          style: TextStyle(
                            color: Color(0xFF45171D),
                            fontSize: 14,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' (สุ่มตามจำนวน)',
                          style: TextStyle(
                            color: Color(0xFF45171D),
                            fontSize: 12,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          'จำนวน',
                          style: TextStyle(
                            color: const Color(0xFFAE9DA0),
                            fontSize: 12,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFF7F7),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: _errorMessage != null
                                    ? Colors.red
                                    : const Color(0xFF45171D),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _countController,
                                  keyboardType: TextInputType.number,
                                  onChanged: _onCountChanged,
                                  style: const TextStyle(
                                    color: Color(0xFF45171D),
                                    fontSize: 12,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                    isDense: true,
                                  ),
                                ),
                              ),
                              const Text(
                                'ใบ',
                                style: TextStyle(
                                  color: Color(0xFFAE9DA0),
                                  fontSize: 12,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Error Message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontFamily: 'Kanit',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Cancel action
                            _countController.text = '1000';
                            setState(() {
                              _errorMessage = null;
                              _successMessage = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFD5553),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F454517),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                'ยกเลิก',
                                style: TextStyle(
                                  color: Color(0xFFFFF7F7),
                                  fontSize: 15,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: _isLoading ? null : _generateLotteries,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: ShapeDecoration(
                              color: _isLoading
                                  ? const Color(0xFFE0E0E0)
                                  : const Color(0xFFFFF7F7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadows: const [
                                BoxShadow(
                                  color: Color(0x3F454517),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Color(0xFFFD5553),
                                            ),
                                      ),
                                    )
                                  : const Text(
                                      'ดำเนินการ',
                                      style: TextStyle(
                                        color: Color(0xFFFD5553),
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            LotteryList(lotteryList: _mockLotteryData),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/Lottery.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/service/lottery/post.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LotteryService _lotteryService = LotteryService();
  final TextEditingController _countController = TextEditingController(text: '0');
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

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
          _countController.text = '0'; // Reset the input
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
          _errorMessage = response['message'] ?? 'เกิดข้อผิดพลาดในการสร้างล็อตเตอรี่';
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24,
          children: [
            Container(
              width: 248,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 6,
                            children: [
                              Expanded(
                                child: Container(
                                  height: 32,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: const Color(0xFFC13433) /* Primary-700 */,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                        bottomLeft: Radius.circular(4),
                                        bottomRight: Radius.circular(4),
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 62.67,
                                        child: Text(
                                          'จัดการรางวัล',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF840100) /* Primary-900 */,
                                            fontSize: 10,
                                            fontFamily: 'Kanit',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.80,
                                child: Expanded(
                                  child: Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 62.67,
                                          child: Text(
                                            'เงินรางวัล',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xFFAE9DA0) /* Gray */,
                                              fontSize: 10,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.80,
                                child: Expanded(
                                  child: Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 62.67,
                                          child: Text(
                                            'สุ่มรางวัล',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xFFAE9DA0) /* Gray */,
                                              fontSize: 10,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 8,
                            children: [
                              Text(
                                '16 สิงหาคม 2568',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF45171D) /* Lottocat-Black */,
                                  fontSize: 10,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '>',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFFFD5553) /* Lottocat-Primary */,
                                  fontSize: 10,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                '31 สิงหาคม 2568',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF45171D) /* Lottocat-Black */,
                                  fontSize: 10,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: ShapeDecoration(
                color: const Color(0x7FFFF8F8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'สร้างรางวัล',
                                style: TextStyle(
                                  color: const Color(0xFF45171D) /* Lottocat-Black */,
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' (สุ่มตามจำนวน)',
                                style: TextStyle(
                                  color: const Color(0xFF45171D) /* Lottocat-Black */,
                                  fontSize: 12,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 6,
                            children: [
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 8,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      child: Text(
                                        'จำนวน',
                                        style: TextStyle(
                                          color: const Color(0xFFAE9DA0) /* Gray */,
                                          fontSize: 12,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 6,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 36,
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                            decoration: ShapeDecoration(
                                              color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  color: _errorMessage != null
                                                    ? const Color(0xFFFF4757) /* Error Color */
                                                    : const Color(0xFF45171D) /* Lottocat-Black */,
                                                ),
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              spacing: 10,
                                              children: [
                                                Expanded(
                                                  child: TextField(
                                                    controller: _countController,
                                                    keyboardType: TextInputType.number,
                                                    onChanged: _onCountChanged,
                                                    style: const TextStyle(
                                                      color: Color(0xFF45171D) /* Lottocat-Black */,
                                                      fontSize: 12,
                                                      fontFamily: 'Kanit',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    decoration: const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: '0',
                                                      hintStyle: TextStyle(
                                                        color: Color(0xFFAE9DA0) /* Gray */,
                                                        fontSize: 12,
                                                        fontFamily: 'Kanit',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                      contentPadding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ),
                                                const Text(
                                                  'ใบ',
                                                  style: TextStyle(
                                                    color: Color(0xFFAE9DA0) /* Gray */,
                                                    fontSize: 12,
                                                    fontFamily: 'Kanit',
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Error message display
                              if (_errorMessage != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF4757).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFF4757)),
                                  ),
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Color(0xFFFF4757),
                                      fontFamily: 'Kanit',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              // Success message display
                              if (_successMessage != null)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: Text(
                                    _successMessage!,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontFamily: 'Kanit',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                            decoration: ShapeDecoration(
                              color: const Color(0xFFFD5553) /* Lottocat-Primary */,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              shadows: [
                                BoxShadow(
                                  color: const Color(0x3F454517),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                  spreadRadius: 0,
                                )
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Text(
                                  'ยกเลิก',
                                  style: TextStyle(
                                    color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                                    fontSize: 15,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: _isLoading ? null : _generateLotteries,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                              decoration: ShapeDecoration(
                                color: _isLoading
                                  ? const Color(0xFFFD5553).withOpacity(0.6)
                                  : const Color(0xFFFFF7F7) /* Lottocat-White */,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0x3F454517),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  if (_isLoading)
                                    const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFFFD5553) /* Lottocat-Primary */
                                        ),
                                      ),
                                    ),
                                  Text(
                                    _isLoading ? 'กำลังดำเนินการ...' : 'ดำเนินการ',
                                    style: TextStyle(
                                      color: _isLoading
                                        ? const Color(0xFFFD5553).withOpacity(0.6)
                                        : const Color(0xFFFD5553) /* Lottocat-Primary */,
                                      fontSize: 15,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.50,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: ShapeDecoration(
                  color: const Color(0x7FFFF8F8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Container(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 6,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'อัพโหลดล็อตเตอรี่',
                                  style: TextStyle(
                                    color: const Color(0xFF45171D) /* Lottocat-Black */,
                                    fontSize: 14,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: ' (ยังไม่พร้อมใช้งาน)',
                                  style: TextStyle(
                                    color: const Color(0xFF45171D) /* Lottocat-Black */,
                                    fontSize: 12,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFFFF7F7) /* Lottocat-White */,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: const Color(0x3F454517),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Text(
                                    'อัพโหลด',
                                    style: TextStyle(
                                      color: const Color(0xFFAE9DA0) /* Gray */,
                                      fontSize: 15,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

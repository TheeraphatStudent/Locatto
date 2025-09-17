import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/redcurve.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary, // เปลี่ยนเป็นสีเหลือง
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // พื้นหลังแดงแบบโค้ง
                  Positioned.fill(
                    child: CustomPaint(painter: RedCurvePainter()),
                  ),
                  // เนื้อหาเดิม
                  SizedBox(
                    height:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo & Title
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                  bottom: 0,
                                ), // ปรับ margin เป็น 0
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/logo_primary.png',
                                      height: 80,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Lotcatto',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF5A5F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 240,
                              ), // ขยับฟิลด์ลงมาจากโลโก้
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  spacing: 10,
                                  children: [
                                    Text(
                                      'จะเลขไหนก็ ',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFFFFF7F7,
                                        ) /* Lottocat-White */,
                                        fontSize: 24,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: const Color(
                                                0xFFFFF7F7,
                                              ) /* Lottocat-White */,
                                              fontSize: 24,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '80',
                                            style: TextStyle(
                                              color: const Color(
                                                0xFFFAE12F,
                                              ) /* Lottocat-Secondary */,
                                              fontSize: 48,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(
                                              color: const Color(
                                                0xFFFFF7F7,
                                              ) /* Lottocat-White */,
                                              fontSize: 24,
                                              fontFamily: 'Kanit',
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      'บาท',
                                      style: TextStyle(
                                        color: const Color(
                                          0xFFFFF7F7,
                                        ) /* Lottocat-White */,
                                        fontSize: 24,
                                        fontFamily: 'Kanit',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // ปุ่มและข้อความด้านล่างสุด
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // TextButton(
                              //   // ปุ่มไม่มีบัญชี
                              //   onPressed: () {},
                              //   child: const Text(
                              //     'ยังไม่มีบัญชีหรอ?',
                              //     style: TextStyle(
                              //       color: Colors.yellow,
                              //       decoration: TextDecoration.underline,
                              //       fontSize: 16,
                              //     ),
                              //   ),
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const SizedBox(height: 16),
                                  ButtonActions(
                                    // label: 'ยังไม่มีบัญชีหรอ?',
                                    text: 'ไปกันเลย',
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                    icon: Icons.arrow_forward,
                                    // onLabelPressed: () {
                                    //   Navigator.pushNamed(context, '/register');
                                    // },
                                  ),
                                ],
                              ),
                            ],
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
    );
  }
}

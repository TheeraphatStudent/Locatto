import 'package:flutter/material.dart';

class Lottery extends StatelessWidget {
  const Lottery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, 0.00),
              end: Alignment(1.00, 1.00),
              colors: [const Color(0xFFFFE2E2), const Color(0xFFFFFADD)],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              Container(
                height: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 18,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://placehold.co/20x18"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '80',
                              style: TextStyle(
                                color: const Color(
                                  0xFF45171D,
                                ) /* Lottocat-Black */,
                                fontSize: 8,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: ' ',
                              style: TextStyle(
                                color: const Color(
                                  0xFF45171D,
                                ) /* Lottocat-Black */,
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: 'บาท',
                              style: TextStyle(
                                color: const Color(
                                  0xFF45171D,
                                ) /* Lottocat-Black */,
                                fontSize: 6,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 76,
                height: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 4,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, 0.50),
                          end: Alignment(1.00, 0.50),
                          colors: [
                            const Color(0xFFFAE12F),
                            const Color(0xFFFF4745),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(4),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '4',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'One',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 4,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '7',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'One',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 4,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '1',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'One',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 4,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '9',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'One',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 4,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '5',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'One',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 4,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '5',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 8,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.w600,
                                    height: 1.25,
                                  ),
                                ),
                                Text(
                                  'One',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF45171D,
                                    ) /* Lottocat-Black */,
                                    fontSize: 4,
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
                    Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              Text(
                                '16 สิงหาคม 2565',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(
                                    0xFF45171D,
                                  ) /* Lottocat-Black */,
                                  fontSize: 4,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'เงินล้านใกล้ฉัน',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(
                                    0xFFFD5553,
                                  ) /* Lottocat-Primary */,
                                  fontSize: 8,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                  height: 0.70,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 14,
                            height: double.infinity,
                            decoration: BoxDecoration(color: Colors.black),
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
      ],
    );
  }
}

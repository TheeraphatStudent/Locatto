import 'package:flutter/material.dart';

class Lottery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.30, -0.95),
          end: Alignment(-0.3, 0.95),
          colors: [Color(0xFFFFE2E2), Color(0xFFFFFADD)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            left: -20,
            top: -15,
            child: Opacity(
              opacity: 0.15,
              child: Transform.rotate(
                angle: -0.3,
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://picsum.photos/80/40"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 16,
                      height: 14,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://picsum.photos/16/14"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 1),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '80',
                            style: TextStyle(
                              color: Color(0xFF45171D),
                              fontSize: 6,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: ' ',
                            style: TextStyle(
                              color: Color(0xFF45171D),
                              fontSize: 6,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          TextSpan(
                            text: 'บาท',
                            style: TextStyle(
                              color: Color(0xFF45171D),
                              fontSize: 4,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4),
              Container(
                width: 6,
                height: 6,
                decoration: ShapeDecoration(
                  color: Color(0xFFFFEFEF),
                  shape: OvalBorder(
                    side: BorderSide(width: 0.5, color: Color(0xFFFFC1C0)),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 3,
                          vertical: 2,
                        ),
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(1.00, 0.00),
                            end: Alignment(-1, 0),
                            colors: [Color(0xFFFAE12F), Color(0xFFFF4745)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(3),
                              bottomLeft: Radius.circular(3),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNumberColumn('4'),
                            _buildNumberColumn('7'),
                            _buildNumberColumn('1'),
                            _buildNumberColumn('9'),
                            _buildNumberColumn('5'),
                            _buildNumberColumn('5'),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '16 สิงหาคม 2565',
                                style: TextStyle(
                                  color: Color(0xFF45171D),
                                  fontSize: 4,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 1),
                              Text(
                                'เงินล้านใกล้ฉัน',
                                style: TextStyle(
                                  color: Color(0xFFFD5553),
                                  fontSize: 6,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNumberColumn(String number) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          number,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF45171D),
            fontSize: 12,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'One',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF45171D),
            fontSize: 6,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

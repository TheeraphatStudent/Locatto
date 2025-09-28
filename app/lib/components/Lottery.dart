import 'package:app/components/Dialogue.dart';
import 'package:app/style/theme.dart';
import 'package:app/utils/qr_helper.dart';
import 'package:app/utils/text_healper.dart';
import 'package:flutter/material.dart';

// Test kubbb

class Lottery extends StatefulWidget {
  final String lotteryNumber;
  final bool isSelected;

  final String qrData;
  final Function(String)? onTap;
  final Function(String)? onLongPress;

  const Lottery({
    super.key,
    required this.lotteryNumber,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.qrData = "https://cataas.com/cat/gif",
  });

  @override
  State<Lottery> createState() => _LotteryState();
}

class _LotteryState extends State<Lottery> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
      width: double.infinity,
      decoration: ShapeDecoration(
        shadows: [
          BoxShadow(
            // color: widget.isSelected
            //     ? const Color(0xFFFF4745)
            //     : const Color(0xFFFFC1C0),
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 1),
            spreadRadius: 1,
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      child: GestureDetector(
        onTap: () => widget.onTap?.call(widget.lotteryNumber),
        // onLongPress: () {
        //   try {
        //     widget.onLongPress?.call(widget.lotteryNumber);
        //     _showPopup(context);
        //   } catch (e) {
        //     debugPrint('Error in long press: $e');
        //   }
        // },
        // onLongPressDown: (details) {
        // },
        // onTertiaryLongPress: () {
        //   _showPopup(context);
        // },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ), // Increased padding for better spacing
          decoration: ShapeDecoration(
            gradient: AppColors.softGradientPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: widget.isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFFF4745),
                      width: 2,
                    ),
                  )
                : BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(0, 255, 255, 255),
                      width: 2,
                    ),
                  ),
            child: Stack(
              clipBehavior: Clip.hardEdge,
              children: [
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFFEFEF),
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 1.5,
                          color: widget.isSelected
                              ? const Color(0xFFFF4745)
                              : const Color(0xFFFFC1C0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    "assets/images/logo_primary.png",
                                  ),
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
                                      fontSize: 8,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  WidgetSpan(child: SizedBox(width: 4)),
                                  TextSpan(
                                    text: 'บาท',
                                    style: TextStyle(
                                      color: Color(0xFF45171D),
                                      fontSize: 8,
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
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ), // Increased padding for better number display
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6, // Increased horizontal padding
                                  vertical: 4, // Increased vertical padding
                                ),
                                decoration: ShapeDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      AppColors.secondaryLight,
                                      AppColors.primaryLight,
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(3),
                                      bottomLeft: Radius.circular(3),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: widget.lotteryNumber
                                      .split('')
                                      .map((digit) => _buildNumberColumn(digit))
                                      .toList(),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 2),
                                      Text(
                                        'เงินล้านใกล้ฉัน',
                                        style: TextStyle(
                                          color: Color(0xFFFD5553),
                                          fontSize: 12,
                                          fontFamily: 'Kanit',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  QrWidget(data: widget.qrData, size: 36),
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
        ),
      ),
    );
  }

  Widget _buildNumberColumn(String number) {
    final int num = int.tryParse(number) ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 1,
      ), // Added padding around each number column
      child: Column(
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
            numberTexts[num] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF45171D),
              fontSize: 6,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:app/style/theme.dart';
import 'package:app/utils/qr_helper.dart';
import 'package:app/utils/text_healper.dart';
import 'package:flutter/material.dart';

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
    this.qrData = "Hello world",
  });

  @override
  State<Lottery> createState() => _LotteryState();
}

class _LotteryState extends State<Lottery> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap?.call(widget.lotteryNumber),
      onLongPress: () {
        try {
          widget.onLongPress?.call(widget.lotteryNumber);
          _showPopup(context);
        } catch (e) {
          debugPrint('Error in long press: $e');
        }
      },
      // onLongPressDown: (details) {
      //   _showPopup(context);
      // },
      // onTertiaryLongPress: () {
      //   _showPopup(context);
      // },
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: ShapeDecoration(
          gradient: AppColors.softGradientPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: widget.isSelected
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFF4745), width: 2),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: widget.lotteryNumber
                                  .split('')
                                  .map((digit) => _buildNumberColumn(digit))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 1),
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
                              QrWidget(data: widget.qrData, size: 24),
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
        ),
      ),
    );
  }

  Widget _buildNumberColumn(String number) {
    final int num = int.tryParse(number) ?? 0;
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
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (BuildContext context) => _LotteryDialog(
        lotteryNumber: widget.lotteryNumber,
        qrData: widget.qrData,
      ),
    );
  }
}

class _LotteryDialog extends StatelessWidget {
  final String lotteryNumber;
  final String qrData;

  const _LotteryDialog({required this.lotteryNumber, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE2E2), Color(0xFFFFFADD)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'QR Code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF45171D),
                fontFamily: 'Kanit',
              ),
            ),
            const SizedBox(height: 20),
            // Cache QR widget to avoid regeneration
            RepaintBoundary(child: QrWidget(data: qrData)),
            const SizedBox(height: 20),
            Text(
              'หมายเลข: $lotteryNumber',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF45171D),
                fontFamily: 'Kanit',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ราคา: 80 บาท',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
                fontFamily: 'Kanit',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF4745),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'ปิด',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

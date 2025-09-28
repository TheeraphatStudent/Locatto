import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final bool hasShadow; // เพิ่ม parameter สำหรับเงา
  final double? shadowBlurRadius; // เพิ่มการควบคุมความเบลอของเงา
  final Offset? shadowOffset; // เพิ่มการควบคุมตำแหน่งเงา

  const Tag({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    this.hasShadow = true, // ค่าเริ่มต้นให้มีเงา
    this.shadowBlurRadius = 4.0,
    this.shadowOffset = const Offset(0, 2),
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 64),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: hasShadow
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15), // เงาสีดำโปร่งใส
                    blurRadius: shadowBlurRadius ?? 4.0,
                    offset: shadowOffset ?? const Offset(0, 2),
                    spreadRadius: 0.5, // เพิ่มการกระจายของเงา
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

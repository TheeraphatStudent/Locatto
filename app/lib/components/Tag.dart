import 'package:flutter/material.dart';

class Tag extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const Tag({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 64),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
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
    );
  }
}

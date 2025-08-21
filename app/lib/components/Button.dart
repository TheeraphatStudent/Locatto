import 'package:flutter/cupertino.dart' show StatelessWidget;
import 'package:flutter/material.dart';

enum ButtonVariant { primary, light, outline }

class ButtonActions extends StatelessWidget {
  const ButtonActions({
    super.key,
    this.text = '',
    this.hasShadow = true,
    this.variant = ButtonVariant.light,
    this.theme,
  });

  final String text;
  final bool hasShadow;
  final ButtonVariant variant;
  final Color? theme;

  @override
  Widget build(BuildContext context) {
    final Color accent = theme ?? const Color(0xFFFD5553);

    final Color backgroundColor;
    final Color foregroundColor;
    final OutlinedBorder shape;
    final List<BoxShadow> boxShadows = hasShadow
        ? [
            BoxShadow(
              color: accent.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            ),
          ]
        : const [];

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = accent;
        foregroundColor = Colors.white;
        shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
        break;
      case ButtonVariant.light:
        backgroundColor = const Color(0xFFFFF7F7);
        foregroundColor = accent;
        shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = accent;
        shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: accent, width: 2),
        );
        break;
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: shape,
            shadows: boxShadows,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 15,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.arrow_right, size: 24, color: foregroundColor),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

enum ButtonType { active, inactive, disabled }

class ButtonStyle {
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;

  ButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.borderRadius,
  });
}

class ButtonAction extends StatefulWidget {
  final ButtonType type;
  final Map<ButtonType, ButtonStyle>? styleMap;

  const ButtonAction({super.key, required this.type, this.styleMap});

  @override
  State<ButtonAction> createState() => _ButtonActionState();
}

class _ButtonActionState extends State<ButtonAction> {
  Map<ButtonType, ButtonStyle> get _defaultStyleMap => {
    ButtonType.active: ButtonStyle(
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
    ),
    ButtonType.inactive: ButtonStyle(
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
    ),
    ButtonType.disabled: ButtonStyle(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
    ),
  };

  String get _buttonText {
    switch (widget.type) {
      case ButtonType.active:
        return 'ยืนยัน';
      case ButtonType.inactive:
        return 'ยกลิก';
      case ButtonType.disabled:
        return 'Disabled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleMap = widget.styleMap ?? _defaultStyleMap;
    final buttonStyle = styleMap[widget.type]!;

    return ElevatedButton(
      onPressed: widget.type == ButtonType.disabled
          ? null
          : () {
              print('Button pressed: ${widget.type}');
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonStyle.backgroundColor,
        foregroundColor: buttonStyle.foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        _buttonText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

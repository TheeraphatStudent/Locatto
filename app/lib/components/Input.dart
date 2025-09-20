import 'package:flutter/material.dart';
import 'package:app/style/theme.dart';

enum InputVariant {
  active, // With search icon and focused state
  inactive, // Normal state without icon
}

enum ActionBadgePosition { left, right }

class Input extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? helperText;

  final String? suffixText;

  final InputVariant variant;
  final Color? suffixColor;
  final IconData? suffixIcon;
  final VoidCallback? onActionPressed;

  final String? badgeValue;
  final Widget? customIcon;
  final IconData? materialIcon;
  final bool showGradientBorder;

  final bool showActionsBadge;
  final int actionsBadgeCount;
  final IconData? actionsBadgeIcon;
  final VoidCallback? onActionsBadgePressed;
  final ActionBadgePosition actionBadgePosition;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;

  const Input({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.helperText,

    this.variant = InputVariant.inactive,
    this.suffixColor = AppColors.primary,
    this.suffixIcon = Icons.shopping_cart,

    this.onActionPressed,
    this.badgeValue,
    this.customIcon,
    this.materialIcon,
    this.showGradientBorder = false,

    this.showActionsBadge = false,
    this.actionsBadgeCount = 0,
    this.actionsBadgeIcon = Icons.shopping_cart,
    this.onActionsBadgePressed,
    this.actionBadgePosition = ActionBadgePosition.right,
    this.onChanged,
    this.suffixText,
    this.keyboardType,
    this.onTap,
  });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildSuffixIcon() {
    switch (widget.variant) {
      case InputVariant.active:
        return Container(
          padding: const EdgeInsets.all(8),
          child: Icon(widget.suffixIcon, color: widget.suffixColor, size: 20),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  InputBorder _buildBorder({required bool isFocused, required bool isError}) {
    if (widget.showGradientBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        borderSide: BorderSide.none,
      );
    }

    Color borderColor;
    double borderWidth;

    if (isError) {
      borderColor = AppColors.error;
      borderWidth = 2.0;
    } else if (isFocused) {
      borderColor = AppColors.primary;
      borderWidth = 2.0;
    } else {
      borderColor = const Color(0xFF45171D);
      borderWidth = 1.0;
    }

    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
      borderSide: BorderSide(color: borderColor, width: borderWidth),
    );
  }

  Widget _buildGradientBorderContainer({required Widget child}) {
    if (!widget.showGradientBorder) return child;

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF45171D), Color(0xFFFE5654)],
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 1, right: 1, bottom: 1),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7F7),
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusXLarge),
        ),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError =
        widget.validator != null &&
        widget.controller != null &&
        widget.validator!(widget.controller!.text) != null;

    TextFormField textField = TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      validator: widget.validator,
      onChanged: (value) {
        widget.onChanged?.call(value);
        if (widget.validator != null) {
          setState(() {});
        }
      },
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        suffixText: widget.suffixText,
        suffixIcon: widget.suffixText == null ? _buildSuffixIcon() : null,

        // Background Color
        filled: true,
        fillColor: const Color(0xFFFFF7F7),

        // Padding
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),

        // Borders
        border: _buildBorder(isFocused: false, isError: false),
        enabledBorder: _buildBorder(isFocused: false, isError: hasError),
        focusedBorder: _buildBorder(isFocused: true, isError: false),
        disabledBorder: _buildBorder(isFocused: false, isError: false),
        errorBorder: _buildBorder(isFocused: false, isError: true),
        focusedErrorBorder: _buildBorder(isFocused: true, isError: true),

        // Text Styling
        // floatingLabelStyle: TextStyle(
        //   color: hasError ? AppColors.error : AppColors.primary,
        //   fontFamily: 'Kanit',
        //   fontWeight: FontWeight.w500,
        // ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(color: AppColors.primary, fontFamily: 'Kanit'),
        hintStyle: const TextStyle(
          color: Color(0xFF666666),
          fontFamily: 'Kanit',
        ),
        helperStyle: const TextStyle(
          color: Color(0xFF666666),
          fontFamily: 'Kanit',
        ),
        errorStyle: const TextStyle(
          color: AppColors.secondaryDark,
          fontFamily: 'Kanit',
        ),
      ),
      style: const TextStyle(fontFamily: 'Kanit', color: Color(0xFF45171D)),
    );

    Widget inputWidget = _buildGradientBorderContainer(child: textField);

    if (widget.showActionsBadge) {
      final actionsBadgeBorderConfig =
          widget.actionBadgePosition == ActionBadgePosition.left
          ? const {'tl': 8.0, 'tr': 16.0, 'bl': 8.0, 'br': 16.0}
          : const {'tl': 16.0, 'tr': 8.0, 'bl': 16.0, 'br': 8.0};

      final inputBorderRadius =
          widget.actionBadgePosition == ActionBadgePosition.left
          ? const {'tl': 8.0, 'tr': 16.0, 'bl': 8.0, 'br': 16.0}
          : const {'tl': 16.0, 'tr': 8.0, 'bl': 16.0, 'br': 8.0};

      if (widget.actionBadgePosition == ActionBadgePosition.left) {
        inputWidget = Row(
          children: [
            ActionsBadge(
              itemCount: widget.actionsBadgeCount,
              icon: widget.actionsBadgeIcon ?? Icons.shopping_cart,
              borderConfig: actionsBadgeBorderConfig,
              onPressed: widget.onActionsBadgePressed,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputWithCustomBorder(
                child: textField,
                borderRadius: inputBorderRadius,
                hasError: hasError,
              ),
            ),
          ],
        );
      } else {
        inputWidget = Row(
          children: [
            Expanded(
              child: _buildInputWithCustomBorder(
                child: textField,
                borderRadius: inputBorderRadius,
                hasError: hasError,
              ),
            ),
            const SizedBox(width: 12),
            ActionsBadge(
              itemCount: widget.actionsBadgeCount,
              icon: widget.actionsBadgeIcon ?? Icons.shopping_cart,
              borderConfig: actionsBadgeBorderConfig,
              onPressed: widget.onActionsBadgePressed,
            ),
          ],
        );
      }
    }

    return inputWidget;
  }

  Widget _buildInputWithCustomBorder({
    required Widget child,
    required Map<String, double> borderRadius,
    required bool hasError,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius['tl'] ?? 16.0),
          topRight: Radius.circular(borderRadius['tr'] ?? 16.0),
          bottomLeft: Radius.circular(borderRadius['bl'] ?? 16.0),
          bottomRight: Radius.circular(borderRadius['br'] ?? 16.0),
        ),
        border: Border.all(
          color: hasError
              ? AppColors.error
              : (_isFocused ? AppColors.primary : const Color(0xFFE0E0E0)),
          width: _isFocused ? 2 : 1,
        ),
      ),
      child: child,
    );
  }
}

class CustomInputIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double size;

  const CustomInputIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, color: color ?? Colors.white, size: size);
  }
}

class ActionsBadge extends StatelessWidget {
  final int itemCount;
  final VoidCallback? onPressed;
  final double size;
  final IconData icon;

  final Color badgeColor;
  final Color iconColor;
  final Map<String, double> borderConfig;

  const ActionsBadge({
    super.key,
    required this.itemCount,
    this.onPressed,
    required this.icon,
    this.size = 48.0,
    this.badgeColor = const Color(0xFFFF4757),
    this.iconColor = const Color(0xFF45171D),
    this.borderConfig = const {'tl': 12, 'tr': 20, 'bl': 12, 'br': 20},
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: ShapeDecoration(
            color: const Color(0xFFFFF7F7),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1.5, color: iconColor),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderConfig['tl'] ?? 12),
                topRight: Radius.circular(borderConfig['tr'] ?? 20),
                bottomLeft: Radius.circular(borderConfig['bl'] ?? 12),
                bottomRight: Radius.circular(borderConfig['br'] ?? 20),
              ),
            ),
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor, size: size * 0.5),
            onPressed: onPressed?.call,
          ),
        ),
        // Badge
        if (itemCount > 0)
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFF7F7), width: 1.5),
              ),
              child: Center(
                child: Text(
                  itemCount > 99 ? '99+' : itemCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

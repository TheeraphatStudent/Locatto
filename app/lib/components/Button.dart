import 'dart:developer';

import 'package:flutter/material.dart';

enum ButtonVariant { primary, light, outline }

class ButtonActions extends StatefulWidget {
  const ButtonActions({
    super.key,
    this.text = '',
    this.label,
    this.hasShadow = true,
    this.variant = ButtonVariant.light,
    this.theme,
    this.onPressed,
    this.icon,
    this.onLabelPressed,
  });

  final String text;
  final String? label;
  final bool hasShadow;
  final ButtonVariant variant;
  final Color? theme;
  final IconData? icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLabelPressed;

  @override
  State<ButtonActions> createState() => _ButtonActionsState();
}

class _ButtonActionsState extends State<ButtonActions>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    log("_handleTapDown work");
    log(details.toString());

    setState(() => _isPressed = true);
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    log("_handleTapUp");
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _handleTapCancel() {
    log("_handleTapCancel");
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = widget.theme ?? const Color(0xFFFD5553);

    final Color backgroundColor;
    final Color foregroundColor;
    final OutlinedBorder shape;

    final List<BoxShadow> boxShadows = widget.hasShadow
        ? [
            BoxShadow(
              color: accent.withOpacity(_isHovered ? 0.35 : 0.25),
              blurRadius: _isHovered ? 12 : 8,
              offset: Offset(0, _isHovered ? 6 : 4),
              spreadRadius: _isHovered ? 1 : 0,
            ),
          ]
        : const [];

    switch (widget.variant) {
      case ButtonVariant.primary:
        backgroundColor = _isHovered
            ? Color.lerp(accent, Colors.white, 0.1)!
            : accent;
        foregroundColor = Colors.white;
        shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
        break;
      case ButtonVariant.light:
        backgroundColor = _isHovered
            ? Color.lerp(const Color(0xFFFFF7F7), accent, 0.05)!
            : const Color(0xFFFFF7F7);
        foregroundColor = accent;
        shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
        break;
      case ButtonVariant.outline:
        backgroundColor = _isHovered
            ? accent.withOpacity(0.05)
            : Colors.transparent;
        foregroundColor = accent;
        shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: _isHovered ? accent : accent.withOpacity(0.8),
            width: _isHovered ? 2.5 : 2,
          ),
        );
        break;
    }

    // Main button widget
    final buttonWidget = AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTapDown: _handleTapDown,
                onTapUp: _handleTapUp,
                onTapCancel: _handleTapCancel,
                onTap: widget.onPressed,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
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
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          color: foregroundColor,
                          fontSize: 15,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w700,
                        ),
                        child: Text(widget.text),
                      ),
                      const SizedBox(width: 10),
                      if (widget.icon != null)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                            _isHovered ? 2 : 0,
                            0,
                            0,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 24,
                            color: foregroundColor,
                          ),
                        ),
                      // else if (widget.variant == ButtonVariant.primary)
                      //   AnimatedContainer(
                      //     duration: const Duration(milliseconds: 200),
                      //     transform: Matrix4.translationValues(
                      //       _isHovered ? 2 : 0,
                      //       0,
                      //       0,
                      //     ),
                      //     child: Icon(
                      //       Icons.arrow_right,
                      //       size: 24,
                      //       color: foregroundColor,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (widget.label == null || widget.label!.isEmpty) {
      return buttonWidget;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onLabelPressed,
          child: Text(
            widget.label!,
            style: const TextStyle(
              color: Colors.yellow,
              decoration: TextDecoration.underline,
              decorationColor: Colors.yellow,
              fontSize: 16,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 8),
        buttonWidget,
      ],
    );
  }
}

class ButtonTab extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback? onTap;

  const ButtonTab({
    super.key,
    required this.text,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 32,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: ShapeDecoration(
            color: const Color(0xFFFFF7F7),
            shape: RoundedRectangleBorder(
              side: isActive
                  ? BorderSide(width: 1, color: const Color(0xFFC13433))
                  : BorderSide.none,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFF840100)
                    : const Color(0xFFAE9DA0),
                fontSize: 10,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

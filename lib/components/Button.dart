/*import 'dart:developer';

import 'package:flutter/cupertino.dart' show StatelessWidget;
import 'package:flutter/material.dart';

class _ButtonActionsState extends State<ButtonActions>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
 class _ButtonActionsState extends State<ButtonActions>
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
  }*/
import 'package:flutter/material.dart';
import 'package:app/style/theme.dart';

enum InputVariant {
  active,    // With search icon and focused state
  inactive,  // Normal state without icon
  withAction // With action button and badge
}

class Input extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final String? helperText;
  final InputVariant variant;
  final VoidCallback? onActionPressed;
  final String? badgeValue;
  final Widget? customIcon;
  final IconData? materialIcon;
  final bool showGradientBorder;

  const Input({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.obscureText = false,
    this.validator,
    this.helperText,
    this.variant = InputVariant.inactive,
    this.onActionPressed,
    this.badgeValue,
    this.customIcon,
    this.materialIcon,
    this.showGradientBorder = false,
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
          child: Icon(
            Icons.search,
            color: AppColors.primary,
            size: 20,
          ),
        );
      
      case InputVariant.withAction:
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF45171D), Color(0xFFFE5654)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onActionPressed,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.customIcon != null) widget.customIcon!,
                        if (widget.customIcon != null && widget.materialIcon != null) 
                          const SizedBox(width: 4),
                        if (widget.materialIcon != null)
                          Icon(
                            widget.materialIcon,
                            color: Colors.white,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Badge
            if (widget.badgeValue != null && widget.badgeValue!.isNotEmpty)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE91E63),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Text(
                    widget.badgeValue!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      
      case InputVariant.inactive:
      default:
        return const SizedBox.shrink();
    }
  }

  InputBorder _buildBorder({required bool isFocused, required bool isError}) {
    if (widget.showGradientBorder) {
      // For gradient border, we'll use a custom approach
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
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
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
        margin: const EdgeInsets.only(left: 1, right: 1, bottom: 1), // No top margin for no top border
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
    final hasError = widget.validator != null && 
        widget.controller != null && 
        widget.validator!(widget.controller!.text) != null;

    Widget textField = TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: widget.obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        suffixIcon: _buildSuffixIcon(),
        
        // Background Color
        filled: true,
        fillColor: const Color(0xFFFFF7F7),
        
        // Padding
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        
        // Borders
        border: _buildBorder(isFocused: false, isError: false),
        enabledBorder: _buildBorder(isFocused: false, isError: hasError),
        focusedBorder: _buildBorder(isFocused: true, isError: hasError),
        errorBorder: _buildBorder(isFocused: false, isError: true),
        focusedErrorBorder: _buildBorder(isFocused: true, isError: true),
        
        // Text Styling
        floatingLabelStyle: TextStyle(
          color: hasError ? AppColors.error : AppColors.primary,
          fontSize: 12,
          fontFamily: 'Kanit',
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: hasError ? AppColors.error : AppColors.textSecondary,
          fontFamily: 'Kanit',
        ),
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'Kanit',
        ),
        helperStyle: const TextStyle(
          color: AppColors.primary,
          fontSize: 10,
          fontFamily: 'Kanit',
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: 10,
          fontFamily: 'Kanit',
        ),
      ),
      style: const TextStyle(
        fontFamily: 'Kanit',
        color: Color(0xFF45171D),
      ),
    );

    return _buildGradientBorderContainer(child: textField);
  }
}

// Custom Icon Widget for use with the input
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
    return Icon(
      icon,
      color: color ?? Colors.white,
      size: size,
    );
  }
}

// Example usage class
class InputExamples extends StatefulWidget {
  const InputExamples({super.key});

  @override
  State<InputExamples> createState() => _InputExamplesState();
}

class _InputExamplesState extends State<InputExamples> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F2),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 50),
            
            // Variant 1: Active (with search icon)
            Input(
              controller: _controller1,
              labelText: "Title",
              hintText: "Text",
              helperText: "* req",
              variant: InputVariant.active,
            ),
            
            const SizedBox(height: 24),
            
            // Variant 2: Inactive (normal)
            Input(
              controller: _controller2,
              labelText: "Title", 
              hintText: "Text",
              helperText: "* req",
              variant: InputVariant.inactive,
            ),
            
            const SizedBox(height: 24),
            
            // Variant 3: With Action (button with badge)
            Input(
              controller: _controller3,
              labelText: "Title",
              hintText: "Label",
              helperText: "* req",
              variant: InputVariant.withAction,
              badgeValue: "1",
              customIcon: const CustomInputIcon(icon: Icons.shopping_cart),
              materialIcon: Icons.add,
              onActionPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action pressed!')),
                );
              },
            ),
            
            const SizedBox(height: 24),
            
            // Example with gradient border
            Input(
              controller: TextEditingController(),
              labelText: "Title",
              hintText: "Text",
              helperText: "* req",
              variant: InputVariant.inactive,
              showGradientBorder: true,
            ),
          ],
        ),
      ),
    );
  }
}
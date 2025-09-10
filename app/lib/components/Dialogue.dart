import 'dart:ui'; // สำหรับเบลอพื้นหลัง

import 'package:flutter/material.dart';

enum DialogType { success, error, warning, info, custom }

class DynamicDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<DialogButton>? actions;
  final DialogType type;
  final bool barrierDismissible;
  final double? maxWidth;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;

  const DynamicDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions,
    this.type = DialogType.custom,
    this.barrierDismissible = true,
    this.maxWidth = 320,
    this.padding = const EdgeInsets.all(24),
    this.decoration,
  });

  Color _getTitleColor() {
    switch (type) {
      case DialogType.success:
        return const Color(0xFF28A745);
      case DialogType.error:
        return const Color(0xFFDC3545);
      case DialogType.warning:
        return const Color(0xFFFFC107);
      case DialogType.info:
        return const Color(0xFF17A2B8);
      case DialogType.custom:
        return const Color(0xFF45171D);
    }
  }

  BoxDecoration _getDefaultDecoration() {
    if (decoration != null) return decoration!;

    switch (type) {
      case DialogType.success:
        return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5E8), Color(0xFFF1F8E9)],
          ),
          borderRadius: BorderRadius.circular(16),
        );
      case DialogType.error:
        return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFCE4E4), Color(0xFFFFF5F5)],
          ),
          borderRadius: BorderRadius.circular(16),
        );
      case DialogType.warning:
        return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
          ),
          borderRadius: BorderRadius.circular(16),
        );
      case DialogType.info:
        return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE3F2FD), Color(0xFFE1F5FE)],
          ),
          borderRadius: BorderRadius.circular(16),
        );
      case DialogType.custom:
        return BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFE2E2), Color(0xFFFFFADD)],
          ),
          borderRadius: BorderRadius.circular(16),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth!),
        padding: padding,
        decoration: _getDefaultDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _getTitleColor(),
                fontFamily: 'Kanit',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            content,
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 20),
              ...actions!.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: action.onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            action.backgroundColor ?? const Color(0xFFFF4745),
                        foregroundColor: action.foregroundColor ?? Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        action.text,
                        style: TextStyle(
                          fontFamily: 'Kanit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required Widget content,
    List<DialogButton>? actions,
    DialogType type = DialogType.custom,
    bool barrierDismissible = true,
    double? maxWidth,
    EdgeInsets? padding,
    BoxDecoration? decoration,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      useSafeArea: true,
      builder: (BuildContext context) => DynamicDialog(
        title: title,
        content: content,
        actions: actions,
        type: type,
        barrierDismissible: barrierDismissible,
        maxWidth: maxWidth,
        padding: padding,
        decoration: decoration,
      ),
    );
  }
}

class DialogButton {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const DialogButton({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });
}

// Convenience functions for common dialog types
class DialogHelper {
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    List<DialogButton>? actions,
  }) {
    DynamicDialog.show(
      context,
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF45171D),
          fontFamily: 'Kanit',
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      type: DialogType.success,
      actions:
          actions ??
          [
            DialogButton(
              text: 'ตกลง',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String message,
    List<DialogButton>? actions,
  }) {
    DynamicDialog.show(
      context,
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF45171D),
          fontFamily: 'Kanit',
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      type: DialogType.error,
      actions:
          actions ??
          [
            DialogButton(
              text: 'ตกลง',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
    );
  }

  static void showWarning(
    BuildContext context, {
    required String title,
    required String message,
    List<DialogButton>? actions,
  }) {
    DynamicDialog.show(
      context,
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF45171D),
          fontFamily: 'Kanit',
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      type: DialogType.warning,
      actions:
          actions ??
          [
            DialogButton(
              text: 'ตกลง',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
    );
  }

  static void showInfo(
    BuildContext context, {
    required String title,
    required String message,
    List<DialogButton>? actions,
  }) {
    DynamicDialog.show(
      context,
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF45171D),
          fontFamily: 'Kanit',
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      type: DialogType.info,
      actions:
          actions ??
          [
            DialogButton(
              text: 'ตกลง',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
    );
  }

  static void showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    DynamicDialog.show(
      context,
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF45171D),
          fontFamily: 'Kanit',
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
      type: DialogType.warning,
      actions: [
        DialogButton(
          text: cancelText,
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          backgroundColor: const Color(0xFF6C757D),
        ),
        DialogButton(
          text: confirmText,
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          backgroundColor: const Color(0xFFDC3545),
        ),
      ],
    );
  }
}

//โชว์ Dialog ระบุจำนวนเหรียญ
void showCreateMoneyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ระบุจำนวนเหรียญสำหรับทดสอบระบบ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1 เหรียญ = 1 บาท',
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '100',
                  suffixText: 'เหรียญ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // ปิด dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'ย้อนกลับ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logic สำหรับการยืนยัน
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text(
                      'ยืนยัน',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

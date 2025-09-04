import 'package:flutter/material.dart';
import 'package:qr/qr.dart';

class QrCodeWidget extends StatelessWidget {
  final String data;
  final double size;
  final Color foregroundColor;
  final Color backgroundColor;
  final int padding;

  const QrCodeWidget({
    super.key,
    required this.data,
    required this.size,
    this.foregroundColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.padding = 1,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: QrCodePainter(
          data: data,
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          padding: padding,
        ),
      ),
    );
  }
}

class QrCodePainter extends CustomPainter {
  final String data;
  final Color foregroundColor;
  final Color backgroundColor;
  final int padding;

  QrCodePainter({
    required this.data,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.padding,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final qrCode = QrCode.fromData(
      data: data,
      errorCorrectLevel: QrErrorCorrectLevel.L,
    );

    qrCode.make();

    final backgroundPaint = Paint()..color = backgroundColor;
    final foregroundPaint = Paint()..color = foregroundColor;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final totalModules = qrCode.moduleCount + (padding * 2);
    final double moduleSize = size.width / totalModules.toDouble();

    for (var x = 0; x < qrCode.moduleCount; x++) {
      for (var y = 0; y < qrCode.moduleCount; y++) {
        if (qrCode.isDark(y, x)) {
          final left = (x + padding) * moduleSize;
          final top = (y + padding) * moduleSize;
          final rect = Rect.fromLTWH(left, top, moduleSize, moduleSize);
          canvas.drawRect(rect, foregroundPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant QrCodePainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.foregroundColor != foregroundColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.padding != padding;
  }
}


// OPTIONAL: This helper remains a convenient way to call the widget.
class QrCodeHelper {
  /// Generates a QR code image widget for the given data.
  static Widget generateQrImage(String data) {
    return QrCodeWidget(
      data: data,
      size: 24.0,
      padding: 1, // A small white border makes it easier to scan
    );
  }
}
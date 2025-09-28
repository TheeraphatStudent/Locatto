import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../style/theme.dart';

class QrWidget extends StatelessWidget {
  const QrWidget({super.key, required this.data, this.size = 100});

  final String data;
  final double size;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: data,
      version: QrVersions.auto,
      size: size,
      gapless: false,
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: AppColors.onBackground,
      ),
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: AppColors.onBackground,
      ),
      padding: EdgeInsets.zero,
      // backgroundColor: Colors.white,
      foregroundColor: AppColors.onBackground,
    );
  }
}

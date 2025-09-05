/*import 'package:app/components/Footer.dart';
import 'package:app/components/Header.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final bool showHeader;
  final bool showFooter;

  const MainLayout({
    super.key,
    required this.body,
    this.showHeader = true,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.softGradientPrimary,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: showHeader ? const Header() : null,
        body: body,
        bottomNavigationBar: showFooter ? const Footer() : null,
      ),
    );
  }
}*/
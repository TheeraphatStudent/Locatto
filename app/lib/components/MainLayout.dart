import 'package:app/components/Footer.dart';
import 'package:app/components/Header.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool showHeader;
  final bool showFooter;

  const MainLayout({
    super.key,
    required this.body,
    this.appBar,
    this.showHeader = true,
    this.showFooter = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.softGradientPrimary),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar ?? (showHeader ? const Header() : null),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: body,
        ),
        bottomNavigationBar: showFooter ? const Footer() : null,
      ),
    );
  }
}

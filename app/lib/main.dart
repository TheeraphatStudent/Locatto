// import 'dart:developer';

import 'package:app/pages/cart.page.dart';
import 'package:app/pages/home.page.dart';
import 'package:app/pages/login.page.dart';
import 'package:app/pages/lottery.page.dart';
// import 'package:app/components/Avatar.dart';
// import 'package:app/components/Button.dart';
// import 'package:app/components/Footer.dart';
// import 'package:app/components/Input.dart';
// import 'package:app/components/Lottery.dart';
// import 'package:app/pages/notfound.page.dart';
import 'package:app/pages/profile.page.dart';
import 'package:app/pages/purchase.page.dart';
import 'package:app/pages/register.page.dart';
import 'package:flutter/material.dart';
import 'style/theme.dart';
// import 'package:app/components/ActiveButton.dart';
// import 'package:app/components/DisabledButton.dart';
// import 'package:app/components/์Select_Number_Button.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/lottery': (context) => const LotteryPage(),
        '/purchase': (context) => const PurchasePage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
      },
      // onUnknownRoute: (context) => const NotfoundPage(),
    );
  }
}

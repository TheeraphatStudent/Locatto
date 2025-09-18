// import 'dart:developer';

import 'package:app/components/Box_make_reward.dart';
import 'package:app/pages/cart.page.dart';
import 'package:app/pages/debug.page.dart';
import 'package:app/pages/home.page.dart';
import 'package:app/pages/login.page.dart';
import 'package:app/pages/lottery.page.dart';
import 'package:app/pages/onboarding.page.dart';
import 'package:app/pages/profile_detail.dart';
// import 'package:app/components/Avatar.dart';
// import 'package:app/components/Button.dart';
// import 'package:app/components/Footer.dart';
// import 'package:app/components/Input.dart';
// import 'package:app/components/Lottery.dart';
// import 'package:app/pages/notfound.page.dart';
import 'package:app/pages/profile.page.dart';
import 'package:app/pages/purchase.page.dart';
import 'package:app/pages/register.page.dart';
import 'package:app/pages/forgotpass.page.dart';
import 'package:app/pages/test.dart';
import 'package:flutter/material.dart';
import 'style/theme.dart';
import 'package:app/pages/admin/home.dart' as _AdminHome;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: '/profile',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/lottery': (context) => const LotteryPage(),
        '/purchase': (context) => const PurchasePage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/onboarding': (context) => const OnBoardingPage(),
        '/forgotpass': (context) => const ForgotPassPage(),
        '/boxreward': (context) => const Box_make_reward(),
        '/profile_detail': (context) => const Profile_Detail(),

        '/debug': (context) => const DebugPage(),
        '/test': (context) => const TestPage(),

        '/admin': (context) => const _AdminHome.HomePage(),
      },
      // onUnknownRoute: (context) => const NotfoundPage(),
    );
  }
}

// import 'dart:developer';

import 'package:app/components/Box_make_reward.dart';
import 'package:app/pages/cart.page.dart';
import 'package:app/pages/debug.page.dart';
import 'package:app/pages/home.page.dart';
import 'package:app/pages/login.page.dart';
import 'package:app/pages/lottery.page.dart';
import 'package:app/pages/onboarding.page.dart';
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
import 'package:app/pages/success.page.dart';
import 'package:app/pages/test.dart';
import 'package:app/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'style/theme.dart';
import 'package:app/pages/admin/home.dart' as _AdminHome;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Auth _auth = Auth();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _initialRoute = '/onboarding';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final isValid = await _auth.checkAuth();

      if (isValid) {
        setState(() {
          _initialRoute = '/home';
          _isLoading = false;
        });
      } else {
        await _storage.deleteAll();
        setState(() {
          _initialRoute = '/onboarding';
          _isLoading = false;
        });
      }
    } catch (e) {
      await _storage.deleteAll();
      setState(() {
        _initialRoute = '/onboarding';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      initialRoute: _initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/lottery': (context) => const LotteryPage(),
        '/purchase': (context) => const PurchasePage(),
        // '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/onboarding': (context) => const OnBoardingPage(),
        '/forgotpass': (context) => const ForgotPassPage(),

        '/success': (context) => const SuccessPage(),

        '/boxreward': (context) => const Box_make_reward(),
        '/debug': (context) => const DebugPage(),
        '/test': (context) => const TestPage(),

        '/admin': (context) => const _AdminHome.HomePage(),
      },
      // onUnknownRoute: (context) => const NotfoundPage(),
      onGenerateRoute: (initialRoute) => MaterialPageRoute(
        builder: (context) => Center(child: const CircularProgressIndicator()),
      ),
    );
  }
}

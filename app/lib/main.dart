import 'dart:async';
import 'dart:developer';
import 'package:app/pages/admin/adminHome.dart' hide HomePage;
import 'package:app/pages/admin/adminProfile.dart';
import 'package:app/pages/debug.page.dart';
import 'package:app/pages/home.page.dart';
import 'package:app/pages/login.page.dart';
import 'package:app/pages/lottery.page.dart';
import 'package:app/pages/onboarding.page.dart';
import 'package:app/pages/profile.page.dart';
import 'package:app/pages/purchase.page.dart';
import 'package:app/pages/register.page.dart';
import 'package:app/pages/forgotpass.page.dart';
import 'package:app/pages/success.page.dart';
import 'package:app/pages/test.dart';
import 'package:app/service/auth.dart';
import 'package:app/service/user.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'style/theme.dart';

void main() => runApp(
  ChangeNotifierProvider<UserProvider>(
    create: (_) => UserProvider(),
    child: const MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Auth _auth = Auth();
  final UserService _userService = UserService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isCheckingAuth = true;
  bool _isAuthenticated = false;
  String? _userRole;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final result = await _auth.checkAuth().timeout(const Duration(seconds: 10));
      final isValid = result['isValid'] as bool;
      final role = result['role'] as String?;
      final credit = result['credit'] as int;

      log("Is valid: $isValid, Role: $role");

      if (mounted) {
        setState(() {
          _isAuthenticated = isValid;
          _isCheckingAuth = false;
          _userRole = role;
        });

        final provider = Provider.of<UserProvider>(context, listen: false);
        provider.updateCredit(credit);

        await _userService.storeUserCredit(credit.toString());

        if (!isValid) {
          await _storage.deleteAll();
        }
      }
    } on TimeoutException catch (e) {
      log("Auth check timed out: $e");
      await _storage.deleteAll();

      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isCheckingAuth = false;
          _userRole = null;
        });
      }
    } catch (e) {
      log("Auth check error: $e");
      await _storage.deleteAll();

      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isCheckingAuth = false;
          _userRole = null;
        });
      }
    }
  }

  Widget get _homeWidget {
    if (_isCheckingAuth) {
      return const AuthCheckingScreen();
    }

    if (_isAuthenticated) {
      if (_userRole == 'admin') {
        return const AdminHomePage();
      } else {
        return const HomePage();
      }
    }

    return const OnBoardingPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: _homeWidget,
      // initialRoute: '/test',
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

        '/debug': (context) => const DebugPage(),
        '/test': (context) => const TestPage(),

        '/adminProfile': (context) => const AdminProfilePage(),
        '/adminHome': (context) => const AdminHomePage(),
      },
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) =>
            const Scaffold(body: Center(child: Text('Page not found'))),
      ),
    );
  }
}

class AuthCheckingScreen extends StatelessWidget {
  const AuthCheckingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

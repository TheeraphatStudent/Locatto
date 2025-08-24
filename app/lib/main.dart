import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Footer.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/Lottery.dart';
import 'package:flutter/material.dart';
import 'style/theme.dart';
import 'components/Header.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.softGradientPrimary,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const Header(),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
            child: ListView(
              primary: false,
              shrinkWrap: true,
              children: <Widget>[
                const ButtonActions(
                  hasShadow: true,
                  key: Key("Continue Key"),
                  text: "ไปกันเลย",
                ),
                const Input(
                  labelText: "Something",
                  key: Key("Something-key"),
                  hintText: "It working!",
                  helperText: "Hello world",
                ),
                const Avatar(
                  // mode: AvatarMode.view,
                ),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap:
                      true, // Important: This makes GridView take only needed space
                  physics:
                      NeverScrollableScrollPhysics(), // Disable GridView scrolling
                  childAspectRatio: 2.0,
                  // Gap
                  crossAxisSpacing: 10, // Y
                  mainAxisSpacing: 10, // X
                  children: <Widget>[
                    Lottery(lotteryNumber: "123456"),
                    Lottery(lotteryNumber: "123456"),
                    Lottery(lotteryNumber: "123456"),
                    Lottery(lotteryNumber: "123456"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                    Lottery(lotteryNumber: "478233"),
                  ],
                ),
              ],
            ),
          ),
          bottomNavigationBar: const Footer(),
        ),
      ),
    );
  }
}

import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Footer.dart';
import 'package:app/components/Input.dart';
import 'package:flutter/material.dart';
import 'style/theme.dart';
import 'components/Header.dart';
import 'package:app/components/ActiveButton.dart';
import 'package:app/components/DisabledButton.dart';
import 'package:app/components/์Select_Number_Button.dart';

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
              children: const <Widget>[
                ButtonActions(
                  hasShadow: true,
                  key: Key("Continue Key"),
                  text: "ไปกันเลย",
                ),
                Input(
                  labelText: "Something",
                  key: Key("Something-key"),
                  hintText: "It working!",
                  helperText: "Hello world",
                ),
                Avatar(
                  // mode: AvatarMode.view,
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

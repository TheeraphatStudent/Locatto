import 'package:app/components/Button.dart';
import 'package:app/components/Lottery.dart';
import 'package:flutter/material.dart';
import 'components/Header.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const Header(),
        body: ListView(
          primary: false,
          shrinkWrap: true,
          children: const [
            ButtonActions(
              hasShadow: true,
              key: Key("Continue Key"),
              text: "ไปกันเลย",
            ),
          ],
        ),
      ),
    );
  }
}

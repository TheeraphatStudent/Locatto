import 'package:app/components/Input.dart';
import 'package:app/components/MainLayout.dart';
import 'package:flutter/material.dart';

class LotteryPage extends StatelessWidget {
  const LotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(children: [Input(labelText: "Hello world")]),
    );
  }
}

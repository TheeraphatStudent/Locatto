/*import 'dart:developer';

import 'package:app/components/Avatar.dart';
import 'package:app/components/Button.dart';
import 'package:app/components/Input.dart';
import 'package:app/components/Lottery.dart';
import 'package:app/components/MainLayout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
        child: ListView(
          primary: false,
          shrinkWrap: true,
          children: <Widget>[
            ButtonActions(
              hasShadow: true,
              key: const Key("Continue Key"),
              text: "ไปกันเลย",
              onPressed: () {
                log("pressed callback work!");
                Navigator.pushNamed(context, '/lottery');
              },
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
                  const NeverScrollableScrollPhysics(), // Disable GridView scrolling
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
    );
  }
}*/

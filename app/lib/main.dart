import 'package:app/components/Btn.dart';
import 'package:flutter/material.dart';
import 'components/Header.dart';
import 'package:app/components/ActiveButton.dart';
import 'package:app/components/DisabledButton.dart';
import 'package:app/components/์Select_Number_Button.dart';

main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        appBar: Header(),
        body: const Center(
          child: Column(
           /* children: [
            ButtonAction(type: ButtonType.active),
            ButtonAction(type: ButtonType.inactive),
            ButtonAction(type: ButtonType.disabled),
            ButtonAction(type: ButtonType.disabled),
            ButtonAction(type: ButtonType.disabled),

          const SizedBox(height: 10),
          const DisabledButton(label: "Disabled"),
        ],*/

           children: [
            Select_Number_Button(
              text: "888888",
               onPressed: () {
                print("กดปุ่มรางวัลที่ 1");
              },
          ),
              const SizedBox(height: 20),
            Select_Number_Button(
              text: "888 888",
               onPressed: () {
                print("กดปุ่มเลขหน้า 3 ตัว");
              },
          ),
             const SizedBox(height: 20),
            Select_Number_Button(
              text: "888 888",
              onPressed: () {
               print("กดปุ่มเลขท้าย 3 ตัว");
             },
          ),
        ],
          ),
        ),
      ),
    );
  }
}

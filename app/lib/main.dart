import 'package:app/components/Btn.dart';
import 'package:flutter/material.dart';
import 'components/Header.dart';


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
            children: [
             ButtonAction(type: ButtonType.active),
              ButtonAction(type: ButtonType.inactive),
              ButtonAction(type: ButtonType.disabled),
              ButtonAction(type: ButtonType.disabled),
              ButtonAction(type: ButtonType.disabled),

              
            ],
          ),
        ),
      ),
    );
  }
}

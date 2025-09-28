import 'package:flutter/material.dart';

class DisabledButton extends StatelessWidget {
  final String label;

  const DisabledButton({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onPressed: null,
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

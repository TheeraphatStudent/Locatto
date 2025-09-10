import 'package:flutter/material.dart';

class CoinComponent extends StatelessWidget {
  final int coinCount;
  
  const CoinComponent({
    Key? key,
    required this.coinCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 240, 224, 219),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
         
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.amber,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text('😸', style: TextStyle(fontSize: 24)),
            ),
          ),
          SizedBox(width: 12),
         
          Text(
            coinCount == 0 ? 'ยังไม่มีเหรียญ?' : '$coinCount',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
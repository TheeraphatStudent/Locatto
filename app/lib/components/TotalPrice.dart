import 'package:flutter/material.dart';

class TotalPrice extends StatelessWidget {
  final int price;
  final int coin;
  final int itemCount;
  final VoidCallback onPay;

  const TotalPrice({
    super.key,
    required this.price,
    required this.coin,
    required this.itemCount,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '฿ ${price.toString()}',
                style: const TextStyle(
                  color: Color(0xFFFE5654),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              Text(
                '+$coin Coin',
                style: const TextStyle(color: Colors.brown, fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE5654),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
              onPressed: onPay,
              child: Text(
                'ชำระเงิน ($itemCount)',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

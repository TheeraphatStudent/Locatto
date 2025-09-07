import 'package:flutter/material.dart';

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({super.key});

  @override
  State<PaymentMethod> createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  String? selectedMethod;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFEFEF), // พื้นหลังชมพูอ่อน
      elevation: 6.0,
      shadowColor: Colors.black.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // หัวข้อ
            Text(
              "วิธีการชำระเงิน",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: const Color(0xFF45171D),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // วิธีจ่าย Lotto Coin
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  if (selectedMethod == "lotto_coin") {
                    selectedMethod = null; // ยกเลิก
                  } else {
                    selectedMethod = "lotto_coin"; // เลือก
                  }
                });
              },
              child: Row(
                children: [
                  Icon(
                    selectedMethod == "lotto_coin"
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Colors.pink,
                  ),
                  const SizedBox(width: 8),
                  Image.asset('assets/images/coin.png', width: 24, height: 24),
                  const SizedBox(width: 8),
                  const Text(
                    "Lotto Coin",
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

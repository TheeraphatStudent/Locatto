import 'package:flutter/material.dart';

class Exchanged_money extends StatefulWidget {
  const Exchanged_money({super.key});

  @override
  State<Exchanged_money> createState() => _ExchangedMoneyState();
}

class _ExchangedMoneyState extends State<Exchanged_money> {
  final TextEditingController _coinController = TextEditingController();
  double money = 0.0;

  void _updateAmount(String value) {
    if (value.isEmpty) {
      setState(() {
        money = 0.0;
      });
      return;
    }
    final coins = int.tryParse(value) ?? 0;
    setState(() {
      money = coins * 1.0; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 255, 237, 228),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "จำนวนเงินที่แลก",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "จำนวนเหรียญ",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _coinController,
                      keyboardType: TextInputType.number,
                      onChanged: _updateAmount,
                      decoration: InputDecoration(
                        hintText: "ขั้นต่ำ 1 เหรียญ",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "จำนวนเงินที่ได้",
                      style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(241, 228, 228, 228),
                        hintText: "${money.toStringAsFixed(2)} บาท",
                        hintStyle: const TextStyle(color: Colors.black54),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PrizesetupPage extends StatelessWidget {
  PrizesetupPage({super.key});

  final List<String> prizeTypes = [
    "รางวัลที่ 1",
    "รางวัลที่ 2",
    "รางวัลที่ 3",
    "เลขท้าย 3 ตัว",
    "เลขท้าย 2 ตัว",
  ];

  final List<TextEditingController> controllers = List.generate(
    5,
    (index) => TextEditingController(text: "0"),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width:
          MediaQuery.of(context).size.width *
          0.9, // กำหนดความกว้าง 90% ของหน้าจอ
      constraints: const BoxConstraints(
        maxHeight: 100, // จำกัดความสูง
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // สีพื้นหลัง
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 14.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "ประเภทของรางวัล",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "จำนวนเงิน",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ...List.generate(prizeTypes.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      prizeTypes[index],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: controllers[index],
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: const BorderSide(color: Colors.redAccent),
                        ),
                        suffixText: "บาท",
                        suffixStyle: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Cancel button logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 40,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("ยกเลิก"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save button logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                    side: const BorderSide(color: Colors.red),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 40,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text(
                  "บันทึก",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/service/reward/post.dart' as RewardServicePost;
import 'package:app/service/reward/get.dart' as RewardServiceGet;
import 'package:app/components/Button.dart';

class PrizesetupPage extends StatefulWidget {
  const PrizesetupPage({super.key});

  @override
  State<PrizesetupPage> createState() => _PrizesetupPageState();
}

class _PrizesetupPageState extends State<PrizesetupPage> {
  final RewardServiceGet.RewardService _rewardServiceGet =
      RewardServiceGet.RewardService();
  final RewardServicePost.RewardService _rewardServicePost =
      RewardServicePost.RewardService();

  final List<String> prizeTypes = [
    "รางวัลที่ 1", // T1
    "รางวัลที่ 2", // T2
    "รางวัลที่ 3", // T3
    "เลขท้าย 3 ตัว", // T1L3
    "เลขท้าย 2 ตัว", // R2
  ];

  final List<TextEditingController> prizeFields = List.generate(
    5,
    (index) => TextEditingController(text: "0"),
  );

  final Map<int, String> _originalValues = {};
  bool _isLoading = true;

  // Mapping from tier to prize field index
  final Map<String, int> _tierMapping = {
    'T1': 0, // รางวัลที่ 1
    'T2': 1, // รางวัลที่ 2
    'T3': 2, // รางวัลที่ 3
    'T1L3': 3, // เลขท้าย 3 ตัว
    'R2': 4, // เลขท้าย 2 ตัว
  };

  @override
  void initState() {
    super.initState();
    _fetchRewards();
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    for (var controller in prizeFields) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchRewards() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final rewards = await _rewardServiceGet.getAll();
      log('Fetched rewards: ${rewards.toString()}');

      // Clear existing values
      _originalValues.clear();

      // Initialize all fields with default values first
      for (int i = 0; i < prizeFields.length; i++) {
        prizeFields[i].text = "0";
        _originalValues[i] = "0";
      }

      // Process each reward from API
      for (var reward in rewards) {
        final tier = reward['tier'] as String?;
        final revenue = reward['revenue']?.toString() ?? "0";

        if (tier != null && _tierMapping.containsKey(tier)) {
          final index = _tierMapping[tier]!;
          log("Mapping tier '$tier' to index $index with revenue: $revenue");

          // Update the specific field
          prizeFields[index].text = _formatRevenue(revenue);
          _originalValues[index] = _formatRevenue(revenue);
        } else {
          log("Unknown tier '$tier' - no mapping found");
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      log("Error fetching rewards: ${e.toString()}");

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to load rewards: $e')));
      }
    }
  }

  String _formatRevenue(String revenue) {
    try {
      final double value = double.parse(revenue);
      if (value == value.toInt()) {
        return value.toInt().toString();
      }
      return value.toString();
    } catch (e) {
      return revenue;
    }
  }

  void resetFields() {
    for (var index = 0; index < prizeFields.length; index++) {
      prizeFields[index].text = _originalValues[index] ?? "0";
    }
    setState(() {});
  }

  Future<void> sendDataToAPI(BuildContext context) async {
    Map<String, dynamic> prizeData = {};

    // Validate all fields first
    for (int i = 0; i < prizeFields.length; i++) {
      final value = prizeFields[i].text.trim();

      // Check if it's a valid number
      if (value.isEmpty || double.tryParse(value) == null) {
        _showErrorDialog(
          context,
          "ข้อผิดพลาด",
          "กรุณากรอกจำนวนเงินที่ถูกต้องใน${prizeTypes[i]}",
        );
        return;
      }

      prizeData["${i + 1}"] = value;
    }

    try {
      final response = await _rewardServicePost.manageRewards(prizeData);
      log('API Response: $response');

      if (mounted) {
        _showSuccessDialog(
          context,
          "สำเร็จ",
          "ข้อมูลรางวัลถูกบันทึกเรียบร้อยแล้ว",
        );

        // Update original values after successful save
        for (int i = 0; i < prizeFields.length; i++) {
          _originalValues[i] = prizeFields[i].text;
        }
      }
    } catch (e) {
      log('Error saving rewards: $e');

      if (mounted) {
        _showErrorDialog(
          context,
          "ข้อผิดพลาด",
          "ไม่สามารถบันทึกข้อมูลได้ กรุณาลองอีกครั้ง",
        );
      }
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ตกลง"),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("ตกลง"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrizeField(int index, String prizeType) {
    return Padding(
      key: ValueKey('prize_field_$index'),
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              prizeType,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextField(
              key: ValueKey('text_field_$index'),
              controller: prizeFields[index],
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
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(11),
                  borderSide: const BorderSide(
                    color: Colors.redAccent,
                    width: 2,
                  ),
                ),
                suffixText: "บาท",
                suffixStyle: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                if (prizeFields[index].text == "0") {
                  prizeFields[index].clear();
                }
              },
              onChanged: (value) {
                // Optional: Add real-time validation here
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.onBackground.withOpacity(0.1),
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
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(),
            )
          else
            // Render each field individually
            ...List.generate(
              prizeTypes.length,
              (index) => _buildPrizeField(index, prizeTypes[index]),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ButtonActions(
                  text: "ยกเลิก",
                  variant: ButtonVariant.primary,
                  theme: Colors.red,
                  onPressed: _isLoading ? null : resetFields,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ButtonActions(
                  text: "บันทึก",
                  variant: ButtonVariant.light,
                  onPressed: _isLoading ? null : () => sendDataToAPI(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:app/components/StatusTags.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Dialogue.dart' as Dialogue;
import 'package:app/service/purchase/get.dart';
import 'package:app/service/lottery/reward.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({super.key});

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  late Future<List<Map<String, dynamic>>> _purchasesFuture;

  @override
  void initState() {
    super.initState();
    _purchasesFuture = _loadPurchases();
  }

  Future<List<Map<String, dynamic>>> _loadPurchases() async {
    try {
      final purchaseService = PurchaseService();
      final response = await purchaseService.getByUserWithStatus(1, 10);
      return List<Map<String, dynamic>>.from(response['purchases'] ?? []);
    } catch (e) {
      return [];
    }
  }

  /// ✅ claimReward (step 4)
  Future<void> _claimReward(int rewardId, BuildContext context) async {
    try {
      final rewardService = RewardService();
      final response = await rewardService.claimReward(rewardId);

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('นำส่งรางวัลสำเร็จ 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        // reload purchases หลังจากเคลมเสร็จ
        setState(() {
          _purchasesFuture = _loadPurchases();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'ล้มเหลว')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('เกิดข้อผิดพลาดในการนำส่งรางวัล')),
      );
    }
  }

  // Helper functions
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      final year = date.year.toString();
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day/$month/$year $hour:$minute';
    } catch (e) {
      return dateString;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "win":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "fail":
      case "lose":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case "win":
        return "ถูกรางวัล";
      case "pending":
        return "รอประกาศ";
      case "fail":
      case "lose":
        return "ไม่ถูกรางวัล";
      case "claimed":
        return "ได้รับรางวัลแล้ว";
      default:
        return "ไม่ทราบสถานะ";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _purchasesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final purchases = snapshot.data ?? [];

          if (purchases.isEmpty) {
            return const Center(child: Text("ยังไม่มีการซื้อลอตเตอรี่"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final purchase = purchases[index];
              final lotInfo =
                  purchase['lot_info'] as Map<String, dynamic>? ?? {};

              // ✅ สร้าง StatusTags object เพียงครั้งเดียว
              final statusTagData = PurchaseLotteryCard(
                period: purchase["created"] ?? "",
                status: purchase["status"] ?? "pending",
                rewards: [
                  {
                    "number": lotInfo['lottery_number'] ?? "-",
                    "type": purchase["status"] ?? "pending",
                    "amount": purchase["amount"] ?? 1,
                    "prize": purchase["prize"] ?? "-",
                  },
                ],
                onClaim: () => _claimReward(purchase["rewardId"] ?? 0, context),
              );

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    Dialogue.showCustomStatusTagsDialog(context, statusTagData);
                  },
                  child: Container(
                    // ✅ สร้าง UI แทนการใช้ StatusTags เป็น Widget
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(statusTagData.period),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStatusColor(statusTagData.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getStatusText(statusTagData.status),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'หมายเลข: ${lotInfo['lottery_number'] ?? "-"}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'จำนวน: ${purchase["amount"] ?? 1} ใบ',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (purchase["prize"] != null &&
                            purchase["prize"].toString() != "-")
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'รางวัล: ${purchase["prize"]}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

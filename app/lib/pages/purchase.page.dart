import 'package:app/components/StatusTags.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Dialogue.dart' as Dialogue;
import 'package:app/service/purchase/get.dart';
import 'package:app/service/lottery/reward.dart';
import 'package:app/providers/user_provider.dart';
import 'package:provider/provider.dart';

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

  Future<void> _claimReward(int? rewardId, BuildContext context) async {
    if (rewardId == null || rewardId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ไม่พบข้อมูล reward ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // แสดงไดอะล็อกยืนยันการเคลมรางวัล
    bool? shouldClaim = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.amber),
              SizedBox(width: 8),
              Text('ยืนยันการรับรางวัล'),
            ],
          ),
          content: const Text('คุณต้องการรับรางวัลนี้ใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('รับรางวัล'),
            ),
          ],
        );
      },
    );

    if (shouldClaim != true) return;

    try {
      // แสดง loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text('กำลังนำส่งรางวัล...'),
              ],
            ),
          );
        },
      );

      final rewardService = RewardService();
      final response = await rewardService.claimReward(rewardId);

      // ปิด loading dialog
      Navigator.of(context).pop();

      if (response['success'] == true) {
        // อัพเดทเครดิตใน UserProvider
        if (response['data'] != null && response['data']['credit'] != null) {
          final userProvider = Provider.of<UserProvider>(
            context,
            listen: false,
          );
          String creditString = response['data']['credit'].toString().trim();
          creditString = creditString.replaceAll(',', '');

          try {
            final creditDouble = double.parse(creditString);
            final newCredit = creditDouble.toInt();
            userProvider.setCredit(newCredit);

            await userProvider.loadCredit(); // รีโหลดเพื่อยืนยันค่า
          } catch (e) {
            print("Error parsing credit: $e");
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('นำส่งรางวัลสำเร็จ 🎉'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // reload purchases หลังจากเคลมเสร็จ
        setState(() {
          _purchasesFuture = _loadPurchases();
        });
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'ไม่สามารถนำส่งรางวัลได้'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      print("Error claiming reward: $e");
      if (mounted) {
        Navigator.of(context).pop(); // ปิด loading dialog ถ้ายังแสดงอยู่
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'เกิดข้อผิดพลาดในการนำส่งรางวัล กรุณาลองใหม่อีกครั้ง',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Helper functions
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final day = date.day.toString().padLeft(2, '0');
      final monthNames = [
        'มกราคม',
        'กุมภาพันธ์',
        'มีนาคม',
        'เมษายน',
        'พฤษภาคม',
        'มิถุนายน',
        'กรกฎาคม',
        'สิงหาคม',
        'กันยายน',
        'ตุลาคม',
        'พฤศจิกายน',
        'ธันวาคม',
      ];
      final month = monthNames[date.month - 1];
      final year = (date.year + 543).toString(); // แปลงเป็นปี พ.ศ.
      final hour = date.hour.toString().padLeft(2, '0');
      final minute = date.minute.toString().padLeft(2, '0');
      return '$day $month $year เวลา $hour:$minute';
    } catch (e) {
      return "รูปแบบวันที่ไม่ถูกต้อง";
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

          // ใส่ print ตรงนี้เพื่อตรวจสอบข้อมูล
          print(purchases);

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
                    "amount": lotInfo["lot_amount"] ?? 1,
                    "prize": purchase["prize"] ?? "-",
                  },
                ],
                onClaim: () {
                  // กด claim แล้วรีโหลดข้อมูลทั้งหน้า
                  _claimReward(purchase["rewardId"] ?? 0, context).then((_) {
                    // รีโหลดข้อมูลหลังจาก claim สำเร็จ
                    setState(() {
                      _purchasesFuture = _loadPurchases();
                    });
                  });
                },
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
                          'จำนวน: ${lotInfo["lot_amount"] ?? 1} ใบ',
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

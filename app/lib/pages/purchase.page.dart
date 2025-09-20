import 'package:app/components/StatusTags.dart';
import 'package:flutter/material.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Dialogue.dart';
import 'package:app/service/purchase/get.dart';

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
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    final lotInfo =
                        purchase['lot_info'] as Map<String, dynamic>? ?? {};
                    showCustomStatusTagsDialog(
                      context,
                      StatusTags(
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
                      ),
                    );
                  },
                  child: StatusTags(
                    period: purchase["created"] ?? "",
                    status: purchase["status"] ?? "pending",
                    rewards: [
                      {
                        "number":
                            (purchase['lot_info'] as Map<String, dynamic>? ??
                                {})['lottery_number'] ??
                            "-",
                        "type": purchase["status"] ?? "pending",
                        "amount": purchase["amount"] ?? 1,
                        "prize": purchase["prize"] ?? "-",
                      },
                    ],
                    backgroundColor: Colors.white,
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

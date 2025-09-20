import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/components/statusLottery.dart'; // ✅ import component
import 'package:app/components/MainLayout.dart';

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
    // จำลอง response ที่ได้จาก /purchase/me
    const mockResponse = '''
    {
      "data": {
        "purchases": [
          {
            "status": "pending",
            "created": "2025-09-10 14:30",
            "lot_info": { "lid": 5, "lottery_number": "594614" }
          },
          {
            "status": "pending",
            "created": "2025-09-11 09:45",
            "lot_info": { "lid": 7, "lottery_number": "710441" }
          },
          {
            "status": "pending",
            "created": "2025-09-12 18:20",
            "lot_info": { "lid": 12, "lottery_number": "935464" }
          }
        ],
        "total": 3
      }
    }
    ''';

    final response = json.decode(mockResponse);
    final purchases = response['data']['purchases'] as List;

    return purchases.map((p) {
      return {
        "number": p['lot_info']['lottery_number'],
        "type": p['status'], // pending, success, fail
        "amount": 1, // สมมติซื้อ 1 ใบ
        "prize": "-", // ยังไม่ประกาศผล
        "created": p['created'], // ✅ เวลา
      };
    }).toList();
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

          // ✅ แสดง 1 การ์ด ต่อ 1 เลข
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: purchases.length,
            itemBuilder: (context, index) {
              final purchase = purchases[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: StatusLottery(
                  period: purchase["created"], // ✅ ใช้เวลาที่ซื้อแทน "งวด"
                  status: purchase["type"],
                  rewards: [
                    {
                      "number": purchase["number"],
                      "type": purchase["type"],
                      "amount": purchase["amount"],
                      "prize": purchase["prize"],
                    },
                  ],
                  backgroundColor: Colors.white,
                  statusColor: Colors.yellow,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

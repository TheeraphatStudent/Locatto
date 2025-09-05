import 'dart:developer';

import 'package:app/components/Input.dart';
import 'package:app/components/MainLayout.dart';
import 'package:flutter/material.dart';

class LotteryPage extends StatelessWidget {
  const LotteryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          Input(
            labelText: "ค้นหาเลขเด็ด",
            variant: InputVariant.active,
            suffixIcon: Icons.search,
            showActionsBadge: true,
            actionsBadgeCount: 1,
            actionsBadgeIcon: Icons.shopping_cart,
            onActionsBadgePressed: () {
              log("Cart opened!");
            },
          ),
          Input(labelText: "Hello world"),
        ],
      ),
    );
  }
}

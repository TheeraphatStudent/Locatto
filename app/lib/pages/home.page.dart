import 'dart:developer';

import 'package:app/components/MainLayout.dart';
import 'package:app/components/RewardCard.dart';
import 'package:app/service/reward/get.dart';
import 'package:app/style/theme.dart';
import 'package:app/utils/text_healper.dart';
import 'package:app/utils/tier_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RewardService _rewardService = RewardService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _rewards = [];

  @override
  void initState() {
    super.initState();
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    try {
      final rewards = await _rewardService.getAll();

      // log("Get all reward work! -> ${rewards.toString()}");

      final sortedRewards =
          rewards.map((item) => item as Map<String, dynamic>).toList()
            ..sort((a, b) {
              final tierA = a['tier'] as String?;
              final tierB = b['tier'] as String?;

              final indexA = tierA != null
                  ? TierHelper.getTierIndex(tierA) ?? 999
                  : 999;
              final indexB = tierB != null
                  ? TierHelper.getTierIndex(tierB) ?? 999
                  : 999;

              return indexA.compareTo(indexB);
            });

      if (mounted) {
        setState(() {
          _rewards = sortedRewards;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MainLayout(body: const Center(child: CircularProgressIndicator()));
    }

    if (_rewards.every((reward) => reward['winner'] == null)) {
      return MainLayout(body: const Center(child: Text('รางวัลยังไม่ออก')));
    }

    final firstPrize = _rewards.first;
    final otherRewards = _rewards.skip(1).toList();

    return MainLayout(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              child: RewardCard(
                color: AppColors.primary,
                isFirstPrize: true,
                props: RewardProps(
                  lotNumber: firstPrize['winner']?.toString() ?? 'Unknown',
                  rewardTier: formattedRewardTier(
                    firstPrize['tier'] ?? 'Unknown',
                  ),
                  rewardRevenue: firstPrize['revenue'].toString(),
                ),
              ),
            ),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: otherRewards.map((reward) {
                  return RewardCard(
                    color: AppColors.secondaryLight,
                    props: RewardProps(
                      lotNumber: reward['winner'].toString(),
                      rewardTier: formattedRewardTier(
                        reward['tier'] ?? 'Unknown',
                      ),
                      rewardRevenue: reward['revenue'].toString(),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formattedRewardTier(String tier) {
    return "รางวัลที่ ${TierHelper.getTierDisplayNumber(tier)}";
  }
}

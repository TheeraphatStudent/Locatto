import 'dart:developer';

import 'package:app/components/Button.dart';
import 'package:flutter/material.dart';
import 'package:app/service/reward/get.dart';
import 'package:app/style/theme.dart';
import 'package:app/components/Input.dart';

class RandomLotto extends StatefulWidget {
  const RandomLotto({super.key});

  @override
  _RandomLottoState createState() => _RandomLottoState();
}

class _RandomLottoState extends State<RandomLotto> {
  Map<String, String> rewards = {
    'รางวัลที่ 1': '-',
    'รางวัลที่ 2': '-',
    'รางวัลที่ 3': '-',
    'เลขท้าย 3 ตัว': '-',
    'เลขท้าย 2 ตัว': '-',
  };

  final Map<String, TextEditingController> _rewardControllers = {
    'รางวัลที่ 1': TextEditingController(),
    'รางวัลที่ 2': TextEditingController(),
    'รางวัลที่ 3': TextEditingController(),
    'เลขท้าย 3 ตัว': TextEditingController(),
    'เลขท้าย 2 ตัว': TextEditingController(),
  };

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchRewards();
  }

  /// โหลดรางวัลปัจจุบัน
  Future<void> fetchRewards() async {
    try {
      final rewardService = RewardService();
      final rewardsData = await rewardService.getAll(); // คืนเป็น List<dynamic>

      updateRewards(rewardsData);
    } catch (e) {
      log('Error fetching rewards: $e');
    }
  }

  /// ฟังก์ชันที่ใช้ทั้งตอนสุ่มและตอนโหลดปกติ
  void updateRewards(List<dynamic> rewardsData) {
    setState(() {
      rewards = {
        'รางวัลที่ 1':
            rewardsData.firstWhere(
              (r) => r['tier'] == 'T1',
              orElse: () => {'winner': '-'},
            )['winner'] ??
            '-',
        'รางวัลที่ 2':
            rewardsData.firstWhere(
              (r) => r['tier'] == 'T2',
              orElse: () => {'winner': '-'},
            )['winner'] ??
            '-',
        'รางวัลที่ 3':
            rewardsData.firstWhere(
              (r) => r['tier'] == 'T3',
              orElse: () => {'winner': '-'},
            )['winner'] ??
            '-',
        'เลขท้าย 3 ตัว':
            rewardsData.firstWhere(
              (r) => r['tier'] == 'T1L3',
              orElse: () => {'winner': '-'},
            )['winner'] ??
            '-',
        'เลขท้าย 2 ตัว':
            rewardsData.firstWhere(
              (r) => r['tier'] == 'R2',
              orElse: () => {'winner': '-'},
            )['winner'] ??
            '-',
      };

      // Update controllers with new values
      _rewardControllers.forEach((key, controller) {
        controller.text = rewards[key] ?? '-';
      });

      log('setState called with rewards: $rewards');
    });
  }

  /// ใช้ตอนกดปุ่มสุ่ม / ตามเลขที่ถูกขาย
  Future<void> fetchRandomReward({required bool followed}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final rewardService = RewardService();
      final response = followed
          ? await rewardService.getRandomRewardFollowed()
          : await rewardService.getRandomRewardUnfollowed();

      log(
        followed
            ? 'Random Reward Followed: $response'
            : 'Random Reward Unfollowed: $response',
      );

      // response['data'] เป็น List<dynamic>
      fetchRewards();
    } catch (e) {
      log('Error fetching random reward: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // หัวตาราง
            Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'ประเภทรางวัล',
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
                    'เลขรางวัล',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // รายการรางวัล
            Column(
              children: rewards.entries
                  .map((entry) => _buildRewardRow(entry.key, entry.value))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // ปุ่ม
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ButtonActions(
                    text: "สุ่มรางวัลทันที",
                    variant: ButtonVariant.primary,
                    onPressed: _isLoading
                        ? null
                        : () => fetchRandomReward(followed: false),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ButtonActions(
                    text: "ตามเลขที่ถูกขาย",
                    variant: ButtonVariant.primary,
                    theme: AppColors.secondary,
                    onPressed: _isLoading
                        ? null
                        : () => fetchRandomReward(followed: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardRow(String rewardType, String rewardNumber) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              rewardType,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
          Expanded(
            flex: 3,
            child: Input(
              controller: _rewardControllers[rewardType],
              onChanged: (value) {
                setState(() {
                  rewards[rewardType] = value.isEmpty ? '-' : value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

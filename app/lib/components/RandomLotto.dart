import 'package:flutter/material.dart';
import 'package:app/service/reward/get.dart';

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
      print('Error fetching rewards: $e');
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
      print('setState called with rewards: $rewards');
    });
  }

  /// ใช้ตอนกดปุ่มสุ่ม / ตามเลขที่ถูกขาย
  Future<void> fetchRandomReward({required bool followed}) async {
    try {
      final rewardService = RewardService();
      final response = followed
          ? await rewardService.getRandomRewardFollowed()
          : await rewardService.getRandomRewardUnfollowed();

      print(
        followed
            ? 'Random Reward Followed: $response'
            : 'Random Reward Unfollowed: $response',
      );

      // response['data'] เป็น List<dynamic>
      fetchRewards();
    } catch (e) {
      print('Error fetching random reward: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      constraints: const BoxConstraints(maxHeight: 400),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              ElevatedButton(
                onPressed: () => fetchRandomReward(followed: false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: const Text(
                  'สุ่มรางวัลทันที',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              ElevatedButton(
                onPressed: () => fetchRandomReward(followed: true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                ),
                child: const Text(
                  'ตามเลขที่ถูกขาย',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
              ),
            ],
          ),
        ],
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
            child: Container(
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rewardNumber,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

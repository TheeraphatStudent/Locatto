import 'package:app/components/MainLayout.dart';
import 'package:app/components/RewardCard.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  lotNumber: '888888',
                  rewardTier: 'รางวัลที่ 1',
                  rewardRevenue: '6000000',
                ),
              ),
            ),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  RewardCard(
                    color: AppColors.secondary,
                    props: RewardProps(
                      lotNumber: '888 888',
                      rewardTier: 'รางวัลที่ 2',
                      rewardRevenue: '200000',
                    ),
                  ),
                  RewardCard(
                    color: AppColors.secondary,
                    props: RewardProps(
                      lotNumber: '888 888',
                      rewardTier: 'รางวัลที่ 3',
                      rewardRevenue: '80000',
                    ),
                  ),
                  RewardCard(
                    color: AppColors.secondaryLight,
                    props: RewardProps(
                      lotNumber: '888',
                      rewardTier: 'เลขท้าย 3 ตัว',
                      rewardRevenue: '4000',
                    ),
                  ),
                  RewardCard(
                    color: AppColors.secondaryLight,
                    props: RewardProps(
                      lotNumber: '88',
                      rewardTier: 'เลขท้าย 2 ตัว',
                      rewardRevenue: '4000',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

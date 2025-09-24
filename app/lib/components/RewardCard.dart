import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';

class RewardProps {
  final String lotNumber;
  final String rewardTier;
  final String rewardRevenue;

  const RewardProps({
    required this.lotNumber,
    required this.rewardTier,
    required this.rewardRevenue,
  });
}

class RewardCard extends StatelessWidget {
  final RewardProps props;
  final Color color;
  final bool isFirstPrize;

  const RewardCard({
    super.key,
    required this.props,
    required this.color,
    this.isFirstPrize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isFirstPrize ? 20 : 16,
      ),
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            props.lotNumber,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: isFirstPrize ? 24 : 20,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isFirstPrize ? 12 : 8),
          Text(
            props.rewardTier,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: isFirstPrize ? 14 : 12,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'รางวัลละ ${props.rewardRevenue} บาท',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: isFirstPrize ? 14 : 12,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

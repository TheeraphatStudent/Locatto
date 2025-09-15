import 'package:flutter/material.dart';

class LotteryData {
  final String lottery;
  final String reward;

  LotteryData({required this.lottery, required this.reward});
}

class LotteryList extends StatelessWidget {
  final List<LotteryData> lotteryList;

  const LotteryList({super.key, required this.lotteryList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: ShapeDecoration(
            color: const Color(0xFFFFF7F7),
            /* Lottocat-White */
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              _buildHeaderRow(),

              // Data rows
              ...lotteryList.asMap().entries.map((entry) {
                int index = entry.key + 1;
                LotteryData data = entry.value;
                return _buildDataRow(
                  index.toString(),
                  data.lottery,
                  data.reward,
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              'รหัส',
              style: TextStyle(
                color: const Color(0xFF45171D),
                /* Lottocat-Black */
                fontSize: 8,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'เลขรางวัล',
              style: TextStyle(
                color: const Color(0xFF45171D),
                /* Lottocat-Black */
                fontSize: 8,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 97,
            child: Text(
              'ประเภทรางวัล',
              style: TextStyle(
                color: const Color(0xFF45171D),
                /* Lottocat-Black */
                fontSize: 8,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String index, String lottery, String reward) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 30,
            child: Text(
              index,
              style: TextStyle(
                color: const Color(0xFFFD5553),
                /* Lottocat-Primary */
                fontSize: 8,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              lottery,
              style: TextStyle(
                color: const Color(0xFFFD5553),
                /* Lottocat-Primary */
                fontSize: 8,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 97,
            child: Text(
              reward,
              style: TextStyle(
                color: const Color(0xFFFD5553),
                /* Lottocat-Primary */
                fontSize: 8,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

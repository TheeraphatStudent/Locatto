import 'package:flutter/material.dart';

class LotteryData {
  final String lottery;
  // final String reward;

  LotteryData({required this.lottery});
}

class LotteryList extends StatelessWidget {
  final List<LotteryData> lotteryList;
  final ScrollController scrollController;

  const LotteryList({
    super.key,
    required this.lotteryList,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: ShapeDecoration(
        color: const Color(0xFFFFF7F7),
        /* Lottocat-White */
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: lotteryList.length,
              controller: scrollController,
              itemBuilder: (context, index) {
                return _buildDataRow(
                  (index + 1).toString(),
                  lotteryList[index].lottery,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              'รหัส',
              style: TextStyle(
                color: const Color(0xFF45171D),
                /* Lottocat-Black */
                fontSize: 28,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Text(
              'เลขรางวัล',
              style: TextStyle(
                color: const Color(0xFF45171D),
                /* Lottocat-Black */
                fontSize: 28,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String index, String lottery) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            child: Text(
              index,
              style: TextStyle(
                color: const Color(0xFFFD5553),
                /* Lottocat-Primary */
                fontSize: 18,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Text(
              lottery,
              style: TextStyle(
                color: const Color(0xFFFD5553),
                /* Lottocat-Primary */
                fontSize: 18,
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

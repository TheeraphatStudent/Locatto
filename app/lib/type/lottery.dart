class LotteryModel {
  final int? lid;
  final String lotteryNumber;

  LotteryModel({this.lid, required this.lotteryNumber});

  factory LotteryModel.fromJson(Map<String, dynamic> json) {
    return LotteryModel(
      lid: json['lid'] != null ? json['lid'] as int : null,
      lotteryNumber: json['lottery_number'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lid': lid, 'lottery_number': lotteryNumber};
  }
}

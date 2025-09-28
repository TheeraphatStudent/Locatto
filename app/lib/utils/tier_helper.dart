class TierHelper {
  static const List<String> prizeTypes = [
    "รางวัลที่ 1", // T1
    "รางวัลที่ 2", // T2
    "รางวัลที่ 3", // T3
    "เลขท้าย 3 ตัว", // T1L3
    "เลขท้าย 2 ตัว", // R2
  ];

  static const Map<String, int> tierMapping = {
    'T1': 0, // รางวัลที่ 1
    'T2': 1, // รางวัลที่ 2
    'T3': 2, // รางวัลที่ 3
    'T1L3': 3, // เลขท้าย 3 ตัว
    'R2': 4, // เลขท้าย 2 ตัว
  };

  static String getTierDisplayNumber(String tier) {
    final index = tierMapping[tier];
    if (index != null) {
      return (index + 1).toString();
    }
    return tier;
  }

  static String getPrizeTypeName(String tier) {
    final index = tierMapping[tier];
    if (index != null && index < prizeTypes.length) {
      return prizeTypes[index];
    }
    return tier;
  }

  static int? getTierIndex(String tier) {
    return tierMapping[tier];
  }
}
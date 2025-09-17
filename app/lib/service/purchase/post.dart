import '../transport.dart';

class PurchasePost {
  final Transport _transport = Transport();

  Future<Map<String, dynamic>> createPurchase({
    required int uid,
    required int lid,
    required int lotAmount,
    required int payid,
  }) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/purchase',
        {
          'uid': uid,
          'lid': lid,
          'lot_amount': lotAmount,
          'payid': payid,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Purchase creation failed: $e');
    }
  }
}
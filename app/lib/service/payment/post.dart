import '../transport.dart';

class PaymentPost {
  final Transport _transport = Transport();

  Future<Map<String, dynamic>> createPayment({
    required int uid,
    required String provider,
    required double revenue,
  }) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/payment',
        {
          'uid': uid,
          'provider': provider,
          'revenue': revenue,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Payment creation failed: $e');
    }
  }
}
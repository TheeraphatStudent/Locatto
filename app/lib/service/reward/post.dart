import 'package:app/service/transport.dart';

class RewardService {
  final Transport _transport = Transport();

  Future<Map<String, dynamic>> manageRewards(
    Map<String, dynamic> prizeData,
  ) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/reward/manage',
        prizeData,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to manage rewards: $e');
    }
  }
}

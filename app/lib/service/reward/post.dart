import 'package:app/service/transport.dart';
import 'package:app/utils/response_helper.dart';

class RewardService {
  final Transport _transport = Transport();
  final ResponseHelper _responseHelper = ResponseHelper();

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

  Future<Map<String, dynamic>> claimReward(int rewardId) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/reward/claim',
        {'rid': rewardId},
      );

      return response;
    } catch (e) {
      return {'success': false};
    }
  }
}

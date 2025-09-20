import 'package:app/service/transport.dart';
import 'package:app/utils/response_helper.dart';

class RewardService {
  final Transport _transport = Transport();
  final ResponseHelper _responseHelper = ResponseHelper();

  Future<Map<String, dynamic>> getRandomRewardFollowed() async {
    final response = await _transport.requestTransport(
      RequestMethod.get,
      '/lottery/random/reward/followed',
      {},
    );

    if (_responseHelper.isSuccess(response['statusCode'] as int)) {
      return response['data'];
    } else {
      throw Exception('Failed to get random reward followed');
    }
  }

  Future<Map<String, dynamic>> getRandomRewardUnfollowed() async {
    final response = await _transport.requestTransport(
      RequestMethod.get,
      '/lottery/random/reward/unfollowed',
      {},
    );

    if (_responseHelper.isSuccess(response['statusCode'] as int)) {
      return response['data'];
    } else {
      throw Exception('Failed to get random reward unfollowed');
    }
  }

  Future<Map<String, dynamic>> getAllRewards() async {
    final response = await _transport.requestTransport(
      RequestMethod.get,
      '/reward',
      {},
    );

    if (_responseHelper.isSuccess(response['statusCode'] as int)) {
      return response['data'];
    } else {
      throw Exception('Failed to load rewards');
    }
  }
}

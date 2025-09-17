import 'dart:developer';

import 'package:app/service/transport.dart';
import 'package:app/utils/response_helper.dart';

class Lotteryget {
  final Transport _transport = Transport();

  final ResponseHelper _responseHelper = ResponseHelper();

  Future<Map<String, dynamic>> getLotteries(int page, int size) async {
    // log("Print lottery work!");

    final response = await _transport.requestTransport(
      RequestMethod.get,
      '/lottery?page=$page&size=$size',
      // /lottery?page=3&size=10
      {},
    );  

    // log(response.toString());

    if (_responseHelper.isSuccess(response['statusCode'] as int)) {
      return response['data'];
    } else {
      throw Exception('Failed to load lotteries');
    }
  }

  Future<Map<String, dynamic>> searchLotteries(
    String query,
    int page,
    int size,
  ) async {
    final response = await _transport.requestTransport(
      RequestMethod.post,
      '/lottery/search?page=$page&size=$size',
      {'search': query},
    );

    if (response['success'] == true) {
      return response;
    } else {
      throw Exception('Failed to search lotteries');
    }
  }
}

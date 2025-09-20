import 'package:app/service/transport.dart';

class LotteryService {
  final Transport _transport = Transport();

  Future<Map<String, dynamic>> generateLotteries(int count) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/lottery',
        {'n': count},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to generate lotteries: $e');
    }
  }

  Future<Map<String, dynamic>> getLotteries() async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.get,
        '/lottery',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to fetch lotteries: $e');
    }
  }

  Future<Map<String, dynamic>> createLottery(
    Map<String, dynamic> lotteryData,
  ) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/lottery',
        lotteryData,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create lottery: $e');
    }
  }

  Future<Map<String, dynamic>> updateLottery(
    int id,
    Map<String, dynamic> lotteryData,
  ) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.put,
        '/lottery/$id',
        lotteryData,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to update lottery: $e');
    }
  }

  Future<Map<String, dynamic>> deleteLottery(int id) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.delete,
        '/lottery/$id',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to delete lottery: $e');
    }
  }

  Future<Map<String, dynamic>> searchLottery(
    String query,
    int page,
    int size,
  ) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/lottery/search?page=$page&size=$size',
        {'search': query},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to search lotteries: $e');
    }
  }
}

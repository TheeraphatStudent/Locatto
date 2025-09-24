import 'dart:developer';

import 'package:app/service/transport.dart';
import 'package:app/utils/response_helper.dart';

class PurchaseService {
  final Transport _transport = Transport();
  final ResponseHelper _responseHelper = ResponseHelper();

  Future<Map<String, dynamic>> getByUserWithStatus(int page, int size) async {
    final response = await _transport.requestTransport(
      RequestMethod.get,
      // ใช้ endpoint ให้ตรงกับ backend route: /purchase/me
      '/purchase/me?page=$page&size=$size',
      {},
    );

    log("Transport response: $response");

    if (_responseHelper.isSuccess(response['statusCode'] as int)) {
      // Transport แปลง response เป็น object แล้ว ไม่ใช่ JWT string
      final body = response['data'] as Map<String, dynamic>;
      log("Response body: $body");

      // ข้อมูล purchases อยู่ใน body['purchases'] โดยตรง
      return {'purchases': body['purchases'] ?? []};
    } else {
      throw Exception('Failed to load purchases');
    }
  }
}

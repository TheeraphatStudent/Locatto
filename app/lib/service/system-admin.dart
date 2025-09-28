import 'dart:developer';

import 'package:app/config.dart';
import 'package:app/service/transport.dart';
import 'package:app/utils/response_helper.dart';

class SystemAdmin {
  final Transport _transport = Transport();

  Future<Map<String, dynamic>> resetSystem() async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/resys',
        {},
      );
      return {'success': true, 'message': response['message']};
    } catch (e) {
      log(e.toString());
      return {'success': false, 'message': e.toString()};
    }
  }
}

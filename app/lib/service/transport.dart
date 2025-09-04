import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jwt_lib;
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import '../config.dart';

class Transport {
  final AppConfig config = AppConfig();

  String encodePayload(Object body) {
    final jwt = jwt_lib.JWT(body);
    return jwt.sign(jwt_lib.SecretKey(config.getJwtSecret()));
  }

  Map<String, dynamic> decodePayload(String token) {
    final jwt = jwt_lib.JWT.verify(token, jwt_lib.SecretKey(config.getJwtSecret()));
    return jwt.payload as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> requestTransport(
    String endpoint,
    Object payload,
  ) async {
    final token = encodePayload(payload);
    final url = Uri.http(config.getBaseUrl(), endpoint);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: '{"data": "$token"}',
      );

      final responseData = json.jsonDecode(response.body);
      if (responseData.containsKey('data')) {
        return decodePayload(responseData['data']);
      }

      return responseData;
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

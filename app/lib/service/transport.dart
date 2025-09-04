import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jwt_lib;
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import '../config.dart';

class Transport {
  final AppConfig config = AppConfig();
  bool isSign;

  Transport({this.isSign = false});

  String encodePayload(Object body) {
    final jwt = jwt_lib.JWT(body);
    if (isSign) {
      return jwt.sign(jwt_lib.SecretKey(config.getJwtSecret()));
    }

    return jwt.toString();
  }

  Map<String, dynamic> decodePayload(String token) {
    if (isSign) {
      final jwt = jwt_lib.JWT.verify(
        token,
        jwt_lib.SecretKey(config.getJwtSecret()),
      );
      return jwt.payload as Map<String, dynamic>;
    } else {
      final jwt = jwt_lib.JWT.decode(token);
      return jwt.payload as Map<String, dynamic>;
    }
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

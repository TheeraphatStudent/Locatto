import 'dart:developer';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jwt_lib;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import '../config.dart';

enum RequestMethod { get, post, put, delete }

class Transport {
  final AppConfig config = AppConfig();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool isSign;

  Transport({this.isSign = false});

  String encodePayload(Object body) {
    final jwt = jwt_lib.JWT(body, issuer: 'flutter-app');

    if (isSign) {
      return jwt.sign(jwt_lib.SecretKey(config.getJwtSecret()));
    }

    return jwt.sign(jwt_lib.SecretKey(''));
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
    RequestMethod reqMethod,
    String endpoint,
    Object payload,
  ) async {
    final token = encodePayload(payload);

    Uri url;

    if (endpoint.contains('?')) {
      final parts = endpoint.split('?');
      final path = parts[0];
      final queryString = parts[1];
      final queryParams = Uri.splitQueryString(queryString);
      // url = Uri.https(config.getBaseUrl(), path, queryParams);
      url = Uri.http(config.getBaseUrl(), path, queryParams);
    } else {
      // url = Uri.https(config.getBaseUrl(), endpoint);
      url = Uri.http(config.getBaseUrl(), endpoint);
    }

    final accessToken = await _storage.read(key: config.getTokenStoragename());

    // log("Access token: $accessToken");
    log("Target: ${url.toString()}");

    try {
      final headers = <String, String>{};

      if (accessToken != null && accessToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $accessToken';
      }

      if (reqMethod != RequestMethod.get && reqMethod != RequestMethod.delete) {
        headers['Content-Type'] = 'application/json';
      }

      http.Response response;

      // log("Request headers: $headers");

      switch (reqMethod) {
        case RequestMethod.get:
          response = await http.get(url, headers: headers);
          break;
        case RequestMethod.post:
          response = await http.post(
            url,
            headers: headers,
            body: '{"data": "$token"}',
          );
          break;
        case RequestMethod.put:
          response = await http.put(
            url,
            headers: headers,
            body: '{"data": "$token"}',
          );
          break;
        case RequestMethod.delete:
          response = await http.delete(url, headers: headers);
          break;
      }

      log("Actual response: ${response.body}");

      if (response.headers['content-type']?.contains('text/html') == true) {
        throw Exception(
          'Server returned HTML error page. Status: ${response.statusCode}',
        );
      }

      final responseData = json.jsonDecode(response.body);
      Map<String, dynamic> payloadData;
      if (responseData.containsKey('data')) {
        // log(responseData.toString());
        payloadData = decodePayload(responseData['data']);
      } else {
        payloadData = responseData as Map<String, dynamic>;
      }

      return {...payloadData, 'statusCode': response.statusCode};
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

import 'dart:developer';

import 'package:app/utils/response_helper.dart';

import '../config.dart';
import '../type/login.dart';
import '../type/register.dart';
import '../type/reset_password.dart';
import './transport.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth {
  final Transport _transport = Transport();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppConfig config = AppConfig();

  final ResponseHelper _responseHelper = ResponseHelper();

  Future<Map<String, dynamic>> login(Login loginData) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/auth/login',
        loginData.toJson(),
      );

      log("Login response: ${response.toString()}");

      final data = response['data'];
      final user = data['user'];

      if (data['success']) {
        await _storage.write(
          key: config.getTokenStoragename(),
          value: data['token'],
        );

        if (user['uid'] != null) {
          await _storage.write(
            key: config.getUserIdStorage(),
            value: user['uid'].toString(),
          );
        }
      }
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> register(Register registerData) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/auth/register',
        registerData.toJson(),
      );
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<Map<String, dynamic>> resetPassword(ResetPassowrd resetData) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/auth/repass',
        resetData.toJson(),
      );
      return response;
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/auth/logout',
        {},
      );
      if ((response['statusCode'] as int?) == 200) {
        await _storage.delete(key: 'LottocatToken');
      }
      return response;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.get,
        '/auth/me',
        {},
      );
      return response;
    } catch (e) {
      throw Exception('User info failed: $e');
    }
  }

  Future<Map<String, dynamic>> checkAuth() async {
    try {
      final response = await getMe();

      log(response.toString());

      return {
        'isValid': _responseHelper.isSuccess(response['statusCode'] as int),
        'role': response['data']['user']['role'],
        'credit': double.parse(response['data']['user']['credit'].toString()).toInt(),
      };
    } catch (e) {
      return {'isValid': false, 'role': null, 'credit': 0};
    }
  }
}

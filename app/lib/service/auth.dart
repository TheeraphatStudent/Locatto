import 'dart:developer';

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

  Future<Map<String, dynamic>> login(Login loginData) async {
    try {
      final response = await _transport.requestTransport(
        RequestMethod.post,
        '/auth/login',
        loginData.toJson(),
      );
      if ((response['statusCode'] as int?) == 200 &&
          response['token'] != null) {
        await _storage.write(
          key: config.getTokenStoragename(),
          value: response['token'],
        );

        // Store uid if available in response
        if (response['uid'] != null) {
          await _storage.write(
            key: config.getUserIdStorage(),
            value: response['uid'].toString(),
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

  Future<bool> checkAuth() async {
    try {
      final response = await getMe();

      log(response.toString());

      return response['statusCode'] == 200;
    } catch (e) {
      return false;
    }
  }
}

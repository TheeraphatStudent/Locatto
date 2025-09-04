import 'package:http/http.dart' as http;
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
      final response = await _transport.requestTransport('/auth/login', loginData.toJson());
      if (response['success'] == true && response['token'] != null) {
        await _storage.write(key: config.getTokenStoragename(), value: response['token']);
      }
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> register(Register registerData) async {
    try {
      final response = await _transport.requestTransport('/auth/register', registerData.toJson());
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<Map<String, dynamic>> resetPassword(ResetPassowrd resetData) async {
    try {
      final response = await _transport.requestTransport('/auth/repass', resetData.toJson());
      return response;
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _transport.requestTransport('/auth/logout', {});
      if (response['success'] == true) {
        await _storage.delete(key: 'LottocatToken');
      }
      return response;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
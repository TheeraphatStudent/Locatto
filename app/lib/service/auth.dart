import 'package:http/http.dart' as http;
import '../config.dart';
import '../type/login.dart';
import '../type/register.dart';
import '../type/reset_password.dart';
import './transport.dart';

class Auth {
  final Transport _transport = Transport();

  Future<Map<String, dynamic>> login(Login loginData) async {
    try {
      final response = await _transport.requestTransport('/auth/login', loginData.toJson());
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
}
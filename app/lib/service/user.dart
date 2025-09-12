import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const String _creditKey = 'user_credit';
  static const String _userDataKey = 'user_data';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> storeUserCredit(String credit) async {
    await _storage.write(key: _creditKey, value: credit);
  }

  Future<String?> getUserCredit() async {
    return await _storage.read(key: _creditKey);
  }

  Future<void> storeUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: _userDataKey, value: userData.toString());
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await _storage.read(key: _userDataKey);
    if (userDataString != null) {
      return {'data': userDataString};
    }
    return null;
  }

  Future<String?> getUserRole() async {
    try {
      final userDataString = await _storage.read(key: _userDataKey);
      if (userDataString != null && userDataString.isNotEmpty) {
        try {
          if (userDataString.contains('admin')) {
            return 'admin';
          }
        } catch (e) {
          if (userDataString.contains('admin')) {
            return 'admin';
          }
        }
      }

      return 'user';
    } catch (e) {
      return 'user';
    }
  }

  Future<void> clearUserData() async {
    await _storage.delete(key: _creditKey);
    await _storage.delete(key: _userDataKey);
  }
}

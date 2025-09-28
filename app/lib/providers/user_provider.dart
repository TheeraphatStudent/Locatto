import 'dart:developer';

import 'package:flutter/material.dart';
import '../service/user.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();
  int _credit = 0;

  int get credit => _credit;

  Future<void> loadCredit() async {
    log("Load credit work!");

    _credit = await _userService.getUserCredit();
    notifyListeners();
  }

  void setCredit(int credit) {
    _credit = credit;

    _userService.storeUserCredit(credit.toString());
    notifyListeners();
  }

  void updateCredit(int newCredit) {
    _credit = newCredit;

    notifyListeners();
  }
}

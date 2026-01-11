import 'package:flutter/foundation.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userType = 'patient'; // 'patient' or 'hospital'
  String _userName = '';
  
  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;
  String get userName => _userName;

  void login(String name, String type) {
    _isLoggedIn = true;
    _userName = name;
    _userType = type;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userType = 'patient';
    notifyListeners();
  }
}

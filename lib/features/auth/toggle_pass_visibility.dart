import 'package:flutter/material.dart';

class TogglePasswordVisibility extends ChangeNotifier {
  bool _hasFocus = false;
  bool get hasFocus => _hasFocus;
  
  bool _isLoginPasswordVisible = false;
  bool get showPasswordLogin => _isLoginPasswordVisible;

  bool _isSignUpPasswordVisible = false;
  bool get showPasswordRegister => _isSignUpPasswordVisible;

  void togglePasswordLogin() {
    _isLoginPasswordVisible = !_isLoginPasswordVisible;
    notifyListeners();
  }

  void togglePasswordRegister() {
    _isSignUpPasswordVisible = !_isSignUpPasswordVisible;
    notifyListeners();
  }
}

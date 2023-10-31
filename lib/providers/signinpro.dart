
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPro with ChangeNotifier {
  bool obscure = true;

  notifyListenerz() {
    notifyListeners();
  }

  void clearAll() {
    obscure = true;
    notifyListeners();
  }
}

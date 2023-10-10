import 'dart:async';

import 'package:flutter/material.dart';

class HomePro with ChangeNotifier {
  Timer? timer;
  late int userid;
  late String username;
  late String token;
  static String notificationpayload = "";
  int shiftid = -1;
  int vehicleid = -1;
  DateTime? shiftfrom;
  DateTime? shiftto;
  notifyListenerz() {
    notifyListeners();
  }

  clearAll() {
    notificationpayload = "";
    shiftid = -1;
    vehicleid = -1;
    shiftfrom = null;
    shiftto = null;
  }
}

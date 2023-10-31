import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Entities/jobsobject.dart';

class CompletedJobsPro with ChangeNotifier {
  int matcheditems=0;
  var filterdate;
  bool isloaded = false;
  List<JobObject> jobs = [];
  void clearAll() {
    isloaded = false;
    jobs = [];
    notifyListeners();
  }

  notifyListenerz() {
    notifyListeners();
  }
}

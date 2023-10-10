import 'package:flutter/material.dart';

import '../Entities/vehicles.dart';

class StartShiftPro with ChangeNotifier {
  bool isloaded=false;
  // Vehicle? vehicle_in_shift;
  List<Vehicle> vehicles=[];
  int selectedvehicleid=-1;
  notifyListenerz(){
    notifyListeners();
  }
  clearAll(){
    vehicles=[];
    selectedvehicleid=-1;
    isloaded=false;
  }
}
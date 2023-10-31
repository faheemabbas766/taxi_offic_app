import 'package:flutter/material.dart';

import '../Api & Routes/routes.dart';

class BottomNavigationPro with ChangeNotifier {
  int navindex = 0;
  // Icon homeicon = Icon(Icons.home_outlined, color: Colors.blue,size:RouteManager.width/11);
  // Icon profileicon = Icon(Icons.person_outline_outlined, color: Colors.blue,size:RouteManager.width/11);
  Icon currentjobicon = Icon(Icons.work, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
  Icon pendingjobicon = Icon(Icons.info, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
  Icon completedjobicon = Icon(Icons.check, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
  // Icon pendingjobicon = Icon(Icons.person_outline_outlined, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
  notifyListenerz() {
    notifyListeners();
  }

  clearAll(){
    navindex = 0;
    currentjobicon = Icon(Icons.work, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
    pendingjobicon = Icon(Icons.info, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
    completedjobicon = Icon(Icons.check, color: const Color.fromARGB(255, 201, 201, 201), size: RouteManager.width / 15);
  }
}

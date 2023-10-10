import 'package:flutter/material.dart';
import 'package:taxi_app/Pages/signin.dart';
import 'package:taxi_app/bottom/bottomnavigation.dart';
import 'package:taxi_app/pages/add_booking.dart';
import 'package:taxi_app/pages/home.dart';
import 'package:taxi_app/pages/jobview.dart';
import 'package:taxi_app/pages/tripdetails.dart';

import '../pages/pobmap.dart';
import '../pages/splashscreen.dart';
import '../pages/startshift.dart';
import '../pages/tripdetails.dart';

class RouteManager {
  static Color appclr = const Color.fromARGB(255, 240, 240, 240);
  static BuildContext? context;
  static var width;
  static var height;
  static String? deviceid;
  static const String rootpage = "/";
  static const String signinpage = "/signin";
  static const String bottomPage = "/bottomPage";
  static const String homepage = "/homepage";
  static const String jobviewpage = "/jobviewpage";
  static const String startshiftpage = "/startshift";
  static const String tripdetailspage = "/tripdetails";
  static const String pobmappage = "/pobmappage";
  static const String addBooking = "/add_booking";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signinpage:
        return MaterialPageRoute(builder: (context) => SignIn());
      case rootpage:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case bottomPage:
        return MaterialPageRoute(builder: (context) => BottomBar());
      case homepage:
        return MaterialPageRoute(builder: (context) => Home());
      case jobviewpage:
        return MaterialPageRoute(builder: (context) => JobView());
      case startshiftpage:
        return MaterialPageRoute(builder: (context) => StartShift());
      case tripdetailspage:
        return MaterialPageRoute(builder: (context) => TripDetails());
      case pobmappage:
        return MaterialPageRoute(builder: (context) => PobMap());
        case addBooking:
      return MaterialPageRoute(builder: (context) => AddBookingScreen());
      default:
        throw const FormatException("Route no Found!");
    }
  }
}

import 'package:flutter/material.dart';
import 'package:taxi_app/Pages/signin.dart';
import 'package:taxi_app/bottom/bottomnavigation.dart';
import 'package:taxi_app/pages/add_booking.dart';
import 'package:taxi_app/pages/home.dart';
import 'package:taxi_app/pages/jobview.dart';
import 'package:taxi_app/pages/tripdetails.dart';

import '../pages/live_status.dart';
import '../pages/pobmap.dart';
import '../pages/splashscreen.dart';
import '../pages/startshift.dart';

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
  static const String liveStatus = "/live_status";
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signinpage:
        return MaterialPageRoute(builder: (context) => SignIn());
      case rootpage:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      case bottomPage:
        return MaterialPageRoute(builder: (context) => const BottomBar());
      case homepage:
        return MaterialPageRoute(builder: (context) => const Home());
      case jobviewpage:
        return MaterialPageRoute(builder: (context) => const JobView());
      case startshiftpage:
        return MaterialPageRoute(builder: (context) => const StartShift());
      case tripdetailspage:
        return MaterialPageRoute(builder: (context) => const TripDetails());
      case pobmappage:
        return MaterialPageRoute(builder: (context) => const PobMap());
      case addBooking:
        return MaterialPageRoute(builder: (context) => const AddBookingScreen());
      case liveStatus:
        return MaterialPageRoute(builder: (context) => const ShowDialogScreen());
      default:
        throw const FormatException("Route no Found!");
    }
  }
}

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/providers/homepro.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navvalue = true;
  @override
  Widget build(BuildContext context) {
    RouteManager.width = MediaQuery.of(context).size.width;
    RouteManager.height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Stack(
        children: [
          AnimatedSplashScreen.withScreenRouteFunction(
            screenRouteFunction: () async {
              while (true) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getString('username') != null && prefs.getString('userid') != null
                    && prefs.getString('token') != null) {
                  Provider.of<HomePro>(context, listen: false).userid =
                      int.parse(prefs.getString('userid').toString());
                  Provider.of<HomePro>(context, listen: false).username =
                      prefs.getString('username').toString();
                  Provider.of<HomePro>(context, listen: false).token =
                      prefs.getString('token').toString();
                  while (true) {
                    var val = await API.getShift(
                        Provider.of<HomePro>(context, listen: false).userid,
                        context);
                    if (val) {
                      if (Provider.of<HomePro>(context, listen: false)
                              .shiftid !=
                          -1) {
                        API.postlocation = true;
                      }

                      break;
                    }
                  }
                  // RouteManager.isbottomnavigation = true;
                  return Future.value("/bottomPage");
                }
                navvalue = true;
                return Future.value("/signin");
              }
            },
            disableNavigation: navvalue,
            // splashTransition: SplashTransition.slideTransition,
            splash: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                "assets/splash.jpg",
                fit: BoxFit.cover,
              ),
            ),
            curve: Curves.easeInOutCubic,
            splashIconSize: MediaQuery.of(context).size.width *
                    MediaQuery.of(context).size.height +
                1000,
            centered: true,
            animationDuration: const Duration(seconds: 2),
          ),
        ],
      ),
    );
  }
}

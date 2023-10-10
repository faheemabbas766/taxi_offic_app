import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/pages/home.dart';
import 'package:taxi_app/providers/bottomnavpro.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:taxi_app/providers/pendingjobspro.dart';
import 'package:taxi_app/providers/startshiftpro.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Api & Routes/api.dart';
import 'Api & Routes/routes.dart';
import 'firebase_options.dart';
import 'genericnotifications.dart';
import 'providers/completedjobspro.dart';
import 'providers/currentjobspro.dart';
import 'providers/pobmappro.dart';
import 'providers/signinpro.dart';
import 'providers/tripdetailspro.dart';
import 'package:intl/intl.dart';
String token = '';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (message.data.toString() == "{title: Admin Ended ur shift}") {
    GenericNotifications.showNotification(
      id: 1,
      title: "Shift Ended",
      body: "Your Shift has been Ended by the Admin",
      payload: "0",
    );
    return;
  }
  Map<String, dynamic> map = {};
  print("?????????????????????????????????????????????????${message.data}");
  map["CUS_NAME"] =
      jsonDecode(message.data['Customer_Detail'])["CUS_NAME"].toString();
  map["CUS_PHONE"] =
      jsonDecode(message.data['Customer_Detail'])["CUS_PHONE"].toString();
  map["BM_DATE"] =
      jsonDecode(message.data['booking_detail'])["BM_DATE"].toString();
  map["BM_PASSENGER"] =
      jsonDecode(message.data['booking_detail'])["BM_PASSENGER"].toString();
  map["BM_LAGGAGE"] =
      jsonDecode(message.data['booking_detail'])["BM_M_LUGGAE"].toString();
  map["BM_PAY_METHOD"] =
      jsonDecode(message.data['booking_detail'])["BM_PAY_METHOD"].toString();
  map["total_amount"] =
      jsonDecode(message.data['booking_detail'])["total_amount"].toString();
  map["BM_SN"] =
  jsonDecode(message.data['booking_detail'])["BM_SN"];
  map["Booking_stops"] =
  jsonDecode(message.data['Booking_stops']);

  GenericNotifications.showNotification(
    id: 1,
    title: "New Booking",
    body: "Admin Assigned you a Booking",
    payload: jsonEncode(map),
  );
  if (kDebugMode) {
    print("HANDLING A BACKGROUND MESSAGE : ${message.messageId}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GenericNotifications.initNotifications();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var abcd =
      await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  if (abcd!.didNotificationLaunchApp) {
    HomePro.notificationpayload = abcd.notificationResponse!.payload.toString();
  }
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  API.devid = await firebaseMessaging.getToken();

  // await firebaseMessaging.sendMessage(data: {"a":"123"});
  if (kDebugMode) {
    print(
      "SENTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
  }
  print("TOKEN IS :${API.devid}:");
  NotificationSettings settings = await firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print(
        "------------------------------------------------------------------------------------------------");
    }
    if (kDebugMode) {
      print("RECEIVED FOREGROUND MESSAGE.DATA :${message.data}:");
    }
    bookingStops = jsonDecode(message.data['Booking_stops']);
    if (message.data.toString() == "{title: Admin Ended ur shift}") {
      API.postlocation = false;
      Provider.of<HomePro>(RouteManager.context!, listen: false).shiftid = -1;
      Provider.of<HomePro>(RouteManager.context!, listen: false).vehicleid = -1;
      Provider.of<HomePro>(RouteManager.context!, listen: false)
          .notifyListenerz();
      showDialog(
          context: RouteManager.context!,
          builder: (cont) {
            return Dialog(
              backgroundColor: const Color.fromRGBO(101, 106, 121, 1),
              child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(101, 106, 121, 1),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  height: RouteManager.width / 3,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Shift Ended by Admin",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: RouteManager.width / 17,
                          ),
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          Navigator.of(cont, rootNavigator: true).pop();
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height: RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              "OK",
                              style: TextStyle(
                                fontSize: RouteManager.width / 23,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }).then((value) {
        Provider.of<BottomNavigationPro>(RouteManager.context!, listen: false)
            .clearAll();
        Provider.of<StartShiftPro>(RouteManager.context!, listen: false)
            .clearAll();
        Provider.of<HomePro>(RouteManager.context!, listen: false)
            .timer!
            .cancel();
        Navigator.of(RouteManager.context!).pushNamedAndRemoveUntil(
          RouteManager.homepage,
          (route) => false,
        );
      });
      return;
    }
    FlutterRingtonePlayer.play(
        fromAsset: "assets/ringtone.wav",
        ios: IosSounds.glass
    );
    showDialog(
      context: RouteManager.context!,
      builder: (cont) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10),
            width: RouteManager.width,
            // height: RouteManager.height / 1.4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: RouteManager.width / 20),
                  Container(
                    width: 353,
                    height: 93,
                    decoration: BoxDecoration(
                        color: const Color(0xfffffae6),
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            RouteManager.width / 23,
                          ),
                        ),
                        border: Border.all(color: Color(0xffFFB900))),
                    padding: EdgeInsets.all(RouteManager.width / 70),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .start, // Align children horizontally
                          crossAxisAlignment: CrossAxisAlignment
                              .center, // Align children vertically
                          children: [
                            Container(
                              width: RouteManager.width / 8,
                              height: RouteManager.width / 8,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Icon(
                                Icons.person,
                                size: RouteManager.width / 12,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${jsonDecode(message.data['Customer_Detail'])["CUS_NAME"]}",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: RouteManager.width / 22,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${DateFormat('yyyy-MM-dd').format(DateTime.parse(jsonDecode(message.data['booking_detail'])["BM_DATE"]))}\n${DateFormat('HH:mm:ss').format(DateTime.parse(jsonDecode(message.data['booking_detail'])["BM_DATE"]))}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                4.heightBox,
                                Text(
                                  "Ph# ${jsonDecode(message.data['Customer_Detail'])["CUS_PHONE"]}",
                                  // jsonDecode(message.notification!.body!)["customer_detail"]["CUS_PHONE"].toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: RouteManager.width / 25),
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(children: [
                          SizedBox(
                            height: RouteManager.width / 10,
                          ),
                          SizedBox(
                            width: RouteManager.width / 7,
                          ),
                          const Spacer(),
                        ])
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: RouteManager.width / 70),
                          width: RouteManager.width / 1.5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: RouteManager.width / 20),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: RouteManager.width / 70),
                                width: RouteManager.width / 1.5,
                                height: 280,
                                child: ListView.builder(
                                  itemCount: bookingStops.length,
                                  itemBuilder: (context, index) {
                                    var bookingStop = bookingStops[index];
                                    bool isFirstStop = index == 0;
                                    bool isLastStop =
                                        index == bookingStops.length - 1;

                                    String title;
                                    Color
                                        stopColor; // Define a color for the stop based on your conditions
                                    Color
                                        navigationColor; // Define a color for the navigation button based on your conditions
                                    String address = bookingStop[
                                            'BD_LOCATION'] ??
                                        "abc"; // Use an empty string as default

                                    if (isFirstStop) {
                                      title = "Pick Up";

                                      stopColor = Colors.black;
                                      navigationColor = Colors.green;
                                      // Set the navigation button color for the first stop
                                    } else if (isLastStop) {
                                      title = "Destination";
                                      stopColor = Colors.black;
                                      navigationColor = Colors
                                          .red; // Set the navigation button color for the last stop
                                    } else {
                                      title = "Stop $index";
                                      stopColor = Colors.black;
                                      navigationColor = Color(0xff0038FF);
                                      // Set the navigation button color for intermediate stops
                                    }
                                    return ListTile(
                                      title: Text(
                                        title,
                                        style: TextStyle(
                                          color: stopColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: RouteManager.width / 25,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address,
                                            style: TextStyle(
                                              fontSize: RouteManager.width / 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(Icons.navigation_rounded,
                                            color:
                                                navigationColor), // Use the navigation button color
                                        onPressed: () {
                                          if (isLastStop) {
                                            var destinationStop = bookingStop;
                                            openGoogleMapsNavigationToDestination(
                                              double.parse(
                                                  destinationStop['BD_LAT']),
                                              double.parse(
                                                  destinationStop['BD_LANG']),
                                            );
                                          } else {
                                            var startStop = bookingStop;
                                            openGoogleMapsNavigationToDestination(
                                              double.parse(startStop['BD_LAT']),
                                              double.parse(
                                                  startStop['BD_LANG']),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xfffffae6),
                        borderRadius:
                            BorderRadius.circular(RouteManager.width / 40),
                        border: Border.all(color: Color(0xffFFB900))),
                    padding: EdgeInsets.all(
                      RouteManager.width / 40,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Passengers  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: RouteManager.width / 25),
                            ),
                            Text(
                                jsonDecode(message.data['booking_detail'])[
                                        "BM_PASSENGER"]
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: RouteManager.width / 27),
                                maxLines: 2),
                          ],
                        ),
                        SizedBox(height: RouteManager.width / 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Luggage  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: RouteManager.width / 25),
                            ),
                            Text(
                              jsonDecode(message.data['booking_detail'])[
                                      "BM_M_LUGGAE"]
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: RouteManager.width / 27),
                              maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: RouteManager.width / 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: RouteManager.width / 25),
                            ),
                            Text(
                              jsonDecode(message.data['booking_detail'])[
                                              "BM_PAY_METHOD"]
                                          .toString() ==
                                      "1"
                                  ? "Cash"
                                  : jsonDecode(message.data['booking_detail'])[
                                                  "BM_PAY_METHOD"]
                                              .toString() ==
                                          "2"
                                      ? "Card"
                                      : "Account",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: RouteManager.width / 27),
                              maxLines: 2,
                            ),
                          ],
                        ),
                        SizedBox(height: RouteManager.width / 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Amount  ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: RouteManager.width / 25),
                            ),
                            Text(
                              "${jsonDecode(message.data['booking_detail'])["total_amount"].toString()} £",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: RouteManager.width / 27),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: RouteManager.width / 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                          API.showLoading("", cont);
                          API
                              .respondToBooking(
                                  jsonDecode(
                                      message.data['booking_detail'])["BM_SN"],
                                  2,
                                  cont)
                              .then(
                            (value) {
                              Navigator.of(cont, rootNavigator: true).pop();
                              Navigator.of(cont, rootNavigator: true).pop();
                              Navigator.of(cont)
                                  .pushNamed(RouteManager.jobviewpage);
                            },
                          );
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height: RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                fontSize: RouteManager.width / 23,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffFFB900)),
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                          API.showLoading("", cont);
                          API
                              .respondToBooking(
                                  jsonDecode(
                                      message.data['booking_detail'])["BM_SN"],
                                  3,
                                  cont)
                              .then(
                            (value) {
                              Navigator.of(cont, rootNavigator: true).pop();
                              Navigator.of(cont, rootNavigator: true).pop();
                            },
                          );
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height: RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: RouteManager.width / 23,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (kDebugMode) {
      print('Handling a foreground message: ${message.messageId}');
      print('Message data: ${message.data}');
      print(
          "VEHICLE--------->>>>>>>>>>>>>>>>>>>>>>>${jsonDecode(message.data['vehicle'])["CAR_NAME"]}");
      if (message.notification != null) {
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
    }
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignInPro>(
            create: (BuildContext context) => SignInPro()),
        ChangeNotifierProvider<StartShiftPro>(
            create: (BuildContext context) => StartShiftPro()),
        ChangeNotifierProvider<HomePro>(
            create: (BuildContext context) => HomePro()),
        ChangeNotifierProvider<BottomNavigationPro>(
            create: (BuildContext context) => BottomNavigationPro()),
        ChangeNotifierProvider<CurrentJobsPro>(
            create: (BuildContext context) => CurrentJobsPro()),
        ChangeNotifierProvider<PendingJobsPro>(
            create: (BuildContext context) => PendingJobsPro()),
        ChangeNotifierProvider<CompletedJobsPro>(
            create: (BuildContext context) => CompletedJobsPro()),
        ChangeNotifierProvider<TripDetailsPro>(
            create: (BuildContext context) => TripDetailsPro()),
        ChangeNotifierProvider<PobMapPro>(
            create: (BuildContext context) => PobMapPro()),
      ],
      child: MyApp(),
    ),
  );
}

Future<bool> _handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')));
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }
  return true;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    _handleLocationPermission(context);
    //RouteManager.context = context;
    RouteManager.width = MediaQuery.of(context).size.width;
    RouteManager.height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          // const Color.fromARGB(255, 243, 168, 56)
          // primaryColor: Color.fromARGB(255, 243, 168, 56),
          ),
      //home:const AddBookingScreen()
      initialRoute: RouteManager.rootpage,
      onGenerateRoute: RouteManager.generateRoute,
    );
  }
}
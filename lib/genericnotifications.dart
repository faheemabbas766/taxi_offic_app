import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/pages/home.dart';
import 'package:taxi_app/providers/bottomnavpro.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Api & Routes/api.dart';
import 'Api & Routes/routes.dart';
import 'providers/homepro.dart';
import 'providers/startshiftpro.dart';

class GenericNotifications {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static List<dynamic> bookingStopsAll = [];
  static initNotifications() {
    _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          '@mipmap/ic_launcher',
        ),
        iOS: DarwinInitializationSettings(),
        // iOS: IOSInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (n) async {
        if (kDebugMode) {
          print(
            "RECEIVED FOREGROUND RESPONSE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::${n.payload}");
        }
        if (n.payload.toString() == "0") {
          Provider.of<HomePro>(RouteManager.context!, listen: false).shiftid =
              -1;
          Provider.of<HomePro>(RouteManager.context!, listen: false).vehicleid =
              -1;
          API.postlocation = false;
          // Provider.of<StartShiftPro>(context,listen:false).vehicle_in_shift=Vehicle(vehicleid, make, model);
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
            Provider.of<BottomNavigationPro>(RouteManager.context!,
                    listen: false)
                .clearAll();
            Provider.of<StartShiftPro>(RouteManager.context!, listen: false)
                .clearAll();
            Navigator.of(RouteManager.context!).pushNamedAndRemoveUntil(
              RouteManager.bottomPage,
              (route) => false,
            );
          });
          return;
        }

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
                            border: Border.all(color: const Color(0xffFFB900))),
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
                                      "${jsonDecode(n.payload.toString())["CUS_NAME"]}",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: RouteManager.width / 22,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${DateFormat('yyyy-MM-dd').format(DateTime.parse(jsonDecode(n.payload.toString())["BM_DATE"]))}\n${DateFormat('HH:mm:ss').format(DateTime.parse(jsonDecode(n.payload.toString())["BM_DATE"]))}",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    4.heightBox,
                                    Text(
                                      "Ph# ${jsonDecode(n.payload.toString())["CUS_PHONE"]}",
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
                                      itemCount: jsonDecode(n.payload.toString())["Booking_stops"].length,
                                      itemBuilder: (context, index) {
                                        var bookingStop = jsonDecode(n.payload.toString())["Booking_stops"][index];
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
                                          navigationColor = const Color(0xff0038FF);
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
                            color: const Color(0xfffffae6),
                            borderRadius:
                            BorderRadius.circular(RouteManager.width / 40),
                            border: Border.all(color: const Color(0xffFFB900))),
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
                                    jsonDecode(n.payload.toString())[
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
                                  jsonDecode(n.payload.toString())[
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
                                  jsonDecode(n.payload.toString())[
                                  "BM_PAY_METHOD"]
                                      .toString() ==
                                      "1"
                                      ? "Cash"
                                      : jsonDecode(n.payload.toString())[
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
                                  "${jsonDecode(n.payload.toString())["total_amount"].toString()} £",
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
                                      n.payload.toString())["BM_SN"],
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
                                backgroundColor: const Color(0xffFFB900)),
                            onPressed: () {
                              FlutterRingtonePlayer.stop();
                              API.showLoading("", cont);
                              API
                                  .respondToBooking(
                                  jsonDecode(
                                      n.payload.toString())["BM_SN"],
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
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    // _notifications.toString();
    print("ID:::::::::::::::::::::::::::::::::::::::::::::::::::::::$id:");
    // _notifications.initialize()
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  static void cancelAllNotifications() {
    _notifications.cancelAll();
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        enableVibration: true,
        playSound: true,
        visibility: NotificationVisibility.public,
        priority: Priority.high,
        fullScreenIntent: true,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'accept_action',
            'Close',
            titleColor: Colors.red,
            cancelNotification:true,
          ),
          AndroidNotificationAction(
            'reject_action',
            'Open',
            titleColor: Colors.green,
            showsUserInterface:true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(),
    );
  }
}
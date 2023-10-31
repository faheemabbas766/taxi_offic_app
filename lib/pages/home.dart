import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/homepro.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/themepro.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    RouteManager.context = context;
    Provider.of<HomePro>(context, listen: false).timer = Timer.periodic(
      const Duration(seconds: 5),
          (Timer t) async {
        print(
            "POST LOCATION IS:::::::::::::::::::::::::::::::::::::::::::${API.postlocation}");
        if (API.postlocation) {
          await API.postLocation(
              Provider.of<HomePro>(context, listen: false).shiftid, context);
        }
      },
    );

    if (HomePro.notificationpayload != "") {
      if (HomePro.notificationpayload != "0") {
        // if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          showDialog(
            context: RouteManager.context!,
            builder: (cont) {
              return Dialog(
                backgroundColor: AppColors.of(context).primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(
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
                              border:
                              Border.all(color: const Color(0xffFFB900))),
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
                                    decoration: BoxDecoration(
                                      color: AppColors.of(context).primaryColor,
                                      borderRadius: const BorderRadius.all(
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Name",
                                        //"${jsonDecode(message.data['Customer_Detail'])["CUS_NAME"]}",
                                        style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontSize: RouteManager.width / 22,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "date",
                                        //"${DateFormat('yyyy-MM-dd').format(DateTime.parse(jsonDecode(message.data['booking_detail'])["BM_DATE"]))}\n${DateFormat('HH:mm:ss').format(DateTime.parse(jsonDecode(message.data['booking_detail'])["BM_DATE"]))}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      4.heightBox,
                                      Text(
                                        'phone',
                                        // "Ph# ${jsonDecode(message.data['Customer_Detail'])["CUS_PHONE"]}",
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

                                          Color stopColor;
                                          // Define a color for the stop based on your conditions
                                          Color
                                          navigationColor; // Define a color for the navigation button based on your conditions
                                          String address = bookingStop[
                                          'BD_LOCATION'] ??
                                              "abc"; // Use an empty string as default

                                          if (isFirstStop) {
                                            title = "Pick Up";

                                            stopColor = AppColors.of(context).secondaryColor;
                                            navigationColor = Colors.green;
                                            // Set the navigation button color for the first stop
                                          } else if (isLastStop) {
                                            title = "Destination";
                                            stopColor = AppColors.of(context).secondaryColor;
                                            navigationColor = Colors
                                                .red; // Set the navigation button color for the last stop
                                          } else {
                                            title = "Stop $index";
                                            stopColor = AppColors.of(context).secondaryColor;
                                            navigationColor = const Color(0xff0038FF);
                                            // Set the navigation button color for intermediate stops
                                          }
                                          return ListTile(
                                            title: Text(
                                              title,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                RouteManager.width / 10,
                                              ),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  address,
                                                  style: TextStyle(
                                                    fontSize:
                                                    RouteManager.width / 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: IconButton(
                                              icon: Icon(
                                                  Icons.navigation_rounded,
                                                  color:
                                                  navigationColor), // Use the navigation button color
                                              onPressed: () {
                                                if (isLastStop) {
                                                  var destinationStop =
                                                      bookingStop;
                                                  openGoogleMapsNavigationToDestination(
                                                    double.parse(
                                                        destinationStop[
                                                        'BD_LAT']),
                                                    double.parse(
                                                        destinationStop[
                                                        'BD_LANG']),
                                                  );
                                                } else {
                                                  var startStop = bookingStop;
                                                  openGoogleMapsNavigationToDestination(
                                                    double.parse(
                                                        startStop['BD_LAT']),
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
                              borderRadius: BorderRadius.circular(
                                  RouteManager.width / 40),
                              border: Border.all(color: const Color(0xffFFB900))),
                          padding: EdgeInsets.all(
                            RouteManager.width / 40,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Passengers  ",
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: RouteManager.width / 25),
                                    ),
                                    Text("pessenger",
                                        // jsonDecode(message.data['booking_detail'])["BM_PASSENGER"].toString(),
                                        style: TextStyle(
                                            color: AppColors.of(context).secondaryColor,
                                            fontSize: RouteManager.width / 27),
                                        maxLines: 2),
                                  ],
                                ),
                                SizedBox(height: RouteManager.width / 30),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Luggage  ",
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: RouteManager.width / 25),
                                    ),
                                    Text(
                                      'Lugge',
                                      // jsonDecode(message.data['booking_detail'])["BM_M_LUGGAE"].toString(),
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontSize: RouteManager.width / 27),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: RouteManager.width / 30),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Payment Method  ",
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: RouteManager.width / 25),
                                    ),
                                    Text(
                                      'payment',
                                      // jsonDecode(message.data['booking_detail'])["BM_PAY_METHOD"].toString() == "1" ? "Cash"
                                      //     : jsonDecode(message.data['booking_detail'])[
                                      // "BM_PAY_METHOD"]
                                      //     .toString() ==
                                      //     "2"
                                      //     ? "Card"
                                      //     : "Account",
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontSize: RouteManager.width / 27),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                                SizedBox(height: RouteManager.width / 30),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Amount  ",
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: RouteManager.width / 25),
                                    ),
                                    Text(
                                      'total amount',
                                      // "${jsonDecode(message.data['booking_detail'])["total_amount"].toString()} £",
                                      style: TextStyle(
                                          color: AppColors.of(context).secondaryColor,
                                          fontSize: RouteManager.width / 27),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                // response = message.data['booking_detail'])["BM_SN"]
                                API.respondToBooking(2, 2, cont).then(
                                      (value) {
                                    Navigator.of(cont, rootNavigator: true)
                                        .pop();
                                    Navigator.of(cont, rootNavigator: true)
                                        .pop();
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
                                    3,
                                    // jsonDecode(
                                    //     message.data['booking_detail'])["BM_SN"],
                                    3,
                                    cont)
                                    .then(
                                      (value) {
                                    Navigator.of(cont, rootNavigator: true)
                                        .pop();
                                    Navigator.of(cont, rootNavigator: true)
                                        .pop();
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
          ).then((value) {
            HomePro.notificationpayload = "";
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    RouteManager.context = context;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.of(context).primaryDimColor,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 1,
                          child: SizedBox(
                            width: RouteManager.width / 1,
                            height: RouteManager.width / 3,
                            child: Card(
                              color: AppColors.of(context).accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: RouteManager.width / 20,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: RouteManager.width / 16,
                                ),
                                Image.asset('assets/jobview.png'),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  Provider.of<HomePro>(context).username,
                                  style: TextStyle(
                                    fontSize: RouteManager.width / 14,
                                    color: AppColors.of(context).secondaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'myfonts',
                                  ),
                                ),
                                const SizedBox(
                                  width: 160,
                                ),
                                Icon(
                                  Icons.notifications,
                                  color: AppColors.of(context).secondaryColor,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 26),
                                  child: Text(
                                    '£21,937.32',
                                    style: TextStyle(
                                      color: AppColors.of(context).secondaryColor,
                                      fontSize: 25, //31.62
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: RouteManager.width / 10,
                ),
                Center(
                  child: SizedBox(
                    height: RouteManager.width / 1.06,
                    width: RouteManager.width / 1.06,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RouteManager.startshiftpage);
                                },
                                child: SizedBox(
                                  width: RouteManager.width / 3.3,
                                  height: RouteManager.width / 3.3,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.9,
                                        child: SizedBox(
                                          width: RouteManager.width / 1.04,
                                          height: RouteManager.width / 3,
                                          child: Card(
                                            color: AppColors.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/shift.png",
                                                fit: BoxFit.fill,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          "Shift"
                                              .text
                                              .color(AppColors.of(context).secondaryColor)
                                              .size(14)
                                              .align(TextAlign.center)
                                              .fontWeight(FontWeight.w700)
                                              .make()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(RouteManager.jobviewpage);
                                },
                                child: SizedBox(
                                  width: RouteManager.width / 3.3,
                                  height: RouteManager.width / 3.3,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.9,
                                        child: SizedBox(
                                          width: RouteManager.width / 1.04,
                                          height: RouteManager.width / 3,
                                          child: Card(
                                            color: AppColors.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/jobview.png",
                                                fit: BoxFit.fill,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          "Job View"
                                              .text
                                              .color(AppColors.of(context).secondaryColor)
                                              .size(14)
                                              .align(TextAlign.center)
                                              .fontWeight(FontWeight.w700)
                                              .make()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: SizedBox(
                                  width: RouteManager.width / 3.3,
                                  height: RouteManager.width / 3.3,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.9,
                                        child: SizedBox(
                                          width: RouteManager.width / 1.04,
                                          height: RouteManager.width / 3,
                                          child: Card(
                                            color: AppColors.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/zone.png",
                                                fit: BoxFit.fill,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          "Zones"
                                              .text
                                              .color(AppColors.of(context).secondaryColor)
                                              .size(14)
                                              .align(TextAlign.center)
                                              .fontWeight(FontWeight.w700)
                                              .make()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: RouteManager.width / 3.3,
                                height: RouteManager.width / 3.3,
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: 0.9,
                                      child: SizedBox(
                                        width: RouteManager.width / 1.04,
                                        height: RouteManager.width / 3,
                                        child: Card(
                                          color: AppColors.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/history.png",
                                              fit: BoxFit.fill,
                                              height: 35,
                                              width: 35,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        "Shift History"
                                            .text
                                            .color(AppColors.of(context).secondaryColor)
                                            .size(14)
                                            .align(TextAlign.center)
                                            .fontWeight(FontWeight.w700)
                                            .make()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: RouteManager.width / 3.3,
                                height: RouteManager.width / 3.3,
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: 0.9,
                                      child: SizedBox(
                                        width: RouteManager.width / 1.04,
                                        height: RouteManager.width / 3,
                                        child:  Card(
                                          color: AppColors.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/transaction.png",
                                              fit: BoxFit.fill,
                                              height: 35,
                                              width: 35,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        "Transactions"
                                            .text
                                            .color(AppColors.of(context).secondaryColor)
                                            .size(14)
                                            .align(TextAlign.center)
                                            .fontWeight(FontWeight.w700)
                                            .make()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: RouteManager.width / 3.3,
                                height: RouteManager.width / 3.3,
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: 0.9,
                                      child: SizedBox(
                                        width: RouteManager.width / 1.04,
                                        height: RouteManager.width / 3,
                                        child:  Card(
                                          color: AppColors.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/setting.png",
                                              fit: BoxFit.fill,
                                              height: 35,
                                              width: 35,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        "Settings"
                                            .text
                                            .color(AppColors.of(context).secondaryColor)
                                            .size(14)
                                            .align(TextAlign.center)
                                            .fontWeight(FontWeight.w700)
                                            .make()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: RouteManager.width / 3.3,
                                height: RouteManager.width / 3.3,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed(RouteManager.addBooking);
                                  },
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.9,
                                        child: SizedBox(
                                          width: RouteManager.width / 1.04,
                                          height: RouteManager.width / 3,
                                          child: Card(
                                            color: AppColors.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 16,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              // SizedBox(
                                              //   width: RouteManager.width / 23,
                                              // ),
                                              Image.asset(
                                                "assets/whatsnews.png",
                                                fit: BoxFit.fill,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 29,
                                          ),
                                          "Book Now"
                                              .text
                                              .color(AppColors.of(context).secondaryColor)
                                              .size(14)
                                              .align(TextAlign.center)
                                              .fontWeight(FontWeight.w700)
                                              .make()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: RouteManager.width / 3.3,
                                height: RouteManager.width / 3.3,
                                child: Stack(
                                  children: [
                                    Opacity(
                                      opacity: 0.9,
                                      child: SizedBox(
                                        width: RouteManager.width / 1.04,
                                        height: RouteManager.width / 3,
                                        child:  Card(
                                          color: AppColors.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: RouteManager.width / 19,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/appvideo.png",
                                              fit: BoxFit.fill,
                                              height: 35,
                                              width: 35,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: RouteManager.width / 30,
                                        ),
                                        "App video"
                                            .text
                                            .color(AppColors.of(context).secondaryColor)
                                            .size(14)
                                            .align(TextAlign.center)
                                            .fontWeight(FontWeight.w700)
                                            .make()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (cont) {
                                        return AlertDialog(
                                          backgroundColor:AppColors.of(context).primaryColor,
                                          content: Container(
                                            width: RouteManager.width,
                                            height: RouteManager.width / 2.5,
                                            color: AppColors.of(context).primaryColor,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Sign Out",
                                                  style: TextStyle(
                                                    fontSize:
                                                    RouteManager.width / 18,
                                                    color: AppColors.of(context).secondaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: RouteManager.width /
                                                        14),
                                                Text(
                                                  "Are You Sure?",
                                                  style: TextStyle(
                                                    fontSize:
                                                    RouteManager.width / 20,
                                                    color: AppColors.of(context).secondaryColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: RouteManager.width /
                                                        17),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        const Color.fromARGB(255,
                                                            160, 62, 55),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context,
                                                            rootNavigator:
                                                            true)
                                                            .pop();
                                                      },
                                                      child: SizedBox(
                                                        height:
                                                        RouteManager.width /
                                                            8,
                                                        width:
                                                        RouteManager.width /
                                                            5,
                                                        child: Center(
                                                          child: Text(
                                                            "NO",
                                                            style: TextStyle(
                                                              fontSize:
                                                              RouteManager
                                                                  .width /
                                                                  18,
                                                              color:
                                                              AppColors.of(context).primaryColor,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width:
                                                        RouteManager.width /
                                                            30),
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                        const Color.fromARGB(255,
                                                            47, 121, 50),
                                                      ),
                                                      onPressed: () {
                                                        API
                                                            .logOut(context)
                                                            .then((value) {
                                                          if (value) {
                                                            SharedPreferences
                                                                .getInstance()
                                                                .then((prefs) {
                                                              prefs.clear();
                                                              Provider.of<HomePro>(
                                                                  context,
                                                                  listen:
                                                                  false)
                                                                  .timer!
                                                                  .cancel();
                                                              Provider.of<HomePro>(
                                                                  context,
                                                                  listen:
                                                                  false)
                                                                  .clearAll();
                                                              Navigator.of(
                                                                  context)
                                                                  .pushNamedAndRemoveUntil(
                                                                RouteManager
                                                                    .signinpage,
                                                                    (route) =>
                                                                false,
                                                              );
                                                            });
                                                          }
                                                        });
                                                      },
                                                      child: SizedBox(
                                                        height:
                                                        RouteManager.width /
                                                            8,
                                                        width:
                                                        RouteManager.width /
                                                            5,
                                                        child: Center(
                                                            child: Text(
                                                              "YES",
                                                              style: TextStyle(
                                                                fontSize:
                                                                RouteManager
                                                                    .width /
                                                                    18,
                                                                color: AppColors.of(context).primaryColor,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: SizedBox(
                                  width: RouteManager.width / 3.3,
                                  height: RouteManager.width / 3.3,
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.9,
                                        child: SizedBox(
                                          width: RouteManager.width / 1.04,
                                          height: RouteManager.width / 3,
                                          child:  Card(
                                            color: AppColors.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                "assets/signout.png",
                                                fit: BoxFit.fill,
                                                height: 35,
                                                width: 35,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          "Sign Out"
                                              .text
                                              .color(AppColors.of(context).secondaryColor)
                                              .size(14)
                                              .align(TextAlign.center)
                                              .fontWeight(FontWeight.w700)
                                              .make()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Image.asset("assets/caradd.png"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void openGoogleMapsNavigationToDestination(
    double destinationLat, double destinationLng) async {
  final String googleMapsUrl =
      "https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng&travelmode=driving";
  if (await canLaunch(googleMapsUrl)) {
    await launch(googleMapsUrl);
  } else {
    throw 'Could not launch Google Maps';
  }
}

List<dynamic> bookingStops = [];
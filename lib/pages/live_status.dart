import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/currentjobspro.dart';
import 'home.dart';
class ShowDialogScreen extends StatefulWidget {
  ShowDialogScreen({super.key});

  @override
  State<ShowDialogScreen> createState() => _ShowDialogScreenState();
}

class _ShowDialogScreenState extends State<ShowDialogScreen> {
  int index = 0;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10),
            width: RouteManager.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: RouteManager.width / 20),
                  Container(
                    width: 353,
                    height: 93,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBE7),
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFFFEC400),
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    padding: EdgeInsets.all(RouteManager.width / 70),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              child: const Icon(Icons.person),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Provider.of<CurrentJobsPro>(context)
                                      .jobs[index]
                                      .name
                                      .toUpperCase(),
                                  style: TextStyle(
                                    color: const Color(0xFF2A2A2A),
                                    fontSize: RouteManager.width / 22,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${DateFormat('yyyy-MM-dd').format(DateTime.parse(Provider.of<CurrentJobsPro>(context).jobs[index].date.toString()))}\n${DateFormat('HH:mm:ss').format(DateTime.parse(Provider.of<CurrentJobsPro>(context).jobs[index].date.toString()))}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Color(0xFFA0A0A0),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: RouteManager.width / 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: RouteManager.width / 7,
                                ),
                                const Spacer(),
                                Text(
                                  "Ph# ${Provider.of<CurrentJobsPro>(context).jobs[index].phn}",
                                  style: TextStyle(
                                    color: const Color(0xFFA0A0A0),
                                    fontSize: RouteManager.width / 25,
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
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
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> destination =
                                    list[index];
                                    bool isFirstStop = index == 0;
                                    bool isLastStop = index == list.length - 1;
                                    String title;
                                    Color stopColor;
                                    Color navigationColor;
                                    String address =
                                        destination['BD_LOCATION'] ?? "abc";

                                    if (isFirstStop) {
                                      title = "Pick Up";
                                      stopColor = const Color(0xFF5A5A5A);
                                      navigationColor = Colors.green;
                                    } else if (isLastStop) {
                                      title = "Destination";
                                      stopColor = const Color(0xFF5A5A5A);
                                      navigationColor = Colors.red;
                                    } else {
                                      title = "Stop $index";
                                      stopColor = const Color(0xFF5A5A5A);
                                      navigationColor = Colors.blue;
                                    }

                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: ListTile(
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
                                              color: navigationColor),
                                          onPressed: () {
                                            openGoogleMapsNavigationToDestination(
                                              double.parse(destination['BD_LAT']),
                                              double.parse(
                                                  destination['BD_LANG']),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
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
                              SizedBox(height: RouteManager.width / 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Passenger  ",
                                    style: TextStyle(
                                      color: const Color(0xFF5A5A5A),
                                      fontWeight: FontWeight.w400,
                                      fontSize: RouteManager.width / 25,
                                    ),
                                  ),
                                  Text(
                                    Provider.of<CurrentJobsPro>(context)
                                        .jobs[index]
                                        .passengers
                                        .toString(),
                                    style: TextStyle(
                                      color: const Color(0xFF5A5A5A),
                                      fontSize: RouteManager.width / 27,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                              SizedBox(height: RouteManager.width / 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Luggage  ",
                                    style: TextStyle(
                                      color: const Color(0xFF5A5A5A),
                                      fontWeight: FontWeight.w400,
                                      fontSize: RouteManager.width / 25,
                                    ),
                                  ),
                                  Text(
                                    Provider.of<CurrentJobsPro>(context)
                                        .jobs[index]
                                        .luggage
                                        .toString(),
                                    style: TextStyle(
                                      color: const Color(0xFF5A5A5A),
                                      fontSize: RouteManager.width / 27,
                                    ),
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
                                      color: const Color(0xFF5A5A5A),
                                      fontWeight: FontWeight.w400,
                                      fontSize: RouteManager.width / 25,
                                    ),
                                  ),
                                  Text(
                                    Provider.of<CurrentJobsPro>(context)
                                        .jobs[index]
                                        .paymentmethod
                                        .toString() ==
                                        "1"
                                        ? "Cash"
                                        : Provider.of<CurrentJobsPro>(context)
                                        .jobs[index]
                                        .paymentmethod
                                        .toString() ==
                                        "2"
                                        ? "Card"
                                        : "Account",
                                    style: TextStyle(
                                      color: const Color(0xFF5A5A5A),
                                      fontSize: RouteManager.width / 27,
                                    ),
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
                                      color: const Color(0xFF5A5A5A),
                                      fontWeight: FontWeight.w400,
                                      fontSize: RouteManager.width / 25,
                                    ),
                                  ),
                                  Text(
                                    "${Provider.of<CurrentJobsPro>(context).jobs[index].total_amount.toString()} £",
                                    style: TextStyle(
                                      color: const Color(0xFF5A5A5A),
                                      fontSize: RouteManager.width / 27,
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: RouteManager.width / 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB900),
                        ),
                        onPressed: () {
                          int mapStatus(int currentStatus) {
                            if (currentStatus == 2) {
                              return 11;
                            } else if (currentStatus == 11) {
                              return 9;
                            } else if (currentStatus == 9) {
                              return 6;
                            } else {
                              return currentStatus; // Return the same status if none of the conditions match
                            }
                          }

                          API.showLoading("", context);
                          API.respondToBooking(
                            Provider.of<CurrentJobsPro>(context, listen: false)
                                .jobs[index]
                                .bookid,
                            mapStatus(Provider.of<CurrentJobsPro>(context,
                                listen: false)
                                .jobs[index]
                                .status),
                            context,
                          ).then(
                                (value) async {
                              if (value) {
                                if (Provider.of<CurrentJobsPro>(context,
                                    listen: false)
                                    .jobs[index]
                                    .status ==
                                    9) {
                                  Provider.of<CurrentJobsPro>(context,
                                      listen: false)
                                      .jobs
                                      .removeAt(index);
                                }
                                Provider.of<CurrentJobsPro>(context,
                                    listen: false)
                                    .notifyListenerz();
                              }
                              Provider.of<CurrentJobsPro>(context,
                                  listen: false)
                                  .notifyListenerz();
                              Provider.of<CurrentJobsPro>(context,
                                  listen: false)
                                  .notifyListenerz();
                            },
                          );
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height: RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              (Provider.of<CurrentJobsPro>(context)
                                  .jobs[index]
                                  .status ==
                                  2)
                                  ? "Arrived"
                                  : (Provider.of<CurrentJobsPro>(context)
                                  .jobs[index]
                                  .status ==
                                  11)
                                  ? "POB"
                                  : "Finish",
                              style: TextStyle(
                                fontSize: RouteManager.width / 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
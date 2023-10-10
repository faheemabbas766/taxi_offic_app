import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/Api & Routes/api.dart';
import 'package:taxi_app/Api & Routes/routes.dart';
import 'package:taxi_app/providers/currentjobspro.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class CurrentJobs extends StatefulWidget {
  const CurrentJobs({super.key});

  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await getMyCurrentJobs();
    Myfun(0);
  }

  Future<void> getMyCurrentJobs() async {
    if (mounted) {
      while (true) {
        final currentJobsPro =
        Provider.of<CurrentJobsPro>(context, listen: false);
        currentJobsPro.isloaded = false;
        currentJobsPro.notifyListenerz();

        final homePro = Provider.of<HomePro>(context, listen: false);
        final val = await API.getCurrentJobs(homePro.userid, context);

        if (val) {
          currentJobsPro.isloaded = true;
          currentJobsPro.notifyListenerz();
          break;
        }
      }
    }
  }

  Future<void> Myfun(int index) async {
    final list = await API.getJobDetails(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].bookid.toString(),context);
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
                              color: Color(0xfffffae6),
                              borderRadius:
                              BorderRadius.circular(RouteManager.width / 40),
                              border: Border.all(color: Color(0xffFFB900))),
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
                          API
                              .respondToBooking(
                            Provider.of<CurrentJobsPro>(context, listen: false)
                                .jobs[index]
                                .bookid,
                            mapStatus(Provider.of<CurrentJobsPro>(context,
                                listen: false)
                                .jobs[index]
                                .status),
                            context,
                          )
                              .then(
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
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.of(context, rootNavigator: true).pop();
                              getMyCurrentJobs();
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              Navigator.of(context, rootNavigator: true)
                                  .push(Myfun(index) as Route<Object?>);
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
        );
      },
    );
  }

  Future<void> openGoogleMapsNavigationToDestination(
      double latitude, double longitude) async {
    final url = "google.navigation:q=$latitude,$longitude";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RouteManager.appclr,
      body: Provider.of<CurrentJobsPro>(context).isloaded
          ? Provider.of<CurrentJobsPro>(context).jobs.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No Jobs Taken Yet",
              style: TextStyle(
                fontSize: RouteManager.width / 20,
                color: const Color.fromARGB(255, 54, 54, 54),
              ),
            ),
            SizedBox(height: RouteManager.width / 23),
            InkWell(
              onTap: () async {
                Provider.of<CurrentJobsPro>(context, listen: false)
                    .isloaded = false;
                Provider.of<CurrentJobsPro>(context, listen: false)
                    .notifyListenerz();
                await getMyCurrentJobs();
              },
              child: Text(
                "Tap Here to Refresh",
                style: TextStyle(
                  fontSize: RouteManager.width / 18,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      )
          : Container(
        padding: EdgeInsets.only(
          top: RouteManager.width / 80,
          left: RouteManager.width / 80,
        ),
        child: ListView.builder(
          itemCount: Provider.of<CurrentJobsPro>(context).jobs.length,
          itemBuilder: (cont, index) {
            return InkWell(
              onTap: () {
                Myfun(index);
              },
              child: Column(
                children: [
                  SizedBox(
                    height: RouteManager.width / 80,
                  ),
                  Container(
                    color: const Color(0xFFFEC400),
                    child: Card(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: RouteManager.width / 20,
                              ),
                              Container(
                                color: Colors.grey,
                                width: RouteManager.width / 300,
                                height: RouteManager.width / 3,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: RouteManager.width / 6.4,
                              ),
                              80.heightBox,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  5.widthBox,
                                  Image.asset(
                                    'assets/money.png',
                                    width: 14,
                                    height: 14,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${Provider.of<CurrentJobsPro>(context).jobs[index].total_amount} £",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 47, 150, 44),
                                      fontSize:
                                      RouteManager.width / 20,
                                    ),
                                  ),
                                  SizedBox(
                                      width: RouteManager.width / 80),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 5,
                                    ),
                                    child: Icon(Icons.person),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    Provider.of<CurrentJobsPro>(
                                        context)
                                        .jobs[index]
                                        .name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize:
                                      RouteManager.width / 23,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: RouteManager.width / 30),
                              Stack(
                                children: [
                                  SizedBox(
                                      width: RouteManager.width / 30),
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.red,
                                    size: RouteManager.width / 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: RouteManager.width /
                                              14),
                                      SizedBox(
                                        width:
                                        RouteManager.width / 1.51,
                                        child: Text(
                                          Provider.of<CurrentJobsPro>(
                                              context,
                                              listen: false)
                                              .jobs[index]
                                              .dropaddress,
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color: const Color(
                                                0xff000000),
                                            fontSize:
                                            RouteManager.width /
                                                23,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: RouteManager.width / 40),
                              SizedBox(
                                height: RouteManager.width / 60,
                              ),
                              Stack(
                                children: [
                                  SizedBox(
                                      width: RouteManager.width / 30),
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.green,
                                    size: RouteManager.width / 16,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          width: RouteManager.width /
                                              14),
                                      SizedBox(
                                        width:
                                        RouteManager.width / 1.51,
                                        child: Text(
                                          Provider.of<CurrentJobsPro>(
                                              context,
                                              listen: false)
                                              .jobs[index]
                                              .pickupadress,
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color: const Color(
                                                0xFF000000),
                                            fontSize:
                                            RouteManager.width /
                                                23,
                                          ),
                                          maxLines: 1,
                                          overflow:
                                          TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: RouteManager.width / 500),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      12.widthBox,
                      Image.asset("assets/Line.png"),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
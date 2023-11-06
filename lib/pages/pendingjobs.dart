import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/bottomnavpro.dart';
import '../providers/homepro.dart';
import '../providers/pendingjobspro.dart';
import '../providers/themepro.dart';
import 'home.dart';


class PendingJobs extends StatefulWidget {
  const PendingJobs({super.key});

  @override
  State<PendingJobs> createState() => _PendingJobsState();
}

class _PendingJobsState extends State<PendingJobs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMyPendingJobs();
  }

  getMyPendingJobs() async {
    if (mounted) {
      while (true) {
        Provider.of<PendingJobsPro>(context, listen: false).isloaded = false;
        Provider.of<PendingJobsPro>(context, listen: false).notifyListenerz();
        var val = await API.getPendingJobs(Provider.of<HomePro>(context, listen: false).userid, context);
        if (val) {
          Provider.of<PendingJobsPro>(context, listen: false).isloaded = true;
          Provider.of<PendingJobsPro>(context, listen: false).notifyListenerz();
          break;
        }
      }
    }
  }
  Future<void> _showDialog(int index, var list)async {
    showDialog(
      context: RouteManager.context!,
      builder: (cont) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.of(context).secondaryColor,
              borderRadius: const BorderRadius.all(
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
                      color: AppColors.of(context).secondaryColor,
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
                                  Provider.of<PendingJobsPro>(context)
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
                                  "${DateFormat('yyyy-MM-dd').format(DateTime.parse(Provider.of<PendingJobsPro>(context).jobs[index].date.toString()))}\n${DateFormat('HH:mm:ss').format(DateTime.parse(Provider.of<PendingJobsPro>(context).jobs[index].date.toString()))}",
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
                                  "Ph# ${Provider.of<PendingJobsPro>(context).jobs[index].phn}",
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
                                    Provider.of<PendingJobsPro>(context)
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
                                    Provider.of<PendingJobsPro>(context)
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
                                    Provider.of<PendingJobsPro>(context)
                                        .jobs[index]
                                        .paymentmethod
                                        .toString() ==
                                        "1"
                                        ? "Cash"
                                        : Provider.of<PendingJobsPro>(context)
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
                                    "${Provider.of<PendingJobsPro>(context).jobs[index].total_amount.toString()} £",
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
                            backgroundColor:
                            Colors.red),
                        onPressed: () {
                          API.showLoading("", cont);
                          API
                              .respondToBooking(
                              Provider.of<PendingJobsPro>(
                                  context,
                                  listen: false)
                                  .jobs[index]
                                  .bookid,
                              7,
                              cont)
                              .then((value) {
                            if (value) {
                              Provider.of<PendingJobsPro>(
                                  context,
                                  listen: false)
                                  .jobs
                                  .removeAt(index);
                              Provider.of<PendingJobsPro>(
                                  context,
                                  listen: false)
                                  .notifyListenerz();
                            }
                            Navigator.of(cont,
                                rootNavigator: true)
                                .pop();
                            Navigator.of(cont,
                                rootNavigator: true)
                                .pop();
                          });
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height:
                          RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize:
                                RouteManager.width /
                                    20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.amber),
                        onPressed: () {
                          API.showLoading("", cont);
                          API
                              .respondToBooking(
                              Provider.of<PendingJobsPro>(
                                  context,
                                  listen: false)
                                  .jobs[index]
                                  .bookid,
                              2,
                              cont)
                              .then((value) {
                            if (value) {
                              Provider.of<PendingJobsPro>(
                                  context,
                                  listen: false)
                                  .jobs
                                  .removeAt(index);
                              Provider.of<PendingJobsPro>(
                                  context,
                                  listen: false)
                                  .notifyListenerz();
                            }
                            Navigator.of(cont,
                                rootNavigator: true)
                                .pop();
                            Navigator.of(cont,
                                rootNavigator: true)
                                .pop();
                            Provider.of<BottomNavigationPro>(context, listen: false).navindex = 0;
                            Provider.of<BottomNavigationPro>(context, listen: false).notifyListenerz();

                          });
                        },
                        child: SizedBox(
                          width: RouteManager.width / 5,
                          height:
                          RouteManager.width / 8,
                          child: Center(
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                fontSize:
                                RouteManager.width /
                                    20,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).secondaryDimColor,
      body: Provider.of<PendingJobsPro>(context).isloaded
          ? Provider.of<PendingJobsPro>(context).jobs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Future Jobs",
                        style: TextStyle(
                          fontSize: RouteManager.width / 20,
                          color: AppColors.of(context).secondaryColor,
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 23),
                      InkWell(
                        onTap: () async {
                          Provider.of<PendingJobsPro>(context, listen: false).isloaded = false;
                          Provider.of<PendingJobsPro>(context, listen: false).notifyListenerz();
                          while (true) {
                            Provider.of<PendingJobsPro>(context, listen: false).isloaded = false;
                            Provider.of<PendingJobsPro>(context, listen: false).notifyListenerz();
                            var val = await API.getPendingJobs(Provider.of<HomePro>(context, listen: false).userid, context);
                            if (val) {
                              Provider.of<PendingJobsPro>(context, listen: false).isloaded = true;
                              Provider.of<PendingJobsPro>(context, listen: false).notifyListenerz();
                              break;
                            }
                          }
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
                  padding: EdgeInsets.only(top: RouteManager.width / 80),
                  child: ListView.builder(
                      itemCount: Provider.of<PendingJobsPro>(context).jobs.length,
                      itemBuilder: (cont, index) {
                        return InkWell(
                          onTap: () async {
                            final list = await API.getJobDetails(Provider.of<PendingJobsPro>(context, listen: false).jobs[index].bookid.toString(),context);
                            await _showDialog(index, list);
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: RouteManager.width / 80,
                              ),
                              Card(
                                  color: AppColors.of(context).primaryColor,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(height: RouteManager.width / 6.4),
                                        Row(
                                          children: [
                                            SizedBox(width: RouteManager.width / 1.364),
                                            Container(
                                              color: AppColors.of(context).secondaryColor,
                                              width: RouteManager.width / 300,
                                              height: RouteManager.width / 5.5,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(height: RouteManager.width / 6.4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "  ${Provider.of<PendingJobsPro>(context, listen: false).jobs[index].paymentmethod}  ",
                                              style: TextStyle(
                                                fontSize: RouteManager.width / 20,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: RouteManager.width / 30),
                                        // SizedBox(
                                        //   height: RouteManager.width / 30,
                                        // ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            // SizedBox(height: RouteManager.width / 30),
                                            Text(
                                              "${Provider.of<PendingJobsPro>(context).jobs[index].total_amount} \$",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: const Color.fromARGB(255, 47, 150, 44),
                                                fontSize: RouteManager.width / 20,
                                              ),
                                            ),
                                            SizedBox(width: RouteManager.width / 80),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.amber,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(RouteManager.width / 90),
                                              topLeft: Radius.circular(RouteManager.width / 90),
                                            ),
                                          ),
                                          // width: RouteManager.width,

                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: RouteManager.width / 30),
                                                  Text(
                                                    Provider.of<PendingJobsPro>(context).jobs[index].name,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.of(context).secondaryColor,
                                                      fontSize: RouteManager.width / 23,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 30,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(width: RouteManager.width / 30),
                                                  Text(
                                                    Provider.of<PendingJobsPro>(context).jobs[index].phn,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: AppColors.of(context).secondaryColor,
                                                      fontSize: RouteManager.width / 23,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: RouteManager.width / 60,
                                        ),
                                        Stack(
                                          children: [
                                            SizedBox(width: RouteManager.width / 30),
                                            Icon(
                                              Icons.location_on,
                                              color: const Color.fromARGB(255, 47, 150, 44),
                                              size: RouteManager.width / 16,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: RouteManager.width / 14),
                                                SizedBox(
                                                  width: RouteManager.width / 1.5,
                                                  child: Text(
                                                    Provider.of<PendingJobsPro>(context, listen: false).jobs[index].pickupadress,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromARGB(255, 47, 150, 44),
                                                      fontSize: RouteManager.width / 23,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: RouteManager.width / 24,
                                        ),
                                        Stack(
                                          children: [
                                            SizedBox(width: RouteManager.width / 30),
                                            Icon(
                                              Icons.location_on,
                                              color: const Color.fromARGB(255, 255, 120, 110),
                                              size: RouteManager.width / 16,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: RouteManager.width / 14),
                                                SizedBox(
                                                  width: RouteManager.width / 1.5,
                                                  child: Text(
                                                    Provider.of<PendingJobsPro>(context, listen: false).jobs[index].dropaddress,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      color: const Color.fromARGB(255, 255, 120, 110),
                                                      fontSize: RouteManager.width / 23,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: RouteManager.width / 40,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

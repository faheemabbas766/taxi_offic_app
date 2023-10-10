import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/completedjobspro.dart';
import 'package:taxi_app/providers/tripdetailspro.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/bottomnavpro.dart';
import '../providers/currentjobspro.dart';
import '../providers/homepro.dart';


class CompletedJobs extends StatefulWidget {
  const CompletedJobs({super.key});

  @override
  State<CompletedJobs> createState() => _CompletedJobsState();
}

class _CompletedJobsState extends State<CompletedJobs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMyCompletedJobs();
  }

  getMyCompletedJobs() async {
    if (mounted) {
      while (true) {
        Provider.of<CompletedJobsPro>(context, listen: false).isloaded = false;
        Provider.of<CompletedJobsPro>(context, listen: false).notifyListenerz();
        var val = await API.getCompletedJobs(
            Provider.of<HomePro>(context, listen: false).userid, context);
        if (val) {
          Provider.of<CompletedJobsPro>(context, listen: false).isloaded = true;
          Provider.of<CompletedJobsPro>(context, listen: false)
              .notifyListenerz();
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RouteManager.appclr,
      body: Provider.of<CompletedJobsPro>(context).isloaded
          ? Provider.of<CompletedJobsPro>(context).jobs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Jobs Completed Yet",
                        style: TextStyle(
                          fontSize: RouteManager.width / 20,
                          color: const Color.fromARGB(255, 54, 54, 54),
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 23),
                      InkWell(
                        onTap: () async {
                          Provider.of<CompletedJobsPro>(context, listen: false)
                              .isloaded = false;
                          Provider.of<CompletedJobsPro>(context, listen: false)
                              .notifyListenerz();
                          while (true) {
                            Provider.of<CompletedJobsPro>(context,
                                    listen: false)
                                .isloaded = false;
                            Provider.of<CompletedJobsPro>(context,
                                    listen: false)
                                .notifyListenerz();
                            var val = await API.getCompletedJobs(
                                Provider.of<HomePro>(context, listen: false)
                                    .userid,
                                context);
                            if (val) {
                              Provider.of<CompletedJobsPro>(context,
                                      listen: false)
                                  .isloaded = true;
                              Provider.of<CompletedJobsPro>(context,
                                      listen: false)
                                  .notifyListenerz();
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: RouteManager.width / 80),
                      SizedBox(
                        height: RouteManager.width / 9,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onDoubleTap: () {
                                Provider.of<CompletedJobsPro>(context,
                                        listen: false)
                                    .filterdate = null;
                                setState(() {
                                  // print("STATE SETTTTTTTTTTTTTTTTTTt");
                                });
                              },
                              onTap: () async {
                                DateTimeRange? range =
                                    await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime.now().subtract(
                                      const Duration(days: 365 * 100)),
                                  lastDate: DateTime.now(),
                                );
                                if (range != null) {
                                  Provider.of<CompletedJobsPro>(context,
                                          listen: false)
                                      .filterdate = {
                                    'd1': range.start,
                                    'd2': range.end,
                                  };
                                  setState(() {});
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                  top: RouteManager.width / 70,
                                  bottom: RouteManager.width / 70,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(RouteManager.width / 2),
                                  ),
                                  color: Provider.of<CompletedJobsPro>(context,
                                                  listen: false)
                                              .filterdate !=
                                          null
                                      ? Color.fromARGB(255, 82, 177, 255)
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_alt,
                                        size: RouteManager.width / 14),
                                    Text(
                                      "Date Range  ",
                                      style: TextStyle(
                                          fontSize: RouteManager.width / 22,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: RouteManager.width / 30),
                          ],
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 100),
                      Container(
                        padding:
                            EdgeInsets.only(left: RouteManager.width / 120),
                        // color: Colors.red,
                        height: RouteManager.height / 1.3116,
                        child: ListView.builder(
                            itemCount: Provider.of<CompletedJobsPro>(context)
                                .jobs
                                .length,
                            itemBuilder: (cont, index) {
                              if (index == 0) {
                                Provider.of<CompletedJobsPro>(context,
                                        listen: false)
                                    .matcheditems = 0;
                              }
                              if (Provider.of<CompletedJobsPro>(context,
                                          listen: false)
                                      .filterdate !=
                                  null) {
                                int fd1year = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .filterdate["d1"]
                                    .year;
                                int fd1month = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .filterdate["d1"]
                                    .month;
                                int fd1day = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .filterdate["d1"]
                                    .day;
                                int fd2year = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .filterdate["d2"]
                                    .year;
                                int fd2month = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .filterdate["d2"]
                                    .month;
                                int fd2day = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .filterdate["d2"]
                                    .day;
                                int jobyear = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .jobs[index]
                                    .date
                                    .year;
                                int jobmonth = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .jobs[index]
                                    .date
                                    .month;
                                int jobday = Provider.of<CompletedJobsPro>(
                                        context,
                                        listen: false)
                                    .jobs[index]
                                    .date
                                    .day;
                                if (fd1year == jobyear &&
                                    fd1month == jobmonth &&
                                    fd1day == jobday) {
                                } else if (fd2year == jobyear &&
                                    fd2month == jobmonth &&
                                    fd2day == jobday) {
                                } else if (Provider.of<CompletedJobsPro>(
                                            context,
                                            listen: false)
                                        .jobs[index]
                                        .date
                                        .isAfter(Provider.of<CompletedJobsPro>(
                                                context,
                                                listen: false)
                                            .filterdate["d1"]) &&
                                    Provider.of<CompletedJobsPro>(context,
                                            listen: false)
                                        .jobs[index]
                                        .date
                                        .isBefore(Provider.of<CompletedJobsPro>(
                                                context,
                                                listen: false)
                                            .filterdate["d2"])) {
                                } else {
                                  if (index ==
                                          Provider.of<CompletedJobsPro>(context,
                                                      listen: false)
                                                  .jobs
                                                  .length -
                                              1 &&
                                      Provider.of<CompletedJobsPro>(context,
                                                  listen: false)
                                              .matcheditems ==
                                          0) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: RouteManager.width / 1.5,
                                        ),
                                        Text(
                                          "No Jobs in this Range",
                                          style: TextStyle(
                                            fontSize: RouteManager.width / 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return const SizedBox();
                                }
                              }
                              Provider.of<CompletedJobsPro>(context,
                                      listen: false)
                                  .matcheditems++;
                              return InkWell(
                                onTap: () async {
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .amount = int.parse(Provider.of<CompletedJobsPro>(
                                      context,
                                      listen: false)
                                      .jobs[index]
                                      .total_amount);
                                  Provider.of<TripDetailsPro>(context,
                                              listen: false)
                                          .pickupaddress =
                                      Provider.of<CompletedJobsPro>(context,
                                              listen: false)
                                          .jobs[index]
                                          .pickupadress;
                                  Provider.of<TripDetailsPro>(context,
                                              listen: false)
                                          .dropaddress =
                                      Provider.of<CompletedJobsPro>(context,
                                              listen: false)
                                          .jobs[index]
                                          .dropaddress;
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .datetime = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .date;
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .plat = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .plat;
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .plong = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .plong;
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .dlat = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .dlat;
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .dlong = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .dlong;
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .distance = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .distance;

                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .duration = Provider.of<CompletedJobsPro>(
                                          context,
                                          listen: false)
                                      .jobs[index]
                                      .duration;
                                  API.showLoading("", context);
                                  BitmapDescriptor greentaxi =
                                      await BitmapDescriptor.fromAssetImage(
                                          ImageConfiguration(
                                              size: Size(1000, 1000)),
                                          'assets/greentaxi.png');
                                  BitmapDescriptor redtaxi =
                                      await BitmapDescriptor.fromAssetImage(
                                          ImageConfiguration(
                                              size: Size(1000, 1000)),
                                          'assets/redtaxi.png');
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .markers
                                      .add(
                                        Marker(
                                          markerId: MarkerId(
                                              Provider.of<CompletedJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .jobs[index]
                                                      .plat
                                                      .toString() +
                                                  Provider.of<CompletedJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .jobs[index]
                                                      .plong
                                                      .toString()),
                                          // infoWindow: InfoWindow(title: i["name"] + " +" + i["jobs"].toString() + " Jobs"),
                                          // icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
                                          position: LatLng(
                                            Provider.of<CompletedJobsPro>(
                                                    context,
                                                    listen: false)
                                                .jobs[index]
                                                .plat,
                                            Provider.of<CompletedJobsPro>(
                                                    context,
                                                    listen: false)
                                                .jobs[index]
                                                .plong,
                                          ),
                                          icon: greentaxi,
                                        ),
                                      );
                                  Provider.of<TripDetailsPro>(context,
                                          listen: false)
                                      .markers
                                      .add(
                                        Marker(
                                          markerId: MarkerId(
                                              Provider.of<CompletedJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .jobs[index]
                                                      .dlat
                                                      .toString() +
                                                  Provider.of<CompletedJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .jobs[index]
                                                      .dlong
                                                      .toString()),
                                          // infoWindow: InfoWindow(title: i["name"] + " +" + i["jobs"].toString() + " Jobs"),
                                          // icon: BitmapDescriptor.fromBytes(resizedMarkerImageBytes),
                                          position: LatLng(
                                            Provider.of<CompletedJobsPro>(
                                                    context,
                                                    listen: false)
                                                .jobs[index]
                                                .dlat,
                                            Provider.of<CompletedJobsPro>(
                                                    context,
                                                    listen: false)
                                                .jobs[index]
                                                .dlong,
                                          ),
                                          icon: redtaxi,
                                        ),
                                      );
                                  Provider.of<TripDetailsPro>(context,
                                              listen: false)
                                          .initialcampos =
                                      CameraPosition(
                                          target: LatLng(
                                              Provider.of<CompletedJobsPro>(
                                                      context,
                                                      listen: false)
                                                  .jobs[index]
                                                  .dlat,
                                              Provider.of<CompletedJobsPro>(
                                                      context,
                                                      listen: false)
                                                  .jobs[index]
                                                  .dlong),
                                          zoom: 10);
                                  Navigator.of(context)
                                      .pushNamed(RouteManager.tripdetailspage);
                                  // showDialog(
                                  //   context: RouteManager.context!,
                                  //   builder: (cont) {
                                  //     return Dialog(
                                  //       backgroundColor: const Color.fromRGBO(101, 106, 121, 1),
                                  //       child: Container(
                                  //         decoration: const BoxDecoration(
                                  //           color: Color.fromRGBO(101, 106, 121, 1),
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(20),
                                  //           ),
                                  //         ),
                                  //         padding: EdgeInsets.all(10),
                                  //         width: RouteManager.width,
                                  //         // height: RouteManager.height / 1.6,
                                  //         child: SingleChildScrollView(
                                  //           child: Column(
                                  //             children: [
                                  //               Row(
                                  //                 children: [
                                  //                   InkWell(
                                  //                     onTap: () {
                                  //                       Navigator.of(cont, rootNavigator: true).pop();
                                  //                     },
                                  //                     child: Icon(
                                  //                       Icons.close_rounded,
                                  //                       size: RouteManager.width / 10,
                                  //                       color: Color.fromARGB(255, 207, 52, 41),
                                  //                     ),
                                  //                   ),
                                  //                   SizedBox(
                                  //                     width: RouteManager.width / 28,
                                  //                   ),
                                  //                   Container(
                                  //                     width: RouteManager.width / 2,
                                  //                     padding: EdgeInsets.all(RouteManager.width / 30),
                                  //                     decoration: BoxDecoration(
                                  //                       color: Colors.blue,
                                  //                       borderRadius: BorderRadius.all(
                                  //                         Radius.circular(RouteManager.width),
                                  //                       ),
                                  //                     ),
                                  //                     child: Center(
                                  //                       child: Text(
                                  //                         "Job Details",
                                  //                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: RouteManager.width / 17),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               SizedBox(height: RouteManager.width / 20),
                                  //               // Container(
                                  //               //   decoration: BoxDecoration(
                                  //               //     color: Colors.blue,
                                  //               //     borderRadius: BorderRadius.all(
                                  //               //       Radius.circular(RouteManager.width / 23),
                                  //               //     ),
                                  //               //   ),
                                  //               //   padding: EdgeInsets.all(RouteManager.width / 70),
                                  //               //   child: Stack(
                                  //               //     children: [
                                  //               //       Row(
                                  //               //         children: [
                                  //               //           Container(
                                  //               //             width: RouteManager.width / 8,
                                  //               //             height: RouteManager.width / 8,
                                  //               //             decoration: const BoxDecoration(
                                  //               //               color: Colors.white,
                                  //               //               borderRadius: BorderRadius.all(
                                  //               //                 Radius.circular(30),
                                  //               //               ),
                                  //               //             ),
                                  //               //             child: Icon(Icons.person, size: RouteManager.width / 12),
                                  //               //           ),
                                  //               //           Text(
                                  //               //             " " + Provider.of<CompletedJobsPro>(context).jobs[index].name,
                                  //               //             style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 22),
                                  //               //           ),
                                  //               //         ],
                                  //               //       ),
                                  //               //       Column(children: [
                                  //               //         SizedBox(
                                  //               //           height: RouteManager.width / 10,
                                  //               //         ),
                                  //               //         Row(
                                  //               //           children: [
                                  //               //             SizedBox(
                                  //               //               width: RouteManager.width / 7,
                                  //               //             ),
                                  //               //             Text(
                                  //               //               Provider.of<CompletedJobsPro>(context).jobs[index].phn,
                                  //               //               style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 25),
                                  //               //             ),
                                  //               //           ],
                                  //               //         )
                                  //               //       ])
                                  //               //     ],
                                  //               //   ),
                                  //               // ),

                                  //               // SizedBox(height: RouteManager.width / 20),
                                  //               Row(
                                  //                 children: [
                                  //                   Icon(
                                  //                     Icons.location_on,
                                  //                     color: Color.fromARGB(255, 123, 247, 127),
                                  //                     size: RouteManager.width / 16,
                                  //                   ),
                                  //                   Text(
                                  //                     " Pick Up",
                                  //                     style: TextStyle(color: const Color.fromARGB(255, 123, 247, 127), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //               SizedBox(height: RouteManager.width / 70),
                                  //               Container(
                                  //                 width: RouteManager.width / 1.5,
                                  //                 child: Text(
                                  //                   Provider.of<CompletedJobsPro>(context).jobs[index].pickupadress,
                                  //                   style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //                   // maxLines: 2,
                                  //                 ),
                                  //               ),
                                  //               SizedBox(height: RouteManager.width / 60),
                                  //               Container(
                                  //                 width: RouteManager.width / 1.5,
                                  //                 child: Text(
                                  //                   "(" + Provider.of<CompletedJobsPro>(context).jobs[index].pickupnote + ")",
                                  //                   style: TextStyle(color: const Color.fromARGB(255, 235, 235, 235), fontSize: RouteManager.width / 27),
                                  //                   // maxLines: 2,
                                  //                 ),
                                  //               ),
                                  //               // SizedBox(height: RouteManager.width / 25),
                                  //               // Row(
                                  //               //   children: [
                                  //               //     SizedBox(
                                  //               //       width: RouteManager.width / 13,
                                  //               //     ),
                                  //               //     Icon(
                                  //               //       Icons.note_alt_outlined,
                                  //               //       color: const Color.fromARGB(255, 123, 247, 127),
                                  //               //       size: RouteManager.width / 16,
                                  //               //     ),
                                  //               //     Text(
                                  //               //       "Pick Up Note",
                                  //               //       style: TextStyle(color: const Color.fromARGB(255, 188, 224, 255), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //               //     )
                                  //               //   ],
                                  //               // ),
                                  //               // SizedBox(height: RouteManager.width / 70),
                                  //               // Row(
                                  //               //   children: [
                                  //               //     SizedBox(
                                  //               //       width: RouteManager.width / 7,
                                  //               //     ),
                                  //               //     Container(
                                  //               //       decoration: BoxDecoration(
                                  //               //         borderRadius: BorderRadius.circular(RouteManager.width / 50),
                                  //               //         color: Colors.black,
                                  //               //       ),
                                  //               //       padding: EdgeInsets.all(RouteManager.width / 50),
                                  //               //       width: RouteManager.width / 1.68,
                                  //               //       child: Text(
                                  //               //         Provider.of<CompletedJobsPro>(context).jobs[index].pickupnote,
                                  //               //         style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //               //         // maxLines: 2,
                                  //               //       ),
                                  //               //     ),
                                  //               //   ],
                                  //               // ),

                                  //               SizedBox(height: RouteManager.width / 20),

                                  //               Row(
                                  //                 children: [
                                  //                   Icon(
                                  //                     Icons.location_on,
                                  //                     color: Color.fromARGB(255, 255, 120, 110),
                                  //                     size: RouteManager.width / 16,
                                  //                   ),
                                  //                   Text(
                                  //                     " Destination",
                                  //                     style: TextStyle(color: const Color.fromARGB(255, 255, 120, 110), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //                   )
                                  //                 ],
                                  //               ),
                                  //               SizedBox(height: RouteManager.width / 70),
                                  //               Container(
                                  //                 width: RouteManager.width / 1.5,
                                  //                 child: Text(
                                  //                   Provider.of<CompletedJobsPro>(context).jobs[index].dropaddress,
                                  //                   style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //                   // maxLines: 2,
                                  //                 ),
                                  //               ),
                                  //               SizedBox(height: RouteManager.width / 60),
                                  //               Container(
                                  //                 width: RouteManager.width / 1.5,
                                  //                 child: Text(
                                  //                   "(" + Provider.of<CompletedJobsPro>(context).jobs[index].dropnote + ")",
                                  //                   style: TextStyle(color: const Color.fromARGB(255, 235, 235, 235), fontSize: RouteManager.width / 27),
                                  //                   // maxLines: 2,
                                  //                 ),
                                  //               ),
                                  //               // SizedBox(height: RouteManager.width / 25),
                                  //               // Row(
                                  //               //   children: [
                                  //               //     SizedBox(
                                  //               //       width: RouteManager.width / 13,
                                  //               //     ),
                                  //               //     Icon(
                                  //               //       Icons.note_alt_outlined,
                                  //               //       color: const Color.fromARGB(255, 255, 120, 110),
                                  //               //       size: RouteManager.width / 16,
                                  //               //     ),
                                  //               //     Text(
                                  //               //       "Drop Note",
                                  //               //       style: TextStyle(color: const Color.fromARGB(255, 188, 224, 255), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //               //     )
                                  //               //   ],
                                  //               // ),
                                  //               // SizedBox(height: RouteManager.width / 70),
                                  //               // Row(
                                  //               //   children: [
                                  //               //     SizedBox(
                                  //               //       width: RouteManager.width / 7,
                                  //               //     ),
                                  //               //     Container(
                                  //               //       decoration: BoxDecoration(
                                  //               //         borderRadius: BorderRadius.circular(RouteManager.width / 50),
                                  //               //         color: Colors.black,
                                  //               //       ),
                                  //               //       padding: EdgeInsets.all(RouteManager.width / 50),
                                  //               //       width: RouteManager.width / 1.68,
                                  //               //       child: Text(
                                  //               //         Provider.of<CompletedJobsPro>(context).jobs[index].dropnote,
                                  //               //         style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //               //         // maxLines: 2,
                                  //               //       ),
                                  //               //     ),
                                  //               //   ],
                                  //               // ),

                                  //               SizedBox(height: RouteManager.width / 20),
                                  //               Container(
                                  //                 decoration: BoxDecoration(
                                  //                   color: const Color.fromARGB(255, 56, 56, 56),
                                  //                   borderRadius: BorderRadius.circular(RouteManager.width / 40),
                                  //                 ),
                                  //                 padding: EdgeInsets.all(
                                  //                   RouteManager.width / 40,
                                  //                 ),
                                  //                 child: Column(
                                  //                   children: [
                                  //                     Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           "Passengers  ",
                                  //                           style: TextStyle(color: const Color.fromARGB(255, 188, 224, 255), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //                         ),
                                  //                         Text(Provider.of<CompletedJobsPro>(context).jobs[index].passengers.toString(),
                                  //                             style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27), maxLines: 2),
                                  //                       ],
                                  //                     ),
                                  //                     SizedBox(height: RouteManager.width / 30),
                                  //                     Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           "Luggage  ",
                                  //                           style: TextStyle(color: const Color.fromARGB(255, 188, 224, 255), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //                         ),
                                  //                         Text(
                                  //                           Provider.of<CompletedJobsPro>(context).jobs[index].luggage.toString(),
                                  //                           style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //                           maxLines: 2,
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                     SizedBox(height: RouteManager.width / 30),
                                  //                     Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           "Payment Method  ",
                                  //                           style: TextStyle(color: const Color.fromARGB(255, 188, 224, 255), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //                         ),
                                  //                         Text(
                                  //                           // jsonDecode(message.notification!.body!)["booking_detail"]["BM_PAY_METHOD"] == 1
                                  //                           //     ? "Cash"
                                  //                           //     : jsonDecode(message.notification!.body!)["booking_detail"]["BM_PAY_METHOD"] == 2
                                  //                           //         ? "Card"
                                  //                           //         : "Account",
                                  //                           Provider.of<CompletedJobsPro>(context).jobs[index].paymentmethod,
                                  //                           style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //                           maxLines: 2,
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                     SizedBox(height: RouteManager.width / 30),
                                  //                     Row(
                                  //                       children: [
                                  //                         Text(
                                  //                           "Total Amount  ",
                                  //                           style: TextStyle(color: const Color.fromARGB(255, 188, 224, 255), fontWeight: FontWeight.bold, fontSize: RouteManager.width / 25),
                                  //                         ),
                                  //                         Text(
                                  //                           // jsonDecode(message.notification!.body!)["booking_detail"]["BM_PAY_METHOD"] == 1
                                  //                           //     ? "Cash"
                                  //                           //     : jsonDecode(message.notification!.body!)["booking_detail"]["BM_PAY_METHOD"] == 2
                                  //                           //         ? "Card"
                                  //                           //         : "Account",
                                  //                           Provider.of<CompletedJobsPro>(context).jobs[index].total_amount.toString() + " \$",
                                  //                           style: TextStyle(color: Colors.white, fontSize: RouteManager.width / 27),
                                  //                           maxLines: 2,
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                   ],
                                  //                 ),
                                  //               ),

                                  //               SizedBox(height: RouteManager.width / 20),
                                  //               Row(
                                  //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  //                 children: [
                                  //                   // ElevatedButton(
                                  //                   //   style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  //                   //   onPressed: () {
                                  //                   //     API.showLoading("", cont);
                                  //                   //     API.respondToBooking(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index].bookid, 6, cont).then((value) {
                                  //                   //       if (value) {
                                  //                   //         Provider.of<CompletedJobsPro>(context, listen: false).jobs.add(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index]);
                                  //                   //         Provider.of<CurrentJobsPro>(context, listen: false).jobs.removeAt(index);
                                  //                   //         Provider.of<CurrentJobsPro>(context, listen: false).notifyListenerz();
                                  //                   //         Provider.of<CompletedJobsPro>(context, listen: false).notifyListenerz();
                                  //                   //       }
                                  //                   //       Navigator.of(cont, rootNavigator: true).pop();
                                  //                   //       Navigator.of(cont, rootNavigator: true).pop();
                                  //                   //     });
                                  //                   //   },
                                  //                   //   child: Container(
                                  //                   //     width: RouteManager.width / 5,
                                  //                   //     height: RouteManager.width / 8,
                                  //                   //     child: Center(
                                  //                   //       child: Text(
                                  //                   //         "Finish",
                                  //                   //         style: TextStyle(
                                  //                   //           fontSize: RouteManager.width / 20,
                                  //                   //         ),
                                  //                   //       ),
                                  //                   //     ),
                                  //                   //   ),
                                  //                   // ),
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //     // );
                                  //   },
                                  // );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: RouteManager.width / 80,
                                    ),
                                    Container(
                                      color: Color(0xffFFB900),
                                      child: Card(
                                        // color: const Color.fromARGB(108, 18, 76, 151),
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                SizedBox(
                                                    height:
                                                        RouteManager.width / 4),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            RouteManager.width /
                                                                1.364),
                                                    Container(
                                                      color: Color(0xffFFFBE7),
                                                      width:
                                                          RouteManager.width /
                                                              300,
                                                      height:
                                                          RouteManager.width /
                                                              6,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Column(
                                              // mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                    height:
                                                        RouteManager.width / 9),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                // Container(
                                                //   color: Colors.black,
                                                //   height: RouteManager.width / 30,
                                                // ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top:
                                                        RouteManager.width / 60,
                                                    bottom:
                                                        RouteManager.width / 60,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    // color: Color.fromARGB(255, 47, 150, 44),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topRight: Radius.circular(
                                                          RouteManager.width /
                                                              90),
                                                      topLeft: Radius.circular(
                                                          RouteManager.width /
                                                              90),
                                                    ),
                                                  ),
                                                  // width: RouteManager.width,

                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.person),
                                                          5.widthBox,
                                                          Text(
                                                            Provider.of<CompletedJobsPro>(
                                                                    context)
                                                                .jobs[index]
                                                                .name
                                                                .toUpperCase()
                                                                .toString(),
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              // color: Colors.white,
                                                              fontSize:
                                                                  RouteManager
                                                                          .width /
                                                                      23,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons.access_time,
                                                            size: RouteManager
                                                                    .width /
                                                                15,
                                                            // color: Colors.white,
                                                          ),
                                                          Builder(
                                                            builder: (context) {
                                                              String datetime = "  " +
                                                                  Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .day
                                                                      .toString() +
                                                                  "-" +
                                                                  Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .getMonth(Provider.of<CompletedJobsPro>(
                                                                              context)
                                                                          .jobs[
                                                                              index]
                                                                          .date
                                                                          .month) +
                                                                  "-" +
                                                                  Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .year
                                                                      .toString() +
                                                                  "  ";
                                                              if (Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .hour
                                                                      .toString()
                                                                      .length !=
                                                                  2) {
                                                                datetime += "0" +
                                                                    Provider.of<CompletedJobsPro>(
                                                                            context)
                                                                        .jobs[
                                                                            index]
                                                                        .date
                                                                        .hour
                                                                        .toString() +
                                                                    ":";
                                                              } else {
                                                                datetime += Provider.of<CompletedJobsPro>(
                                                                            context)
                                                                        .jobs[
                                                                            index]
                                                                        .date
                                                                        .hour
                                                                        .toString() +
                                                                    ":";
                                                              }
                                                              if (Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .minute
                                                                      .toString()
                                                                      .length !=
                                                                  2) {
                                                                datetime += "0" +
                                                                    Provider.of<CompletedJobsPro>(
                                                                            context)
                                                                        .jobs[
                                                                            index]
                                                                        .date
                                                                        .minute
                                                                        .toString();
                                                              } else {
                                                                datetime += Provider.of<
                                                                            CompletedJobsPro>(
                                                                        context)
                                                                    .jobs[index]
                                                                    .date
                                                                    .minute
                                                                    .toString();
                                                              }
                                                              return Text(
                                                                datetime,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  // color: Colors.white,
                                                                  fontSize:
                                                                      RouteManager
                                                                              .width /
                                                                          23,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      // SizedBox(
                                                      //   height: RouteManager.width / 30,
                                                      // ),
                                                      // Row(
                                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                                      //   children: [
                                                      //     SizedBox(width: RouteManager.width / 30),
                                                      //     Text(
                                                      //       Provider.of<CompletedJobsPro>(context).jobs[index].phn,
                                                      //       style: TextStyle(
                                                      //         fontWeight: FontWeight.w500,
                                                      //         color: Colors.white,
                                                      //         fontSize: RouteManager.width / 23,
                                                      //       ),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:
                                                      RouteManager.width / 60,
                                                ),

                                                Stack(
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            RouteManager.width /
                                                                30),
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 47, 150, 44),
                                                      size: RouteManager.width /
                                                          16,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: RouteManager
                                                                    .width /
                                                                14),
                                                        SizedBox(
                                                          width: RouteManager
                                                                  .width /
                                                              1.5,
                                                          child: Text(
                                                            Provider.of<CompletedJobsPro>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .jobs[index]
                                                                .pickupadress,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  RouteManager
                                                                          .width /
                                                                      23,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height:
                                                      RouteManager.width / 500,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    12.widthBox,
                                                    Image.asset(
                                                        "assets/Line.png"),
                                                  ],
                                                ),
                                                Stack(
                                                  children: [
                                                    SizedBox(
                                                        width:
                                                            RouteManager.width /
                                                                30),
                                                    Icon(
                                                      Icons
                                                          .location_on_outlined,
                                                      color: Colors.red,
                                                      size: RouteManager.width /
                                                          16,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: RouteManager
                                                                    .width /
                                                                14),
                                                        SizedBox(
                                                          width: RouteManager
                                                                  .width /
                                                              1.5,
                                                          child: Text(
                                                            Provider.of<CompletedJobsPro>(
                                                                    context,
                                                                    listen:
                                                                        false)
                                                                .jobs[index]
                                                                .dropaddress,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                              fontSize:
                                                                  RouteManager
                                                                          .width /
                                                                      23,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(
                                                //   height: RouteManager.width / 30,
                                                // ),
                                                // Row(
                                                //   children: [
                                                //     SizedBox(width: RouteManager.width / 30),
                                                //     Text(
                                                //       "Passengers : ",
                                                //       style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         color: const Color.fromARGB(255, 115, 252, 119),
                                                //         fontSize: RouteManager.width / 23,
                                                //       ),
                                                //     ),
                                                //     Text(
                                                //       Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].passengers.toString(),
                                                //       style: TextStyle(
                                                //         color: Colors.white,
                                                //         fontSize: RouteManager.width / 25,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                // SizedBox(
                                                //   height: RouteManager.width / 30,
                                                // ),
                                                // Row(
                                                //   children: [
                                                //     SizedBox(width: RouteManager.width / 30),
                                                //     Text(
                                                //       "Luggage : ",
                                                //       style: TextStyle(
                                                //         fontWeight: FontWeight.bold,
                                                //         color: const Color.fromARGB(255, 115, 252, 119),
                                                //         fontSize: RouteManager.width / 23,
                                                //       ),
                                                //     ),
                                                //     Text(
                                                //       Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].luggage.toString(),
                                                //       style: TextStyle(
                                                //         color: Colors.white,
                                                //         fontSize: RouteManager.width / 25,
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                SizedBox(
                                                  height:
                                                      RouteManager.width / 40,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    6.widthBox,
                                                    Image.asset(
                                                      "assets/money.png",
                                                      width: 14,
                                                      height: 14,
                                                    ),
                                                    Text(
                                                      "  " +
                                                          Provider.of<CompletedJobsPro>(
                                                                  context,
                                                                  listen: false)
                                                              .jobs[index]
                                                              .paymentmethod
                                                              .toString() +
                                                          "  ",
                                                      style: TextStyle(
                                                          // color: Colors.white,
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      Provider.of<CompletedJobsPro>(
                                                                  context)
                                                              .jobs[index]
                                                              .total_amount
                                                              .toString() +
                                                          " \$",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize:
                                                            RouteManager.width /
                                                                20,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // SizedBox(
                                                //   height: RouteManager.width / 30,
                                                // ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    // SizedBox(height: RouteManager.width / 30),

                                                    SizedBox(
                                                        width:
                                                            RouteManager.width /
                                                                80),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

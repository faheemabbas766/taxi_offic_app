import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/completedjobspro.dart';
import 'package:taxi_app/providers/themepro.dart';
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
      backgroundColor: AppColors.of(context).secondaryDimColor,
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
                                      ? const Color.fromARGB(255, 82, 177, 255)
                                      : AppColors.of(context).primaryColor,
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.filter_alt,
                                        size: RouteManager.width / 14),
                                    Text(
                                      "Date Range  ",
                                      style: TextStyle(
                                          fontSize: RouteManager.width / 22,
                                          color: AppColors.of(context).secondaryColor),
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
                                            color: AppColors.of(context).secondaryColor,
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
                                          const ImageConfiguration(
                                              size: Size(1000, 1000)),
                                          'assets/greentaxi.png');
                                  BitmapDescriptor redtaxi =
                                      await BitmapDescriptor.fromAssetImage(
                                          const ImageConfiguration(
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
                                                    color: AppColors.of(context).secondaryColor,
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
                                              Container(
                                                padding: EdgeInsets.only(
                                                  top:
                                                      RouteManager.width / 60,
                                                  bottom:
                                                      RouteManager.width / 60,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(255, 47, 150, 44),
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
                                                        Icon(
                                                          Icons.person,
                                                          color: AppColors.of(context).secondaryColor
                                                        ),
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
                                                            color: AppColors.of(context).secondaryColor,
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
                                                          color: AppColors.of(context).secondaryColor,
                                                        ),
                                                        Builder(
                                                          builder: (context) {
                                                            String datetime = "  ${Provider.of<CompletedJobsPro>(
                                                                        context)
                                                                    .jobs[
                                                                        index]
                                                                    .date
                                                                    .day}-${Provider.of<CompletedJobsPro>(
                                                                        context)
                                                                    .jobs[
                                                                        index]
                                                                    .getMonth(Provider.of<CompletedJobsPro>(
                                                                            context)
                                                                        .jobs[
                                                                            index]
                                                                        .date
                                                                        .month)}-${Provider.of<CompletedJobsPro>(
                                                                        context)
                                                                    .jobs[
                                                                        index]
                                                                    .date
                                                                    .year}  ";
                                                            if (Provider.of<CompletedJobsPro>(
                                                                        context)
                                                                    .jobs[
                                                                        index]
                                                                    .date
                                                                    .hour
                                                                    .toString()
                                                                    .length !=
                                                                2) {
                                                              datetime += "0${Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .hour}:";
                                                            } else {
                                                              datetime += "${Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .hour}:";
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
                                                              datetime += "0${Provider.of<CompletedJobsPro>(
                                                                          context)
                                                                      .jobs[
                                                                          index]
                                                                      .date
                                                                      .minute}";
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
                                                                    color: AppColors.of(context).secondaryColor,
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
                                                            AppColors.of(context).secondaryColor,
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
                                                            color: AppColors.of(context).secondaryColor,
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
                                                    "  ${Provider.of<CompletedJobsPro>(
                                                                context,
                                                                listen: false)
                                                            .jobs[index]
                                                            .paymentmethod}  ",
                                                    style: TextStyle(
                                                        fontSize: RouteManager
                                                                .width /
                                                            20,
                                                        color: AppColors.of(context).secondaryColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${Provider.of<CompletedJobsPro>(
                                                                context)
                                                            .jobs[index]
                                                            .total_amount} \$",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppColors.of(context).secondaryColor,
                                                      fontSize:
                                                          RouteManager.width /
                                                              20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
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
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

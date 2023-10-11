import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/completedjobspro.dart';

import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/bottomnavpro.dart';
import '../providers/homepro.dart';


class CompletedJobs extends StatefulWidget {
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
        var val = await API.getCompletedJobs(Provider.of<HomePro>(context, listen: false).userid, context);
        if (val) {
          Provider.of<CompletedJobsPro>(context, listen: false).isloaded = true;
          Provider.of<CompletedJobsPro>(context, listen: false).notifyListenerz();
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(55, 61, 76, 1),
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
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 23),
                      InkWell(
                        onTap: () async {
                          Provider.of<CompletedJobsPro>(context, listen: false).isloaded = false;
                          Provider.of<CompletedJobsPro>(context, listen: false).notifyListenerz();
                          while (true) {
                            Provider.of<CompletedJobsPro>(context, listen: false).isloaded = false;
                            Provider.of<CompletedJobsPro>(context, listen: false).notifyListenerz();
                            var val = await API.getCompletedJobs(Provider.of<HomePro>(context, listen: false).userid, context);
                            if (val) {
                              Provider.of<CompletedJobsPro>(context, listen: false).isloaded = true;
                              Provider.of<CompletedJobsPro>(context, listen: false).notifyListenerz();
                              break;
                            }
                          }
                        },
                        child: Text(
                          "Tap Here to Refresh",
                          style: TextStyle(
                            fontSize: RouteManager.width / 18,
                            color: Color.fromARGB(255, 156, 205, 218),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: EdgeInsets.only(top: RouteManager.width / 80),
                  // color: Colors.red,
                  child: ListView.builder(
                      itemCount: Provider.of<CompletedJobsPro>(context).jobs.length,
                      itemBuilder: (cont, index) {
                        return InkWell(
                          onTap: () {},
                          child: Card(
                            color: Color.fromARGB(108, 34, 193, 233),
                            child: Column(
                              children: [
                                // Container(
                                //   color: Theme.of(context).secondaryHeaderColor,
                                //   height: RouteManager.width / 30,
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 47, 150, 44),
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
                                            Provider.of<CompletedJobsPro>(context).jobs[index].name,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
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
                                            Provider.of<CompletedJobsPro>(context).jobs[index].phn,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
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
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 30),
                                    Icon(
                                      Icons.location_on,
                                      color: Color.fromARGB(255, 123, 247, 127),
                                      size: RouteManager.width / 16,
                                    ),
                                    Text(
                                      "Pick Up : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 115, 252, 119),
                                        fontSize: RouteManager.width / 23,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 40,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 10),
                                    Container(
                                      width: RouteManager.width / 1.3,
                                      child: Text(
                                        Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].pickupadress,
                                        style: TextStyle(
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: RouteManager.width / 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 40,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 30),
                                    Icon(
                                      Icons.location_on,
                                      color: Color.fromARGB(255, 255, 120, 110),
                                      size: RouteManager.width / 16,
                                    ),
                                    Text(
                                      "Destination : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 255, 120, 110),
                                        fontSize: RouteManager.width / 23,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 40,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 10),
                                    Container(
                                      width: RouteManager.width / 1.3,
                                      child: Text(
                                        Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].dropaddress,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: RouteManager.width / 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 30),
                                    Text(
                                      "Passengers : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 115, 252, 119),
                                        fontSize: RouteManager.width / 23,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].passengers.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: RouteManager.width / 25,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 30),
                                    Text(
                                      "Luggage : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 115, 252, 119),
                                        fontSize: RouteManager.width / 23,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].luggage.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: RouteManager.width / 25,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 30),
                                    Text(
                                      "Payment Method : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 115, 252, 119),
                                        fontSize: RouteManager.width / 23,
                                      ),
                                    ),
                                    Text(
                                      Provider.of<CompletedJobsPro>(context, listen: false).jobs[index].paymentmethod,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: RouteManager.width / 25,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: RouteManager.width / 30,
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: RouteManager.width / 30),
                                    Text(
                                      "Total Amount : ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(255, 115, 252, 119),
                                        fontSize: RouteManager.width / 23,
                                      ),
                                    ),
                                    Text(
                                      // jsonDecode(message.notification!.body!)["booking_detail"]["BM_PAY_METHOD"] == 1
                                      //     ? "Cash"
                                      //     : jsonDecode(message.notification!.body!)["booking_detail"]["BM_PAY_METHOD"] == 2
                                      //         ? "Card"
                                      //         : "Account",
                                      Provider.of<CompletedJobsPro>(context).jobs[index].total_amount.toString() + " \$",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: RouteManager.width / 25,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

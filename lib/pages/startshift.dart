import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:taxi_app/providers/homepro.dart';
import 'package:fluttertoast/fluttertoast.dart' as ft;
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/startshiftpro.dart';

class StartShift extends StatefulWidget {
  @override
  State<StartShift> createState() => _StartShiftState();
}

class _StartShiftState extends State<StartShift> {
  @override
  void initState() {
    super.initState();
    API.getVehicles(
        Provider.of<HomePro>(context, listen: false).userid, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<StartShiftPro>(context, listen: false).isloaded = false;
        Provider.of<StartShiftPro>(context, listen: false).vehicles = [];
        Provider.of<StartShiftPro>(context, listen: false).selectedvehicleid =
            -1;

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              SizedBox(width: RouteManager.width / 5.6),
              // Text(
              //   "Shifts",
              //   style: TextStyle(fontSize: RouteManager.width / 10),
              // ),
            ],
          ),
          shadowColor: Colors.white,
        ),
        body: !Provider.of<StartShiftPro>(context).isloaded
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Provider.of<HomePro>(context).shiftid != -1 &&
                    Provider.of<HomePro>(context).vehicleid != -1
                ? Column(
                    children: [
                      SizedBox(
                        height: RouteManager.width / 15,
                      ),
                      Container(
                        width: RouteManager.width / 1.11,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(RouteManager.width / 10),
                          //color: const Color.fromARGB(255, 75, 189, 79),
                        ),
                        child: Builder(
                          builder: (context) {
                            for (int i = 0;
                                i <
                                    Provider.of<StartShiftPro>(context,
                                            listen: false)
                                        .vehicles
                                        .length;
                                i++) {
                              if (Provider.of<StartShiftPro>(context,
                                          listen: false)
                                      .vehicles[i]
                                      .id ==
                                  Provider.of<HomePro>(context, listen: false)
                                      .vehicleid) {
                                return Card(
                                  color: const Color(0xffFFFBE7),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color(0xffFEC400)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Stack(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: RouteManager.width / 30,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: RouteManager.width / 12,
                                              ),
                                              Text(
                                                "Start Time  :  ",
                                                style: TextStyle(
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color:
                                                      const Color(0xFF5A5A5A),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${Provider.of<HomePro>(context).shiftfrom!.year}-${Provider.of<HomePro>(context).shiftfrom!.month}-${Provider.of<HomePro>(context).shiftfrom!.day}  ",
                                                style: TextStyle(
                                                    fontSize:
                                                        RouteManager.width / 20,
                                                    color: const Color(
                                                        0xFF5A5A5A)),
                                              ),
                                              Provider.of<HomePro>(context)
                                                          .shiftfrom!
                                                          .hour
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftfrom!.hour}:",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    )
                                                  : Text(
                                                      "${Provider.of<HomePro>(context).shiftfrom!.hour}:",
                                                      style: TextStyle(
                                                        fontSize:
                                                            RouteManager.width /
                                                                20,
                                                        color: const Color(
                                                            0xFF5A5A5A),
                                                      ),
                                                    ),
                                              Provider.of<HomePro>(context)
                                                          .shiftfrom!
                                                          .minute
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftfrom!.minute}",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    )
                                                  : Text(
                                                      Provider.of<HomePro>(
                                                              context)
                                                          .shiftfrom!
                                                          .minute
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: RouteManager.width / 12,
                                              ),
                                              Text(
                                                "End   Time  :  ",
                                                style: TextStyle(
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color:
                                                      const Color(0xFF5A5A5A),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${Provider.of<HomePro>(context).shiftto!.year}-${Provider.of<HomePro>(context).shiftto!.month}-${Provider.of<HomePro>(context).shiftto!.day}  ",
                                                style: TextStyle(
                                                    fontSize:
                                                        RouteManager.width / 20,
                                                    color: const Color(
                                                        0xFF5A5A5A)),
                                              ),
                                              Provider.of<HomePro>(context)
                                                          .shiftto!
                                                          .hour
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftto!.hour}:",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    )
                                                  : Text(
                                                      "${Provider.of<HomePro>(context).shiftto!.hour}:",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    ),
                                              Provider.of<HomePro>(context)
                                                          .shiftto!
                                                          .minute
                                                          .toString()
                                                          .length ==
                                                      1
                                                  ? Text(
                                                      "0${Provider.of<HomePro>(context).shiftto!.minute}",
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    )
                                                  : Text(
                                                      Provider.of<HomePro>(
                                                              context)
                                                          .shiftto!
                                                          .minute
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: RouteManager
                                                                  .width /
                                                              20,
                                                          color: const Color(
                                                              0xFF5A5A5A)),
                                                    ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width:
                                                      RouteManager.width / 12),
                                              Text(
                                                "Car               :  ",
                                                style: TextStyle(
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color:
                                                      const Color(0xFF5A5A5A),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "${Provider.of<StartShiftPro>(context, listen: false).vehicles[i].make} ${Provider.of<StartShiftPro>(context, listen: false).vehicles[i].model}",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize:
                                                      RouteManager.width / 20,
                                                  color:
                                                      const Color(0xFF5A5A5A),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: RouteManager.width / 40,
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    RouteManager.width / 60),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 28),
                      Opacity(
                        opacity: 0.5,
                        child: Container(
                          width: RouteManager.width / 1.3,
                          color: Colors.white,
                          height: RouteManager.width / 100,
                        ),
                      ),
                      SizedBox(height: RouteManager.width / 28),
                      Container(
                        height: RouteManager.height / 1.9,
                        child: ListView.builder(
                          itemCount: Provider.of<StartShiftPro>(context)
                              .vehicles
                              .length,
                          itemBuilder: (cont, ind) {
                            return const SizedBox();
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          API.showLoading("", context);
                          API
                              .stopShift(
                            Provider.of<HomePro>(context, listen: false).userid,
                            Provider.of<HomePro>(context, listen: false)
                                .shiftid,
                            context,
                          )
                              .then((value) {
                            API.postlocation = false;
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xfffebd23),
                            ),
                            color: const Color(0xfffebd23),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Stop Shift",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: RouteManager.width / 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: RouteManager.width / 15,
                      ),
                      Container(
                        height: RouteManager.height / 1.3,
                        child: ListView.builder(
                          itemCount: Provider.of<StartShiftPro>(context)
                              .vehicles
                              .length,
                          itemBuilder: (cont, ind) {
                            return Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .selectedvehicleid ==
                                        Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .vehicles[ind]
                                            .id) {
                                      Provider.of<StartShiftPro>(cont,
                                              listen: false)
                                          .selectedvehicleid = -1;
                                      Provider.of<StartShiftPro>(cont,
                                              listen: false)
                                          .notifyListenerz();
                                      return;
                                    }
                                    Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .selectedvehicleid =
                                        Provider.of<StartShiftPro>(cont,
                                                listen: false)
                                            .vehicles[ind]
                                            .id;
                                    Provider.of<StartShiftPro>(cont,
                                            listen: false)
                                        .notifyListenerz();
                                  },
                                  child: Container(
                                    width: RouteManager.width,
                                    // alignment: Alignment.center,
                                    // color: Colors.red,
                                    child: Card(
                                      color: Provider.of<StartShiftPro>(cont)
                                                  .selectedvehicleid ==
                                              Provider.of<StartShiftPro>(cont)
                                                  .vehicles[ind]
                                                  .id
                                          ? const Color(0xfffebd23)
                                          : const Color(0xFFFFFBE7),
                                      elevation: 3,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: RouteManager.width / 23,
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 40,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          RouteManager.width /
                                                              23),
                                                  Text(
                                                    Provider.of<StartShiftPro>(
                                                            cont)
                                                        .vehicles[ind]
                                                        .make
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          RouteManager.width /
                                                              20,
                                                      color: Theme.of(context).secondaryHeaderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 40,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          RouteManager.width /
                                                              23),
                                                  Text(
                                                    Provider.of<StartShiftPro>(
                                                            cont)
                                                        .vehicles[ind]
                                                        .model
                                                        .toString(),
                                                    style: TextStyle(
                                                      fontSize:
                                                          RouteManager.width /
                                                              20,
                                                      color: Theme.of(context).secondaryHeaderColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: RouteManager.width / 40,
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              SizedBox(
                                                  height:
                                                      RouteManager.width / 23),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      width:
                                                          RouteManager.width /
                                                              1.2),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                    ),
                                                    width:
                                                        RouteManager.width / 15,
                                                    height:
                                                        RouteManager.width / 15,
                                                    child: Provider.of<StartShiftPro>(
                                                                    context)
                                                                .selectedvehicleid ==
                                                            Provider.of<StartShiftPro>(
                                                                    context)
                                                                .vehicles[ind]
                                                                .id
                                                        ? const Icon(
                                                            Icons.check,
                                                          )
                                                        : const SizedBox(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: RouteManager.width / 23,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (Provider.of<StartShiftPro>(context, listen: false)
                                  .selectedvehicleid ==
                              -1) {
                            ft.Fluttertoast.showToast(
                              msg: "Select Vehicle",
                              toastLength: ft.Toast.LENGTH_LONG,
                            );
                            return;
                          }
                          API.showLoading("", context);
                          API
                              .startShift(
                            Provider.of<HomePro>(context, listen: false).userid,
                            Provider.of<StartShiftPro>(context, listen: false)
                                .selectedvehicleid,
                            context,
                          )
                              .then((value) {
                            API.postlocation = true;
                            Provider.of<StartShiftPro>(context, listen: false)
                                .selectedvehicleid = -1;
                            Navigator.of(context, rootNavigator: true).pop();
                          });
                        },
                        child: Container(
                          height: 50,
                          width: 320,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xfffebd23),
                            ),
                            color: const Color(0xfffebd23),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text("Start Shift",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: RouteManager.width / 12,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

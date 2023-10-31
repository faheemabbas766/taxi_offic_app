import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart' as ft;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_app/Api%20&%20Routes/routes.dart';
import 'package:taxi_app/Entities/jobsobject.dart';
import 'package:taxi_app/Entities/vehicles.dart';
import 'package:taxi_app/providers/currentjobspro.dart';
import '../main.dart';
import '../providers/completedjobspro.dart';
import '../providers/homepro.dart';
import '../providers/pendingjobspro.dart';
import '../providers/startshiftpro.dart';

class API {
  static String? devid;
  static bool postlocation = false;
  static showLoading(String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.2,
                child: SizedBox(
                  width: RouteManager.width,
                  height: RouteManager.height,
                ),
              ),
              Center(
                child: SizedBox(
                  width: RouteManager.width / 2,
                  height: RouteManager.height / 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: RouteManager.width / 7,
                        height: RouteManager.width / 7,
                        child: const CircularProgressIndicator(),
                      ),
                      DefaultTextStyle(
                        style: TextStyle(fontSize: RouteManager.width / 20),
                        child: Text(text),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  static Future<List<dynamic>> getJobDetails(String id, BuildContext context) async {
    final response = await http.post(
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/getjobdetail"),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded', // Modify as needed
        'Accept': 'application/json', // Add Accept header
        'token': Provider.of<HomePro>(context, listen: false).token, // Replace with your token source
      },
      body: {
        "booking_id": id,
      },
    );

    if (response.statusCode == 401) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
        RouteManager.signinpage,
            (route) => false,
      );
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['data']['booking_destinations'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> logIn(String username, String companyid, String pwd,
      BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/login"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data'
    });
    if (kDebugMode) {
      print("DEV ID  IS : : : : : : : :$devid");
    }
    request.fields.addAll({
      'username': username,
      'company_id': companyid,
      'password': pwd,
      'device_id': devid!,
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 25),
          onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 201) {
        var res = jsonDecode(responsed.body);
        Provider.of<HomePro>(context, listen: false).username = username;
        // print("VALUE IS : : : : : : : : : : : : : : : "+res["data"]["id"].toString());
        Provider.of<HomePro>(context, listen: false).userid = res["data"]["id"];
        Provider.of<HomePro>(context, listen: false).token = res["token"];
        if (kDebugMode) {
          print("RESPONSE IS : : : : : :${responsed.body}");
        }
        if (kDebugMode) {
          print("TOKEN SAVED IS : : : : : :$token");
        }

        return true;
      }
      if (response.statusCode == 400) {
        var res = jsonDecode(responsed.body);
        if (res["status"] != null) {
          ft.Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: ft.Toast.LENGTH_LONG,
          );
          return false;
        }
        throw Exception();
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        // Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "Sign In Unsuccessful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Sign In Unsuccessful",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> getShift(int userid, BuildContext context) async {
    if (kDebugMode) {
      print("USER ID IS : : : : : : $userid");
    }
    if (kDebugMode) {
      print(
        "GET SHIFTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
    }
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/useractiveshift"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      'id': userid.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        if (res["status"] == "200") {
          Provider.of<HomePro>(context, listen: false).shiftid =
              res["shift_id"];
          Provider.of<HomePro>(context, listen: false).vehicleid =
              res["vehicle_id"];
          Provider.of<HomePro>(context, listen: false).shiftfrom = DateTime(
            int.parse(res["start_shift"].split(" ")[0].split("-")[0]),
            int.parse(res["start_shift"].split(" ")[0].split("-")[1]),
            int.parse(res["start_shift"].split(" ")[0].split("-")[2]),
            int.parse(res["start_shift"].split(" ")[1].split(":")[0]),
            int.parse(res["start_shift"].split(" ")[1].split(":")[1]),
          );
          Provider.of<HomePro>(context, listen: false).shiftto = DateTime(
            int.parse(res["end_shift"].split(" ")[0].split("-")[0]),
            int.parse(res["end_shift"].split(" ")[0].split("-")[1]),
            int.parse(res["end_shift"].split(" ")[0].split("-")[2]),
            int.parse(res["end_shift"].split(" ")[1].split(":")[0]),
            int.parse(res["end_shift"].split(" ")[1].split(":")[1]),
          );
        }
        print("RESPONSE IS : : : : : :$res");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        // Navigator.of(context, rootNavigator: true).pop();
        // ft.Fluttertoast.showToast(
        //   msg: "Sign In Unsuccessful",
        //   toastLength: ft.Toast.LENGTH_LONG,
        // );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      // ft.Fluttertoast.showToast(
      //   msg: "Sign In Unsuccessful",
      //   toastLength: ft.Toast.LENGTH_LONG,
      // );
      return false;
    }
  }

  static Future<bool> getCurrentJobs(int userid, BuildContext context) async {
    print("USER ID IS : : : : : : $userid");
    print("GET CURRENT JOBS CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/get_jobs"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({'id': userid.toString(), 'status': '2,11,9'});
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(
        const Duration(seconds: 25),
        onTimeout: () {
          throw "TimeOut";
        },
      );
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        if (res["status"] == "200") {
          Provider.of<CurrentJobsPro>(context, listen: false).jobs = [];
          for (var i in res["data"]) {
            if (kDebugMode) {
              print("res of I IS : : :$i");
            }
            JobObject jj = JobObject(
                i["BM_SN"]?? "401",
                i["CUS_NAME"]?? "Name",
                i["CUS_PHONE"]?? "Phone",
                i["BM_PICKUP"]?? "Pickup",
                i["BM_DROP"]?? "drop",
                int.parse(i["BM_PASSENGER"]),
                i["BM_LAGGAGE"] == "1"
                    ? "Large"
                    : i["BM_LAGGAGE"] == "2"
                        ? "Small"
                        : "Hand Carry",
                i["BM_PAY_METHOD"] == "1"
                    ? "Cash"
                    : i["BM_PAY_METHOD"] == "2"
                        ? "Card"
                        : "Account",
                i["total_amount"].toString(),
                DateTime(
                  int.parse(i["BM_DATE"].split(' ')[0].split('-')[0]),
                  int.parse(i["BM_DATE"].split(' ')[0].split('-')[1]),
                  int.parse(i["BM_DATE"].split(' ')[0].split('-')[2]),
                  int.parse(i["BM_DATE"].split(' ')[1].split(':')[0]),
                  int.parse(i["BM_DATE"].split(' ')[1].split(':')[1]),
                  int.parse(i["BM_DATE"].split(' ')[1].split(':')[2]),
                ),
                i["BM_PICKUP_NOTE"] ?? "No Note",
                i["BM_DROP_NOTE"] ?? "No Note",
                double.parse(i["BM_PLAT"]),
                double.parse(i["BM_PLANG"]),
                double.parse(i["BM_DLAT"]?? "0.0"),
                double.parse(i["BM_DLANG"]?? "0.0"),
                i["BM_DISTANCE"].toString(),
                i["BM_DISTANCE_TIMe"].toString());
            jj.status = i["BM_STATUS"];
            print("STATUS OF CURRENT JOB IS::::::::::::::::::${jj.status}");
            Provider.of<CurrentJobsPro>(context, listen: false).jobs.add(jj);
          }
        }
        print("RESPONSE IS : : : : : :$res");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> getCompletedJobs(int userid, BuildContext context) async {
    print("GET Completed JOBS CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/get_jobs"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      'id': userid.toString(),
      'status': 6.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        stdout.write("RESSSSSSSSSSSSSS::::::::::::::::::$res");
        if (res["status"] == "200") {
          Provider.of<CompletedJobsPro>(context, listen: false).jobs = [];
          for (var i in res["data"]) {
            // print("res of I IS : : :"+i.toString());
            Provider.of<CompletedJobsPro>(context, listen: false).jobs.add(
                  JobObject(
                      i["BM_SN"],
                      i["CUS_NAME"],
                      i["CUS_PHONE"],
                      i["BM_PICKUP"],
                      i["BM_DROP"],
                      int.parse(i["BM_PASSENGER"]),
                      i["BM_LAGGAGE"] == "1"
                          ? "Large"
                          : i["BM_LAGGAGE"] == "2"
                              ? "Small"
                              : "Hand Carry",
                      i["BM_PAY_METHOD"] == "1"
                          ? "Cash"
                          : i["BM_PAY_METHOD"] == "2"
                              ? "Card"
                              : "Account",
                      i["total_amount"],
                      DateTime(
                        int.parse(i["BM_DATE"].split(' ')[0].split('-')[0]),
                        int.parse(i["BM_DATE"].split(' ')[0].split('-')[1]),
                        int.parse(i["BM_DATE"].split(' ')[0].split('-')[2]),
                        int.parse(i["BM_DATE"].split(' ')[1].split(':')[0]),
                        int.parse(i["BM_DATE"].split(' ')[1].split(':')[1]),
                        int.parse(i["BM_DATE"].split(' ')[1].split(':')[2]),
                      ),
                      i["BM_PICKUP_NOTE"] ?? "Default Pickup Note",
                      i["BM_DROP_NOTE"] ?? "Default Drop Note",
                      double.parse(i["BM_PLAT"]),
                      double.parse(i["BM_PLANG"]),
                      double.parse(i["BM_DLAT"]),
                      double.parse(i["BM_DLANG"]),
                      i["BM_DISTANCE"].toString(),
                      i["BM_DISTANCE_TIME"].toString()),
                );
          }
        }
        print("RESPONSE IS : : : : : :$res");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> getPendingJobs(int userid, BuildContext context) async {
    print("USER ID IS : : : : : : $userid");
    print("GET PENDING JOBS CALLEDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/get_jobs"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      'id': userid.toString(),
      'status': 12.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        print("RESSSSSSSSSSSSSS::::::::::::::::::$res");
        if (res["status"] == "200") {
          Provider.of<PendingJobsPro>(context, listen: false).jobs = [];
          for (var i in res["data"]) {
            // print("res of I IS : : :"+i.toString());
            Provider.of<PendingJobsPro>(context, listen: false).jobs.add(
                  JobObject(
                      i["BM_SN"],
                      i["CUS_NAME"],
                      i["CUS_PHONE"],
                      i["BM_PICKUP"],
                      i["BM_DROP"],
                      int.parse(i["BM_PASSENGER"]),
                      i["BM_LAGGAGE"] == "1"
                          ? "Large"
                          : i["BM_LAGGAGE"] == "2"
                              ? "Small"
                              : "Hand Carry",
                      i["BM_PAY_METHOD"] == "1"
                          ? "Cash"
                          : i["BM_PAY_METHOD"] == "2"
                              ? "Card"
                              : "Account",
                      i["total_amount"],
                      DateTime(
                        int.parse(i["BM_DATE"].split(' ')[0].split('-')[0]),
                        int.parse(i["BM_DATE"].split(' ')[0].split('-')[1]),
                        int.parse(i["BM_DATE"].split(' ')[0].split('-')[2]),
                        int.parse(i["BM_DATE"].split(' ')[1].split(':')[0]),
                        int.parse(i["BM_DATE"].split(' ')[1].split(':')[1]),
                        int.parse(i["BM_DATE"].split(' ')[1].split(':')[2]),
                      ),
                      i["BM_PICKUP_NOTE"] ?? "Default Pickup Note",
                      i["BM_DROP_NOTE"] ?? "Default Drop Note",
                      double.parse(i["BM_PLAT"]),
                      double.parse(i["BM_PLANG"]),
                      double.parse(i["BM_DLAT"]),
                      double.parse(i["BM_DLANG"]),
                      i["BM_DISTANCE"].toString(),
                      i["BM_DISTANCE_TIMe"].toString()),
                );
          }
        }
        print("RESPONSE IS : : : : : :$res");
        print("Length of ::::::::::::::::::::::::::::::::::::::::");
        print(Provider.of<PendingJobsPro>(context, listen: false).jobs.length);
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      return false;
    }
  }

  static Future<bool> logOut(BuildContext context) async {
    print("AYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/logout"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      print(
          "STATUSSSSSS::::::::::::::::::::::::::::::::::::::::::::::::::::::${response.statusCode}");
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        ft.Fluttertoast.showToast(
          msg: "Sign Out Successful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return true;
      } else {
        ft.Fluttertoast.showToast(
          msg: "Sign Out Unsuccessful",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "Sign Out Unsuccessful",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> getVehicles(int userid, BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/getvehiclebyid"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    print("DEV ID  IS : : : : : : : :$devid");
    request.fields.addAll({
      'id': userid.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);

        print("RESPONSE IS : : : : : :${responsed.body}");
        print(
            "AAALLLLLLLLLLLLLLL GOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDDDDDDd");
        for (var i in res["data"]) {
          // if(Provider.of<HomePro>(context,listen:false).shiftid!=-1 && Provider.of<HomePro>(context,listen:false).vehicleid!=-1)
          // {
          //   if(i["uv_id"]==Provider.of<HomePro>(context,listen:false).vehicleid)
          //   {

          //   }
          // }
          Provider.of<StartShiftPro>(context, listen: false).vehicles.add(
                Vehicle(i["uv_id"], i["uv_make"], i["uv_model"]),
              );
        }
        // for (var i in res["data"]) {
        //   Provider.of<StartShiftPro>(context, listen: false).vehicles.add(
        //         Vehicle(i["uv_id"], i["uv_make"], i["uv_model"]),
        //       );
        // }
        Provider.of<StartShiftPro>(context, listen: false).isloaded = true;
        Provider.of<StartShiftPro>(context, listen: false).notifyListenerz();
        // ft.Fluttertoast.showToast(
        //   msg: "Vehicles Fetched Successfully",
        //   toastLength: ft.Toast.LENGTH_LONG,
        // );
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        // Navigator.of(context, rootNavigator: true).pop();
        ft.Fluttertoast.showToast(
          msg: "failed 1",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "failed 2",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> startShift(
      int userid, int vehicleid, BuildContext context) async {
    var pos = await Geolocator.getCurrentPosition();
    print("Latitude  is : ${pos.latitude}");
    print("Longitude is : ${pos.longitude}");
    // return false;
    // return pos.latitude.toString() + "|" + pos.longitude.toString();
    var d = DateTime.now();
    print("DATE IS : $d");
    // return true;
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://dispatch.finalsolutions.com.pk/api/change_shift_status"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    print("DEV ID  IS : : : : : : : :$devid");
    request.fields.addAll({
      'SHF_IN_USRID': userid.toString(),
      'SHF_VEH_REF': vehicleid.toString(),
      // 'SHF_DATE_FROM': d.year.toString() + "-" + d.month.toString() + "-" + d.day.toString(),
      // 'SHF_TIME_FROM': d.hour.toString() + ":" + d.minute.toString(),
      'SHF_TYPE': 1.toString(),
      'SHF_LATT': pos.latitude.toString(),
      'SHF_LANG': pos.longitude.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);if (
      response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        var res = jsonDecode(responsed.body);
        print("START SHIFT RESPONSE IS : : : : : :${responsed.body}");
        Provider.of<HomePro>(context, listen: false).shiftid =
            res["Shiftdata"]["shift_id"];
        Provider.of<HomePro>(context, listen: false).vehicleid = vehicleid;
        String dtfrom = res["Shiftdata"]["shift_date_time_from"].toString();
        String dtto = res["Shiftdata"]["shift_date_time_to"].toString();
        Provider.of<HomePro>(context, listen: false).shiftfrom = DateTime(
          int.parse(
            dtfrom.split(' ')[0].split('-')[0],
          ),
          int.parse(
            dtfrom.split(' ')[0].split('-')[1],
          ),
          int.parse(
            dtfrom.split(' ')[0].split('-')[2],
          ),
          int.parse(
            dtfrom.split(' ')[1].split(':')[0],
          ),
          int.parse(
            dtfrom.split(' ')[1].split(':')[1],
          ),
        );
        Provider.of<HomePro>(context, listen: false).shiftto = DateTime(
          int.parse(
            dtto.split(' ')[0].split('-')[0],
          ),
          int.parse(
            dtto.split(' ')[0].split('-')[1],
          ),
          int.parse(
            dtto.split(' ')[0].split('-')[2],
          ),
          int.parse(
            dtto.split(' ')[1].split(':')[0],
          ),
          int.parse(
            dtto.split(' ')[1].split(':')[1],
          ),
        );
        // Provider.of<StartShiftPro>(context,listen:false).vehicle_in_shift=Vehicle(vehicleid, make, model);
        Provider.of<HomePro>(context, listen: false).notifyListenerz();
        print(
            "AAALLLLLLLLLLLLLLL GOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDDDDDDd");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "failed",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "failed",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> postLocation(int shiftid,BuildContext context) async {
    var pos = await Geolocator.getCurrentPosition();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://dispatch.finalsolutions.com.pk/api/updatelocation"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      'id': shiftid.toString(),
      'SHF_LATT': pos.latitude.toString(),
      'SHF_LANG': pos.longitude.toString(),
    });
    http.StreamedResponse response;
    try {
      response = await request.send().timeout(const Duration(seconds: 20),
          onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("POST LOCATION RESPONSE IS : : : : : :${responsed.body}");
        }
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      // ft.Fluttertoast.showToast(
      //   msg: "failed",
      //   toastLength: ft.Toast.LENGTH_LONG,
      // );
      return false;
    }
  }

  static Future<bool> stopShift(
      int userid, int shiftid, BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://dispatch.finalsolutions.com.pk/api/change_shift_status"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    print("DEV ID  IS : : : : : : : :$devid");
    request.fields.addAll({
      'id': shiftid.toString(),
      'SHF_IN_USRID': userid.toString(),
      'SHF_TYPE': 2.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }if (response.statusCode == 200) {
        print("RESPONSE IS : : : : : :${responsed.body}");
        Provider.of<HomePro>(context, listen: false).shiftid = -1;
        Provider.of<HomePro>(context, listen: false).vehicleid = -1;

        // Provider.of<StartShiftPro>(context,listen:false).vehicle_in_shift=Vehicle(vehicleid, make, model);
        Provider.of<HomePro>(context, listen: false).notifyListenerz();
        print(
            "AAALLLLLLLLLLLLLLL GOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDDDDDDd");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "failed",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "failed",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<bool> respondToBooking(int bookingid,
      int status, BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          "https://dispatch.finalsolutions.com.pk/api/update_booking_status"),
    );
    request.headers.addAll({
      'Content-type': 'multipart/form-data',
      'Accept': 'application/json',
      'token': Provider.of<HomePro>(context, listen: false).token,
    });
    request.fields.addAll({
      'booking_id': bookingid.toString(),
      'status': status.toString(),
    });
    http.StreamedResponse response;
    try {
      response =
          await request.send().timeout(const Duration(seconds: 25), onTimeout: () {
        throw "TimeOut";
      });
      var responsed = await http.Response.fromStream(response);
      if (response.statusCode == 401){
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear();
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.signinpage,
              (route) => false,
        );
      }if (response.statusCode == 200) {
        if (status == 2) {
          ft.Fluttertoast.showToast(
            msg: "Accepted",
            toastLength: ft.Toast.LENGTH_LONG,
          );
        }
        if (status == 3) {
          ft.Fluttertoast.showToast(
            msg: "Rejected",
            toastLength: ft.Toast.LENGTH_LONG,
          );
        }
        if (status == 6) {
          ft.Fluttertoast.showToast(
            msg: "Completed",
            toastLength: ft.Toast.LENGTH_LONG,
          );
        }
        print("RESPONSE IS : : : : : :${responsed.body}");
        print(
            "AAALLLLLLLLLLLLLLL GOOOOOOOOOOOOOOOOOODDDDDDDDDDDDDDDDDDDDDDDDd");
        return true;
      } else {
        print(
            "STATUS CODE IS : : : : : : : : : :${response.statusCode}: ${responsed.body}");
        ft.Fluttertoast.showToast(
          msg: "failed",
          toastLength: ft.Toast.LENGTH_LONG,
        );
        return false;
      }
    } catch (e) {
      print("ROLAAAAAAAAAAAAAAAAAAAAAA$e");
      // Navigator.of(context, rootNavigator: true).pop();
      ft.Fluttertoast.showToast(
        msg: "failed",
        toastLength: ft.Toast.LENGTH_LONG,
      );
      return false;
    }
  }

  static Future<List<dynamic>> fetchDetailsOfNewBooking(int bookingId, BuildContext context) async {
    final Map<String, dynamic> requestBody = {
      'booking_id': bookingId,
    };

    final response = await http.post(
      Uri.parse('https://dispatch.finalsolutions.com.pk/api/get_stops_detail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json', // Add Accept header
        'token': Provider.of<HomePro>(context, listen: false).token, // Replace with your token source
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 401) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
      });
    }

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load data from get stop details');
    }
  }
}

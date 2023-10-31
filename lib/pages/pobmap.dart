import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../Api & Routes/api.dart';
import '../Api & Routes/routes.dart';
import '../providers/currentjobspro.dart';
import '../providers/pobmappro.dart';
// class Signin extends StatefulWidget {
//   @override
//   State<Signin> createState() => _SigninState();
// }

class PobMap extends StatefulWidget {
  const PobMap({super.key});

  @override
  State<PobMap> createState() => _PobMapState();
}

class _PobMapState extends State<PobMap> {
  late GoogleMapController _googleMapController;
  bool mapcontrollerinit = false;
  @override
  void dispose() {
    if (mapcontrollerinit) {
      _googleMapController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPoints();
  }

  getPoints() async {
    await Provider.of<PobMapPro>(context, listen: false)
        .polylinePoints
        .getRouteBetweenCoordinates(
          'AIzaSyDtpG_aelSiirqtT-8rahx2UueE6XEfTCc',
          PointLatLng(
              Provider.of<PobMapPro>(context, listen: false).plat!,
              Provider.of<PobMapPro>(context, listen: false)
                  .plong!), //Starting LATLANG
          PointLatLng(
              Provider.of<PobMapPro>(context, listen: false).dlat!,
              Provider.of<PobMapPro>(context, listen: false)
                  .dlong!), //End LATLANG
          travelMode: TravelMode.driving,
        )
        .then((value) {
      for (var point in value.points) {
        Provider.of<PobMapPro>(context, listen: false)
            .polylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      }
    }).then((value) {
      Provider.of<PobMapPro>(context, listen: false).loaded = true;
      Provider.of<PobMapPro>(context, listen: false).addPolyLine();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Provider.of<PobMapPro>(context, listen: false).clearAll();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: RouteManager.appclr,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: RouteManager.width / 60),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: const Color.fromARGB(255, 54, 226, 60),
                      size: RouteManager.width / 16,
                    ),
                    SizedBox(
                      width: RouteManager.width / 1.12,
                      child: Text(
                        "${Provider.of<PobMapPro>(context).pickupaddress!}asdkakdaksdjaksjdkadaksjhdkjakdjsadsakdsajkajsdkjadak akshd sakd k",
                        style: TextStyle(
                            color: const Color.fromARGB(255, 54, 226, 60),
                            fontWeight: FontWeight.bold,
                            fontSize: RouteManager.width / 25),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                SizedBox(height: RouteManager.width / 70),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: const Color.fromARGB(255, 255, 120, 110),
                      size: RouteManager.width / 16,
                    ),
                    SizedBox(
                      width: RouteManager.width / 1.12,
                      child: Text(
                        Provider.of<PobMapPro>(context).dropaddress!,
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 120, 110),
                            fontWeight: FontWeight.bold,
                            fontSize: RouteManager.width / 25),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                SizedBox(height: RouteManager.width / 40),
                SizedBox(
                  // color: Colors.red,
                  height: RouteManager.height / 1.19,
                  child: Stack(
                    children: [
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Provider.of<PobMapPro>(context, listen: false)
                                  .loaded
                              ? GoogleMap(
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: true,
                                  initialCameraPosition: Provider.of<PobMapPro>(
                                          context,
                                          listen: false)
                                      .initialcampos!,
                                  mapType: MapType.normal,
                                  zoomControlsEnabled: true,
                                  onMapCreated: (controller) =>
                                      _googleMapController = controller,
                                  markers: Provider.of<PobMapPro>(context,
                                          listen: false)
                                      .markers,
                                  polylines: Set<Polyline>.of(
                                      Provider.of<PobMapPro>(context,
                                              listen: false)
                                          .polylines
                                          .values),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                      Provider.of<PobMapPro>(context).ispob
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        API.showLoading("", context);
                                        API
                                            .respondToBooking(
                                          Provider.of<PobMapPro>(context,
                                                  listen: false)
                                              .bookid!,
                                          6,
                                          context,
                                        )
                                            .then(
                                          (value) {
                                            if (value) {
                                              for (int i = 0;
                                                  i <
                                                      Provider.of<CurrentJobsPro>(
                                                              context,
                                                              listen: false)
                                                          .jobs
                                                          .length;
                                                  i++) {
                                                if (Provider.of<CurrentJobsPro>(
                                                            context,
                                                            listen: false)
                                                        .jobs[i]
                                                        .bookid ==
                                                    Provider.of<PobMapPro>(
                                                            context,
                                                            listen: false)
                                                        .bookid) {
                                                  Provider.of<CurrentJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .jobs
                                                      .removeAt(i);
                                                  Provider.of<CurrentJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .notifyListenerz();
                                                }
                                              }
                                              // Provider.of<CurrentJobsPro>(context, listen: false).jobs.add(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index]);
                                              // Provider.of<PobMapPro>(context, listen: false).ispob = true;
                                              // Provider.of<PobMapPro>(context, listen: false).notifyListenerz();
                                            }
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            // Navigator.of(context).pushNamed(RouteManager.pobmappage);
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          RouteManager.width / 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius: BorderRadius.circular(
                                            RouteManager.width,
                                          ),
                                        ),
                                        child: Text(
                                          "Finish",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: RouteManager.width / 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        API.showLoading("", context);
                                        API
                                            .respondToBooking(
                                          Provider.of<PobMapPro>(context,
                                                  listen: false)
                                              .bookid!,
                                          9,
                                          context,
                                        )
                                            .then(
                                          (value) {
                                            if (value) {
                                              for (int i = 0;
                                                  i <
                                                      Provider.of<CurrentJobsPro>(
                                                              context,
                                                              listen: false)
                                                          .jobs
                                                          .length;
                                                  i++) {
                                                if (Provider.of<CurrentJobsPro>(
                                                            context,
                                                            listen: false)
                                                        .jobs[i]
                                                        .bookid ==
                                                    Provider.of<PobMapPro>(
                                                            context,
                                                            listen: false)
                                                        .bookid) {
                                                  Provider.of<CurrentJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .jobs[i]
                                                      .status = 9;
                                                  Provider.of<CurrentJobsPro>(
                                                          context,
                                                          listen: false)
                                                      .notifyListenerz();
                                                }
                                              }
                                              // Provider.of<CurrentJobsPro>(context, listen: false).jobs.add(Provider.of<CurrentJobsPro>(context, listen: false).jobs[index]);
                                              Provider.of<PobMapPro>(context,
                                                      listen: false)
                                                  .ispob = true;
                                              Provider.of<PobMapPro>(context,
                                                      listen: false)
                                                  .notifyListenerz();
                                            }
                                            // Navigator.of(context, rootNavigator: true).pop();
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            // Navigator.of(context).pushNamed(RouteManager.pobmappage);
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(
                                          RouteManager.width / 20,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            RouteManager.width,
                                          ),
                                        ),
                                        child: Text(
                                          "POB",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: RouteManager.width / 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

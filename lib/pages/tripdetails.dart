import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/providers/tripdetailspro.dart';
import '../Api & Routes/routes.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({super.key});

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
  late GoogleMapController _googleMapController;
  bool mapControllerInitialized = false;

  @override
  void dispose() {
    if (mapControllerInitialized) {
      _googleMapController.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }
  Future<void> fetchData()async {
    await getPoints();
  }
  Future<void> getPoints() async {
    await Provider.of<TripDetailsPro>(context, listen: false)
        .polylinePoints
        .getRouteBetweenCoordinates(
      'AIzaSyD7nCnza24yu8qP2q5B0o7y0Qg54oUdNE4',
      PointLatLng(
        Provider.of<TripDetailsPro>(context, listen: false).plat!,
        Provider.of<TripDetailsPro>(context, listen: false).plong!,
      ),
      PointLatLng(
        Provider.of<TripDetailsPro>(context, listen: false).dlat!,
        Provider.of<TripDetailsPro>(context, listen: false).dlong!,
      ),
      travelMode: TravelMode.driving,
    )
        .then((value) {
      for (var point in value.points) {
        Provider.of<TripDetailsPro>(context, listen: false)
            .polylineCoordinates
            .add(LatLng(point.latitude, point.longitude));
      }
    }).then((value) {
      Provider.of<TripDetailsPro>(context, listen: false).loaded = true;
      Provider.of<TripDetailsPro>(context, listen: false).addPolyLine();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final double? pickupLatitude =
        Provider.of<TripDetailsPro>(context, listen: false).plat;
    final double? pickupLongitude =
        Provider.of<TripDetailsPro>(context, listen: false).plong;
    final double? destinationLatitude =
        Provider.of<TripDetailsPro>(context, listen: false).dlat;
    final double? destinationLongitude =
        Provider.of<TripDetailsPro>(context, listen: false).dlong;

    return WillPopScope(
      onWillPop: () {
        Provider.of<TripDetailsPro>(context, listen: false).clearAll();
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xffFFB900),
            title: Row(
              children: [
                SizedBox(
                  width: RouteManager.width / 20,
                ),
                Icon(
                  Icons.local_taxi,
                  size: RouteManager.width / 8,
                  color: Colors.green,
                ),
                Text(
                  "  Job Details",
                  style: TextStyle(fontSize: RouteManager.width / 15),
                ),
              ],
            ),
            shadowColor: Colors.white,
          ),
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
                        Provider.of<TripDetailsPro>(context).pickupaddress!,
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
                        Provider.of<TripDetailsPro>(context).dropaddress!,
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
                  width: double.infinity,
                  height: RouteManager.width / 1.2,
                  child: StatefulBuilder(builder: (context, setState) {
                    return Provider.of<TripDetailsPro>(context, listen: false)
                        .loaded
                        ? GoogleMap(
                      zoomGesturesEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      minMaxZoomPreference:
                      MinMaxZoomPreference.unbounded,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          pickupLatitude!,
                          pickupLongitude!,
                        ),
                        zoom: 6,
                      ),
                      mapType: MapType.normal,
                      zoomControlsEnabled: true,
                      onMapCreated: (controller) {
                        _googleMapController = controller;
                      },
                      markers: <Marker>{
                        Marker(
                          markerId: const MarkerId('start'),
                          position: LatLng(
                            pickupLatitude,
                            pickupLongitude,
                          ),
                          icon: BitmapDescriptor.defaultMarker,
                        ),
                        Marker(
                          markerId: const MarkerId('end'),
                          position: LatLng(
                            destinationLatitude!,
                            destinationLongitude!,
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(3),
                        ),
                      },
                      polylines: <Polyline>{
                        Provider.of<TripDetailsPro>(context).routePolyline!,
                      },
                    )
                        : const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
                SizedBox(height: RouteManager.width / 20),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        RouteManager.width / 30,
                      ),
                      color: const Color(0xffFFFBE7),
                      border: Border.all(color: const Color(0xffFFB900)),
                    ),
                    width: RouteManager.width / 1.5,
                    height: RouteManager.width / 5,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            "Available Balance ${Provider.of<TripDetailsPro>(context).amount}\$",
                            style: TextStyle(
                              fontSize: RouteManager.width / 23,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.info,
                              color: Colors.white,
                              size: RouteManager.width / 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: RouteManager.width / 30,
                ),
                Text(
                  "Your Earnings",
                  style: TextStyle(
                    fontSize: RouteManager.width / 22,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Center(
                  child: Text(
                    "${Provider.of<TripDetailsPro>(context).amount} \$",
                    style: TextStyle(
                      fontSize: RouteManager.width / 18,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: RouteManager.width / 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Duration",
                          style: TextStyle(
                            fontSize: RouteManager.width / 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${Provider.of<TripDetailsPro>(context).duration!} Min",
                          style: TextStyle(
                            fontSize: RouteManager.width / 23,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Distance",
                          style: TextStyle(
                            fontSize: RouteManager.width / 16,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${Provider.of<TripDetailsPro>(context).distance!} mi",
                          style: TextStyle(
                            fontSize: RouteManager.width / 23,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: RouteManager.width / 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Date Requested",
                      style: TextStyle(
                        fontSize: RouteManager.width / 22,
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        String datetime =
                            "  ${Provider.of<TripDetailsPro>(context).datetime!.day}-${Provider.of<TripDetailsPro>(context).datetime!.month}-${Provider.of<TripDetailsPro>(context).datetime!.year}  ";
                        if (Provider.of<TripDetailsPro>(context)
                            .datetime!
                            .hour
                            .toString()
                            .length !=
                            2) {
                          datetime +=
                          "0${Provider.of<TripDetailsPro>(context).datetime!.hour}:";
                        } else {
                          datetime +=
                          "${Provider.of<TripDetailsPro>(context).datetime!.hour}:";
                        }
                        if (Provider.of<TripDetailsPro>(context)
                            .datetime!
                            .minute
                            .toString()
                            .length !=
                            2) {
                          datetime +=
                          "0${Provider.of<TripDetailsPro>(context).datetime!.minute}";
                        } else {
                          datetime +=
                              Provider.of<TripDetailsPro>(context).datetime!.minute.toString();
                        }
                        return Text(
                          datetime,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: RouteManager.width / 23,
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../Api & Routes/routes.dart';
import '../Entities/jobsobject.dart';

class TripDetailsPro with ChangeNotifier {
  String? pickupaddress;
  String? dropaddress;
  int? amount;
  String? duration;
  String? distance;
  String? vehicle_type;
  DateTime? datetime;
  double? plat;
  double? plong;
  double? dlat;
  double? dlong;
  CameraPosition? initialcampos = null;
  Set<Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  bool loaded = false;
  Polyline? routePolyline;
  addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    routePolyline = polyline;
  }

  void clearAll() {
    loaded = false;
    polylineCoordinates = [];
    polylines = {};
    polylinePoints = PolylinePoints();
    pickupaddress = dropaddress = amount = duration = distance = vehicle_type = datetime = plat = plong = dlat = dlong = initialcampos = null;
    markers = {};
    // notifyListeners();
  }

  notifyListenerz() {
    notifyListeners();
  }
}

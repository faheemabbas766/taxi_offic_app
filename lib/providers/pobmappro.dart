import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class PobMapPro with ChangeNotifier {
  int? bookid;
  bool ispob=false;
  String? pickupaddress;
  String? dropaddress;
  // int? amount;
  // String? duration;
  // String? distance;
  // String? vehicle_type;
  // DateTime? datetime;
  double? plat;
  double? plong;
  double? dlat;
  double? dlong;
  CameraPosition? initialcampos;
  Set<Marker> markers = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  bool loaded = false;

  addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
  }

  void clearAll() {
    loaded = false;
    polylineCoordinates = [];
    polylines = {};
    polylinePoints = PolylinePoints();
    pickupaddress = dropaddress = plat = plong = dlat = dlong = initialcampos = null;
    markers = {};
    // notifyListeners();
  }

  notifyListenerz() {
    notifyListeners();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:powernet/app/clases/cConfig_UI.dart';

import '/app/models/var_global.dart' as global;
import '../../../models/share_preferences.dart';

const LatLng SOURCE_LOCATION = LatLng(-0.2587083, -79.1639749);
const LatLng DEST_LOCATION = LatLng(-0.2541316, -79.1548787);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;
String origen1 = '-0.2587083, -79.1639749';
String destino2 = '-0.2541316, -79.1548787';

class MapPage extends StatefulWidget {
  //SubCategory? subCategory;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  double pinPillPosition = PIN_VISIBLE_POSITION;
  late LatLng currentLocation = SOURCE_LOCATION;
  late LatLng destinationLocation;
  bool userBadgeSelected = false;
  late PolylinePoints polylinePoints;

  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();
  Set<Polygon> _polygon = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  Set<Polyline> _polylines = Set<Polyline>();

  @override
  void initState() {
    super.initState();
    print('ESTE ESTA RARO' + global.latdir + ',' + global.lngdir);
    print('ESTE ESTA RARissimo LNG' +
        Preferences.LatClient +
        ',' +
        Preferences.LngClient);

    //_setDefaultMarker(currentLocation);
    polylinePoints = PolylinePoints();

    // set up initial locations
    this.setInitialLocation();
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    return Scaffold(
        appBar: AppBar(
          title:
              Text('Google Maps', style: TextStyle(color: ColorFondo.BLANCO)),
        ),
        body: Column(children: [
          Expanded(
              child: GoogleMap(
            myLocationEnabled: true,
            compassEnabled: false,
            tiltGesturesEnabled: true,
            markers: markers,
            polygons: _polygon,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          )),
        ]));
  }
}

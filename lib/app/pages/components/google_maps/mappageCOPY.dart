import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../api/externas/api_polyline.dart';
import '../../../clases/cConfig_UI.dart';
import '../../../models/share_preferences.dart';

//import 'package:orilla_fresca_app/helpers/utils.dart';
//import 'package:orilla_fresca_app/models/subcategory.dart';
//import 'package:orilla_fresca_app/services/categoryselectionservice.dart';
//import 'package:orilla_fresca_app/widgets/mainappbar.dart';
//import 'package:orilla_fresca_app/widgets/mapbottompill.dart';
//import 'package:orilla_fresca_app/widgets/mapuserbadge.dart';

const LatLng SOURCE_LOCATION = LatLng(-0.2587083, -79.1639749);
const LatLng DEST_LOCATION = LatLng(-0.2541316, -79.1548787);
const double CAMERA_ZOOM = 12;
const double CAMERA_TILT = 20;
const double CAMERA_BEARING = 12;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;
String origen1 = '-0.2587083, -79.1639749';
String destino2 = '-0.2541316, -79.1548787';

class MapPage2 extends StatefulWidget {
  //SubCategory? subCategory;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage2> {
  TextEditingController _origen = TextEditingController();
  TextEditingController _destino = TextEditingController();

  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  double pinPillPosition = PIN_VISIBLE_POSITION;
  late LatLng currentLocation = SOURCE_LOCATION;
  late LatLng destinationLocation;
  bool userBadgeSelected = false;
  late PolylinePoints polylinePoints;

  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygon = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineCounter = 1;

  Set<Polyline> _polylines = Set<Polyline>();
  //List<LatLng> polylineCoordinates = [];
  //late PolylinePoints polylinePoints;

  @override
  void initState() {
    super.initState();

    _init();

    _setDefaultMarker(currentLocation);
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

  void _setDefaultMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(
        markerId: const MarkerId('marker'),
        position: point,
      ));
    });
  }

  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygon.add(
      Polygon(
          polygonId: PolygonId(polygonIdVal),
          points: polygonLatLngs,
          strokeWidth: 2,
          fillColor: Colors.transparent),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylinenIdVal = 'polyline_$_polylineCounter';
    _polylineCounter++;
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylinenIdVal),
        width: 2,
        color: Colors.blue,
        points: points
            .map(
              (point) => LatLng(point.latitude, point.longitude),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: 11,
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
            markers: _markers,
            polygons: _polygon,
            polylines: _polylines,
            mapType: MapType.normal,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              setPolylines();
            },
            /* ESTE MATA EL CLIC EN EL MAPA
                onTap: (point) {
                  setState(() {
                    _setPolygon();
                  });
                  
                }),*/
          )),
        ]));
  }

  Future<void> _init() async {
    List<String> coordenadas = [''];
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
    );
    StreamSubscription<Position> postInicial =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');
      if (position != null) {
        setState(() {
          /*List<String> coorLat = [''];
        List<String> coorLng = [''];
        coordenadas = posi.split(',');
        if (coordenadas.first != '') {
          coorLat = (coordenadas.first).split(': ');
          coorLng = (coordenadas.last).split(': ');
        }*/
          /* Preferences.LATMOT = position.latitude.toString();
          Preferences.LngMot = position.longitude.toString(); */
        });
        var directions = await location().getDirections(
            (position.latitude.toString() +
                ',' +
                position.longitude.toString()),
            '${Preferences.LatClient.toString()},${Preferences.LngClient.toString()}');
        _goPlace(
          directions['start_location']['lat'],
          directions['start_location']['lng'],
        );
        _setPolyline(directions['polyline_decoded']);
        print('ESTE ES EL VALOR 1::' + Preferences.LatClient);
        print('ESTE ES EL VALOR 2::' + Preferences.LngClient);

        //
        //
        //_setPolyline(directions['']);
      }
    });
    //final postInicial = await Geolocator.getPositionStream();

    // final String posi = postInicial.toString();
  }

  Future<void> _goPlace(double lat, double lng) async {
    //final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 13.5),
    ));
    _setDefaultMarker(LatLng(lat, lng));
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        'apiKey',
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude));

    if (result.status == 200) {
      result.points.forEach((PointLatLng point) {
        /* polylineCoordinates.add(LatLng(point.latitude, point.longitude));*/
      });

      setState(() {
        /* _polylines.add(Polyline(
            width: 10,
            polylineId: PolylineId('polyLine'),
            color: Color.fromARGB(255, 203, 8, 8),
            points: polylineCoordinates));*/
      });
    } else {
      print('holaerrorF');
    }
  }
}

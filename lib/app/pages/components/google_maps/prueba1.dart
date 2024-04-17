import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../clases/cConfig_UI.dart';
import '/app/models/var_global.dart' as global;
import '../../../api/internas/public/api_tracking.dart';
//import '../../../api/internas/public/api_enviar_ubicacion.dart';
import '../../../models/share_preferences.dart';
import 'helpers/asset-to-bytes.dart';

//LatLng SOURCE_LOCATION = LatLng(global.trac_lat, global.trac_lng);
LatLng SOURCE_LOCATION = LatLng(double.parse(Preferences.LatClient), double.parse(Preferences.LngClient));
//LatLng SOURCE_LOCATION = LatLng(-0.2541316, -79.1548787);
const LatLng DEST_LOCATION = LatLng(-0.2541316, -79.1548787);
const double CAMERA_ZOOM = 14;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;
String origen1 = '-0.2587083, -79.1639749';
String destino2 = '-0.2541316, -79.1548787';

class MapPage3 extends StatefulWidget {
  //SubCategory? subCategory;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage3> {
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

  final Map<MarkerId, Marker> _markers = {};
  Set<Marker> get markers => _markers.values.toSet();
  Set<Polygon> _polygon = Set<Polygon>();
  List<LatLng> polygonLatLngs = <LatLng>[];

  int _polygonIdCounter = 1;
  int _polylineCounter = 1;

  Set<Polyline> _polylines = Set<Polyline>();
  late Future<dynamic> enviarUbi;
  Timer? miTimer;

  @override
  void initState() {
    super.initState();
    _init();
    Timer miTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      postTrackin('Preferences.id_moto_ubi').then((_) {
        datosTRACKING.then((value) {
          if (value['success'] == 'OK') {
            Preferences.logueado = true;
            print('hi mi friend');
            if (mounted) {
              setState(() {
                print('si ingrese setstate');
                print(global.trac_lat);
                print(global.trac_lng);
                global.trac_lat = double.parse(value['data'][0]['latitud']);
                global.trac_lng = double.parse(value['data'][0]['longitud']);
              });
            }
            // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
          }
        });
      });
      print(global.trac_lat);
      print(global.trac_lng);
      print('ESTOY REPITIENDO ESTO CADA 6 SEGUNDOS');
    });

    //  _setDefaultMarker(currentLocation);
    polylinePoints = PolylinePoints();

    // set up initial locations
    this.setInitialLocation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    miTimer?.cancel();
    super.dispose();
  }

  void setInitialLocation() {
    currentLocation = LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);

    destinationLocation = LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  /*void _setDefaultMarker(LatLng point) {
    if (mounted) {
      return setState(() {
        _markers.add(Marker(
          markerId: const MarkerId('marker'),
          position: point,
        ));
      });
    }
  }
*/
  void _setPolygon() {
    final String polygonIdVal = 'polygon_$_polygonIdCounter';
    _polygonIdCounter++;

    _polygon.add(
      Polygon(polygonId: PolygonId(polygonIdVal), points: polygonLatLngs, strokeWidth: 2, fillColor: Color.fromARGB(255, 217, 23, 23)),
    );
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylinenIdVal = 'polyline_$_polylineCounter';
    _polylineCounter++;
    _polylines.add(
      Polyline(
        polylineId: PolylineId(polylinenIdVal),
        width: 3,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        color: ColorFondo.BTNUBI,
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
    CameraPosition initialCameraPosition = CameraPosition(zoom: CAMERA_ZOOM, tilt: CAMERA_TILT, bearing: CAMERA_BEARING, target: SOURCE_LOCATION);

    return Scaffold(
        appBar: AppBar(
          title: Text('Google Maps'),
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
              // setPolylines();
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

  GoogleMapController? _mapController;
  late BitmapDescriptor _carpin;
  late BitmapDescriptor _carpinclient;
  void _setMyPositionMarker() {
    const MarkerId markerId = MarkerId('my-position');
    final marker = Marker(markerId: markerId, position: LatLng(double.parse(Preferences.LatClient), double.parse(Preferences.LngClient)), icon: _carpinclient);
    _markers[markerId] = marker;
  }

  void _setMyPositionMarkerclient() {
    const MarkerId markerIdMot = MarkerId('my-ñjjh');
    final marker = Marker(markerId: markerIdMot, position: LatLng(global.trac_lat, global.trac_lng), icon: _carpin);
    _markers[markerIdMot] = marker;
  }

  late Timer miTimer2;
  Future<void> _init() async {
    _carpin = BitmapDescriptor.fromBytes(await imageToBytes('assets/images/marEnkador.png', width: 80, heigh: 140));
    _carpinclient = BitmapDescriptor.fromBytes(await imageToBytes('assets/images/icon_user.png', width: 140, heigh: 200));

    List<String> coordenadas = [''];

    final postInicial = await Geolocator.getCurrentPosition();
    final String posi = postInicial.toString();
    if (postInicial != '') {
      setState(() {
        List<String> coorLat = [''];
        List<String> coorLng = [''];
        coordenadas = posi.split(',');
        if (coordenadas.first != '') {
          coorLat = (coordenadas.first).split(': ');
          coorLng = (coordenadas.last).split(': ');
        }

        _setMyPositionMarker();
        print('antes de timer');

        miTimer2 = Timer.periodic(Duration(seconds: 2), (timer) {
          _setMyPositionMarkerclient();
          print('ESTOY REPITIENDO LATLNG CLIENT');
        });
        //Preferences.LATMOT = coorLat.last;
        //  Preferences.LngMot = coorLng.last;

        print('Estoy por aquiii ${coorLat.last}');
        print('Estoy por fueraAAA ${coorLng.last}');
        //_postEnviarUbicacion.call();
      });

      //
      //
      //_setPolyline(directions['']);

    }
    //final String det0 = Preferences.LatClient.toString() + ',' + Preferences.LngClient.toString();
    // print('ESTE ESTA RARO' + det0);
    /*var directions =
        await location().getDirections((Preferences.LatClient.toString() + ',' + Preferences.LngClient.toString()), (Preferences.LATMOT + ',' + Preferences.LngMot));
    _goPlace(
      directions['start_location']['lat'],
      directions['start_location']['lng'],
    );
    _setPolyline(directions['polyline_decoded']);
  }*/

    Future<void> _goPlace(double lat, double lng) async {
      //final double lat = place['geometry']['location']['lat'];
      // final double lng = place['geometry']['location']['lng'];
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 18.5),
      ));
      // _setDefaultMarker(LatLng(lat, lng));
    }

    void setPolylines() async {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          'apiKey', PointLatLng(currentLocation.latitude, currentLocation.longitude), PointLatLng(destinationLocation.latitude, destinationLocation.longitude));

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
}

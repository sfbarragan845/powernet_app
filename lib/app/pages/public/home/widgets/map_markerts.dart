import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../models/share_preferences.dart';
import '../../../../models/var_global.dart' as global;
import '../../../../providers/internet_provider.dart';
import '../../../components/google_maps/helpers/asset-to-bytes.dart';

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
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor _powerMarker;

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
  double pinPillPosition = PIN_VISIBLE_POSITION;
  late LatLng currentLocation = SOURCE_LOCATION;
  late LatLng destinationLocation;
  bool userBadgeSelected = false;
  late PolylinePoints polylinePoints;
  List<Marker> markerss = [];
  List<LatLng> polygonLatLngs = <LatLng>[];

  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  @override
  void initState() {
    inicialize();
    super.initState();
    _init();
    this.setInitialLocation();
  }

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  inicialize() async {
    _powerMarker = BitmapDescriptor.fromBytes(await imageToBytes(
        'assets/images/marker_powernet.png',
        width: 60,
        heigh: 120));

    for (var i = 0; i < global.iteMap.length; i++) {
      if (mounted)
        setState(() {
          markerss.add(Marker(
            anchor: Offset(1, 1),
              //infoWindow: InfoWindow.noText,
              markerId: MarkerId(global.iteMap[i].toString()),
              position: LatLng(double.parse(global.latitudMap[i]),
                  double.parse(global.longitudMap[i])),
              onTap: () async {
                _customInfoWindowController.addInfoWindow!(
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    child: global.titleMap[i] == 'INSTALACIÓN'
                                        ? SvgPicture.asset(
                                            'assets/images/instalaciones.svg',
                                            fit: BoxFit.fill)
                                        : global.titleMap[i] == 'SOPORTES'
                                            ? SvgPicture.asset(
                                                'assets/images/totalsoporte.svg',
                                                fit: BoxFit.fill)
                                            : global.titleMap[i] == 'MIGRACIÓN'
                                                ? SvgPicture.asset(
                                                    'assets/images/migracion.svg',
                                                    fit: BoxFit.fill)
                                                : SvgPicture.asset(
                                                    'assets/images/traslados.svg',
                                                    fit: BoxFit.fill),
                                  ),
                                  SizedBox(
                                    width: 8.0,
                                  ),
                                  Text("${global.titleMap[i]}",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  
                                ],
                              ),
                              Container(
                                //decoration: BoxDecoration(color:global.prioridadMap[i]=='ALTA'?Colors.red:global.prioridadMap[i]=='BAJA':Colors.green:Colors.orange ),
                                child: Text('Prioridad: ${global.prioridadMap[i]}'))
                            ],
                          ),
                        ),
                        width: 500,
                        //height: 100,
                      ),
                    ],
                  ),
                  LatLng(double.parse(global.latitudMap[i]),
                      double.parse(global.longitudMap[i])),
                );
              },
              icon: _powerMarker));
        });

      print('mis ubicacionessssss :' + global.iteMap[i]);
      print('mis ubicacionessssss :' + global.titleMap[i]);
    }
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);
    print('aqui');
    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: Preferences.ubiNavLat != '' && Preferences.ubiNavLng != ''
            ? LatLng(double.parse(Preferences.ubiNavLat),
                double.parse(Preferences.ubiNavLng))
            : LatLng(-0.2550133813356288, -79.16956800643958));
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    final conexion = Provider.of<InternetProvider>(context);
    return BlocProvider(
        create: (_) => InternetProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('Google Maps',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
              // tooltip: 'Regresar',
            ),
          ),
          body: Stack(
            children: [
              Center(
                child: Container(
                  width: vwidth,
                  height: vheight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>[
                            new Factory<OneSequenceGestureRecognizer>(
                              () => new EagerGestureRecognizer(),
                            ),
                          ].toSet(),
                          myLocationEnabled: true,
                          compassEnabled: false,
                          tiltGesturesEnabled: true,
                          markers: Set<Marker>.of(markerss),
                          mapType: MapType.normal,
                          initialCameraPosition: initialCameraPosition,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                            _customInfoWindowController.googleMapController =
                                controller;
                          },
                          onTap: (position) {
                            _customInfoWindowController.hideInfoWindow!();
                          },
                          onCameraMove: (position) {
                            _customInfoWindowController.onCameraMove!();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomInfoWindow(
                controller: _customInfoWindowController,
                height: 75,
                width: 150,
                offset: 50,
              ),
            ],
          ),
        ));
  }

  Future<void> _init() async {
    List<String> coordenadas = [''];
    //ESTO AUMENTO
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2,
    );
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');

      if (position != null) {
        if (mounted) {
          setState(() {
            Preferences.LngMot = position.longitude.toString();
          });
        }
      }
      final postInicial = await Geolocator.getCurrentPosition();
      final String posi = postInicial.toString();
      if (postInicial != '') {
        if (mounted) {
          setState(() {
            List<String> coorLat = [''];
            List<String> coorLng = [''];
            coordenadas = posi.split(',');
            if (coordenadas.first != '') {
              coorLat = (coordenadas.first).split(': ');
              coorLng = (coordenadas.last).split(': ');
            }
            Preferences.ubiNavLat = coorLat.last;
            Preferences.ubiNavLng = coorLng.last;
          });
        }
      }
    });
  }
}

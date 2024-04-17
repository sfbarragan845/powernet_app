import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import '../../../../clases/cConfig_UI.dart';
import '/app/models/var_global.dart' as globals;
import 'package:permission_handler/permission_handler.dart';

class UbicacionClienteScreen extends StatefulWidget {
  const UbicacionClienteScreen({Key? key}) : super(key: key);
  @override
  State<UbicacionClienteScreen> createState() => UbicacionClienteScreenState();
}

class UbicacionClienteScreenState extends State<UbicacionClienteScreen> {
  Completer<GoogleMapController> _controller = Completer();
  late bool serviceEnabled;
  late LocationPermission permission;
  
  
  List<Marker> myMarker = [];
  String imagen = 'assets/icons/ubicacion.png';

  Future<Uint8List> getImages(String path, int width) async{
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return(await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  loadData() async{
    final Uint8List markIcons = await getImages(imagen, 200);
    myMarker.add(
      Marker(
          // given marker id
          markerId: MarkerId('0'),
          // given marker icon
          icon: BitmapDescriptor.fromBytes(markIcons),
          // given position
          position: LatLng(double.parse(globals.latitudDetSoporte), double.parse(globals.longitudDetSoporte)),
          infoWindow: InfoWindow(
            // given title for marker
            title:globals.clienteDetSoporte,
          ),
        )
    );
    setState(() {
      });
  }

  @override
  void initState() {
    super.initState();
    //_setMyPositionMarker();
    //_setMyPositionMarkerclient();
    loadData();
      //marcadores();
  }
GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubicación '+ globals.clienteDetSoporte),
      ),
      body:
      /* Column(
        children: [
          Expanded(
            child: Container(
              width: 400,
              height: 715,
              child: GoogleMap(
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: Set<Marker>.of(myMarker),
                initialCameraPosition: CameraPosition(target: LatLng(-0.244455, -79.154411), zoom: 16.5),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          )
        ],
      ), */
      Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
                    new Factory<OneSequenceGestureRecognizer>(
                      () => new EagerGestureRecognizer(),
                    ),
                  ].toSet(),
                  mapType: MapType.normal,
                  markers:  Set<Marker>.of(myMarker),
                  //    polygons: _polygons,
                  // polylines: _polylines,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(globals.latitudDetSoporte), double.parse(globals.longitudDetSoporte)),
                    zoom: 17,
                  ),
                  onMapCreated: (GoogleMapController controller) async {
                    mapController = controller;
                  },
                  onTap: (point) {
                    null;
                  },
                ),
                // showing the route
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                      child: ClipOval(
                        child: Material(
                          color: ColorFondo.PRIMARY, // button color
                          child: InkWell(
                            splashColor: const Color.fromARGB(
                                255, 52, 147, 206), // inkwell color
                            child: const SizedBox(
                              width: 56,
                              height: 56,
                              child: Icon(
                                Icons.location_history,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                        double.parse(globals.latitudDetSoporte), double.parse(globals.longitudDetSoporte)),
                                    zoom: 18.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      );
  }
}

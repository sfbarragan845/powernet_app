// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_maps/services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../clases/cConfig_UI.dart';
import '../../../clases/cParametros.dart';
import '../../../models/var_global.dart' as globals;

class GoogleMaps extends StatefulWidget {
  final double longitud;
  final double latitud;
  final bool agregaCliente;

  const GoogleMaps(
      {required this.longitud,
      required this.latitud,
      required this.agregaCliente,
      Key? key})
      : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const GoogleMaps(
        latitud: 0,
        longitud: 0,
        agregaCliente: false,
      ),
    );
  }

  @override
  MapSampleState createState() =>
      // ignore: no_logic_in_create_state
      MapSampleState(
          latitud: latitud, longitud: longitud, agregaCliente: agregaCliente);
}

class MapSampleState extends State<GoogleMaps> {
  final double longitud;
  final double latitud;
  final bool agregaCliente;
  MapSampleState(
      {required this.longitud,
      required this.latitud,
      required this.agregaCliente});

  GoogleMapController? mapController;
  Position? _currentPosition;

  final Set<Marker> _markers = <Marker>{};
  final Set<Polygon> _polygons = <Polygon>{};
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polygonLatLngs = <LatLng>[];

  double parLongitud = 0;
  double parLatitud = 0;

  @override
  void initState() {
    _getCurrentLocation();
    if (!agregaCliente) {
      if (latitud != latitudCuenca && longitud != longitudCuenca) {
        _setDefaultMarker(LatLng(latitud, longitud));
      }
    }
    super.initState();
  }

  void _setDefaultMarker(LatLng point) {
    print('Agrega cliente es: $agregaCliente');
    setState(() {
      _markers.add(
        Marker(
            markerId: const MarkerId('marker'),
            position: point,
            infoWindow: InfoWindow(
                title: globals.nombreCliente, snippet: '$latitud, $longitud')),
      );
    });
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        // Store the position in the variable
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        // For moving the camera to current location
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      // await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text('Ubicación', style: TextStyle(color: ColorFondo.BLANCO)),
        leading: IconButton(
          tooltip: 'Regresar',
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.pop(context, ''),
        ),
      ),
      body: Column(
        children: [
          latitud == latitudCuenca && !agregaCliente
              ? Column(children: const [
                  Divider(),
                  Center(
                    child: Text(
                      'No existe la ubicación para el cliente actual',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(),
                ])
              : Container(),
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  markers: _markers,
                  polygons: _polygons,
                  polylines: _polylines,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(latitud, longitud),
                    zoom: 16.9,
                  ),
                  onMapCreated: (GoogleMapController controller) async {
                    mapController = controller;
                    if (agregaCliente) {
                      await _getCurrentLocation();
                    }
                  },
                  onTap: (point) {
                    if (agregaCliente) {
                      setState(() {
                        parLatitud = point.latitude;
                        parLongitud = point.longitude;
                        _markers.add(
                          Marker(
                              markerId: const MarkerId('marker'),
                              position: point,
                              visible: true,
                              draggable: true,
                              flat: false,
                              infoWindow: InfoWindow(
                                  title: agregaCliente
                                      ? 'Coordenadas'
                                      : globals.nombreCliente,
                                  snippet:
                                      '${point.latitude}, ${point.longitude}')),
                        );
                        // polygonLatLngs.add(point);
                        // _setPolygons();
                      });
                    }
                  },
                ),
                // showing the route
                agregaCliente
                    ? SafeArea(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                              width: width * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Seleccionar ubicación',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    const SizedBox(height: 10),
                                    agregaCliente
                                        ? const Text(
                                            'Presione en el mapa para ubicar al cliente',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : Text(
                                            'Cliente: ${globals.nombreCliente}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                    // const SizedBox(height: 5),
                                    // Text('Latitud: $parLatitud'),
                                    // const SizedBox(height: 5),
                                    // Text('Longitud: $parLongitud'),
                                    const SizedBox(height: 5),
                                    ElevatedButton(
                                      onPressed: (parLongitud != 0 &&
                                              parLatitud != 0)
                                          ? () {
                                              parLatitud != 0 &&
                                                      parLongitud != 0
                                                  ? Navigator.pop(context,
                                                      '$parLatitud|$parLongitud')
                                                  : Navigator.pop(context, '');
                                            }
                                          : null,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Seleccionar'.toUpperCase(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                // Botones zoom
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Material(
                            color: ColorFondo.PRIMARY,
                            child: InkWell(
                              splashColor:
                                  const Color.fromARGB(255, 52, 147, 206),
                              child: const SizedBox(
                                width: 50,
                                height: 50,
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                mapController?.animateCamera(
                                  CameraUpdate.zoomIn(),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        ClipOval(
                          child: Material(
                            color: ColorFondo.PRIMARY,
                            child: InkWell(
                              splashColor:
                                  const Color.fromARGB(255, 52, 147, 206),
                              child: const SizedBox(
                                width: 56,
                                height: 56,
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                mapController?.animateCamera(
                                  CameraUpdate.zoomOut(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Ubicación actual
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomRight,
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
                                Icons.my_location,
                                // size: 36,
                                color: Colors.white,
                              ),
                            ),
                            onTap: () async {
                              await _getCurrentLocation();
                              mapController?.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: LatLng(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                    ),
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
                ),
                // Ir a ubicación del cliente
                (!agregaCliente &&
                            latitud != latitudCuenca &&
                            longitud != longitudCuenca) ||
                        (parLongitud != 0 && parLatitud != 0)
                    ? SafeArea(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 70.0, bottom: 10.0),
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
                                          target: agregaCliente
                                              ? LatLng(parLatitud, parLongitud)
                                              : LatLng(
                                                  latitud,
                                                  longitud,
                                                ),
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
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // // Future<void> _goToPlace(
  // //   double lat,
  // //   double lng,
  // //   Map<String, dynamic> boundsNe,
  // //   Map<String, dynamic> boundsSw,
  // // ) async {
  // //   final GoogleMapController controller = await _controller.future;
  // //   controller.animateCamera(
  // //     CameraUpdate.newCameraPosition(
  // //       CameraPosition(target: LatLng(lat, lng), zoom: 14.667),
  // //     ),
  // //   );

  // //   controller.animateCamera(
  // //     CameraUpdate.newLatLngBounds(
  // //         LatLngBounds(
  // //           southwest: LatLng(boundsSw['lat'], boundsSw['lng']),
  // //           northeast: LatLng(boundsNe['lat'], boundsNe['lng']),
  // //         ),
  // //         30),
  // //   );
  // //   _setDefaultMarker(LatLng(lat, lng));
  // // }
}

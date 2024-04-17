// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:google_maps/services/location_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

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
//Search Place
  var _controller = TextEditingController();
  var uuid = new Uuid();
  String _sessionToken = '1234567890';
  List<dynamic> _placeList = [];

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

    _controller.addListener(() {
      _onChanged();
    });
  }

  _onChanged() {
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = "AIzaSyCwLKWgJGk6_9FesKvtdmSOsJvnaLR9Vgw";
    String type = 'country:ec';

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request =
          '$baseURL?&components=$type&input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      print('mydata');
      print(data);
      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      // toastMessage('success');
    }
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

  Widget _txtSearch() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Busca una Ubicación aqui",
              focusColor: Color.fromARGB(255, 99, 24, 24),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              prefixIcon: Icon(Icons.map),
              suffixIcon: IconButton(
                icon: Icon(Icons.cancel),
                onPressed: () {
                  _controller.clear();
                },
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            final FocusScopeNode focus = FocusScope.of(context);
            if (!focus.hasPrimaryFocus && focus.hasFocus) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: Row(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _placeList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(
                            _placeList[index]["description"]);
                        print('Aqui latitudddd' + '${locations.last.latitude}');
                        print(
                            'Aqui longitudddd' + '${locations.last.longitude}');
                        mapController?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: agregaCliente
                                  ? LatLng(locations.last.latitude,
                                      locations.last.longitude)
                                  : LatLng(
                                      latitud,
                                      longitud,
                                    ),
                              zoom: 18.0,
                            ),
                          ),
                        );
                        _controller.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: ListTile(
                        title: Text(_placeList[index]["description"]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var vheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //leading: Icon(Icons.arrow_back_ios),
        title:
            const Text('Ubicación', style: TextStyle(color: ColorFondo.BLANCO)),
        leading: IconButton(
          tooltip: 'Regresar',
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.pop(context, ''),
        ),
      ),
      body: SizedBox(
        height: vheight * 2,
        child: Column(
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
                      ? SingleChildScrollView(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(246, 255, 255, 255),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                    width: width * 0.95,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Text(
                                                'Buscar o Seleccionar ubicación',
                                                style:
                                                    TextStyle(fontSize: 20.0),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.info,
                                                  color: ColorFondo.PRIMARY,
                                                  size: 35,
                                                ),
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Busque su ubicación y para concluir el proceso marque en el mapa la direccion exacta.",
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Color.fromARGB(239,
                                                              81, 193, 233),
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      textColor: Colors.black);
                                                  _controller.clear();
                                                },
                                              ),
                                            ],
                                          ),
                                          _txtSearch(),

                                          /// AQUI agreagar butoom search
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
                                                        : Navigator.pop(
                                                            context, '');
                                                  }
                                                : null,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                ],
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
                        padding:
                            const EdgeInsets.only(right: 10.0, bottom: 10.0),
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
                                                ? LatLng(
                                                    parLatitud, parLongitud)
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
      ),
    );
  }
}

// // ignore_for_file: avoid_print

// import 'package:flutter/material.dart';
// import '../../../clases/cParametros.dart';
// import '/app/clases/cGoogleKey.dart';
// import 'google_maps_place_picker.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GoogleUbicacion extends StatefulWidget {
//   // const HomePage({Key key}) : super(key: key);
//   final double longitud;
//   final double latitud;

//   //static const kInitialPosition = LatLng(latitud, longitud);

//   const GoogleUbicacion(
//       {required this.longitud, required this.latitud, Key? key})
//       : super(key: key);

//   @override
//   _GoogleUbicacionState createState() =>
//       // ignore: no_logic_in_create_state
//       _GoogleUbicacionState(latitud: latitud, longitud: longitud);
// }

// class _GoogleUbicacionState extends State<GoogleUbicacion> {
//   late PickResult selectedPlace;
//   final double longitud;
//   final double latitud;
//   _GoogleUbicacionState({required this.longitud, required this.latitud});

//   @override
//   void initState() {
//     print('Latitud: $latitud, longitud: $longitud');
//     if (latitud != latitudCuenca && longitud != longitudCuenca) {
//       _setDefaultMarker(LatLng(latitud, longitud));
//     }
//     super.initState();
//   }

//   final Set<Marker> _markers = <Marker>{};

//   void _setDefaultMarker(LatLng point) {
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('marker'),
//           position: point,
//         ),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Google Map Place Picer Demo"),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               ElevatedButton(
//                 child: const Text("Cargar el Mapa de Google"),
//                 onPressed: () {
//                   Navigator.push(context, MaterialPageRoute(
//                     builder: (context) {
//                       return PlacePicker(
//                         latitud: latitud,
//                         longitud: longitud,
//                         apiKey: apiKey,
//                         initialPosition: LatLng(latitud, longitud),
//                         useCurrentLocation: true,
//                         selectInitialPosition: true,
//                         //usePlaceDetailSearch: true,
//                         onPlacePicked: (result) {
//                           //     selectedPlace = result;
//                           Navigator.of(context).pop();
//                           setState(() {});
//                         },
//                       );
//                     },
//                   ));
//                 },
//               ),
//               //  selectedPlace == null
//               //       ? Container()
//               //       : Text(selectedPlace.formattedAddress ?? ""),
//             ],
//           ),
//         ));
//   }
// }

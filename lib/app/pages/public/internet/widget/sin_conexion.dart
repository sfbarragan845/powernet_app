// // ignore_for_file: camel_case_types

// import 'package:flutter/material.dart';

// class sinConexion extends StatefulWidget {
//   const sinConexion({Key? key}) : super(key: key);

//   @override
//   State<sinConexion> createState() => _sinConexionState();
// }

// class _sinConexionState extends State<sinConexion> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Sin conexión'),
//           leading: IconButton(
//             tooltip: 'Regresar',
//             icon: const Icon(Icons.arrow_back_ios_outlined),
//             onPressed: () => Navigator.pop(context, ''),
//           ),
//         ),
//         body: Center(
//             child: Column(
//           children: const [
//             Image(image: AssetImage('assets/images/sin_conexion.gif')),
//             Text(
//               'Error',
//               style: TextStyle(
//                   fontSize: 36, fontWeight: FontWeight.w700, color: Colors.red),
//             ),
//             Text(
//               'Sin conexión a internet',
//               style: TextStyle(
//                 fontSize: 26,
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ],
//         )));
//   }
// }

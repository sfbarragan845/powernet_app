// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

Widget widget_sinConexion() {
  return Center(
      child: Column(
    children: const [
      Image(image: AssetImage('assets/images/sin_conexion.gif')),
      Text(
        'Error',
        style: TextStyle(
            fontSize: 36, fontWeight: FontWeight.w700, color: Colors.red),
      ),
      Text(
        'Sin conexión a internet',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w300,
        ),
      ),
    ],
  ));
}

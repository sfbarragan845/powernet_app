import 'package:flutter/material.dart';
import '../../clases/cConfig_UI.dart';

Widget sinConexion() {
  return ElevatedButton(
      onPressed: () {},
      child: const Text(
        'Sin conexión',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(190, 40), backgroundColor: ColorFondo.SECONDARY,
        shape: const StadiumBorder(),
      ));
}

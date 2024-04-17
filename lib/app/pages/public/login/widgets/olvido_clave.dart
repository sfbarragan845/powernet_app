import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../recuperar_clave/screens/paso1.dart';

Widget olvidoContrasena(BuildContext context) {
  return Text.rich(
    TextSpan(children: [
      TextSpan(
        text: "¿Se te olvidó tu contraseña?",
        style: const TextStyle(color: ColorFondo.PRIMARY, fontSize: 14, fontWeight: FontWeight.bold),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecuperarClave1()),
            );
          },
      ),
    ]),
  );
}

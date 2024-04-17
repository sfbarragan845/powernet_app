import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../terminos/screens/terminosCondicionesScreen.dart';

Widget terminosYCondiciones(BuildContext context) {
  return Text.rich(
    TextSpan(
        text: "Al iniciar sesión, acepta los ",
        style: const TextStyle(
            //color: Theme.of(context).primaryColor.withOpacity(0.8),
            color: Colors.white,
            fontSize: 12),
        children: [
          TextSpan(
            text: "términos y condiciones",
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TerminosCondiciones()),
                );
              },
          ),
        ]),
  );
}

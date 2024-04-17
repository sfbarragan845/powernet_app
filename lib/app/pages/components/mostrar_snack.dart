import 'package:flutter/material.dart';
import '../../clases/cConfig_UI.dart';

mostrarError(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(
    content: Text(
      mensaje,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red[600],
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

mostrarErrorHora(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(
    content: Container(
      height: 20,
      child: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.red[600],
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

mostrarErrorMSG(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(
    content: Container(
      height: 30,
      child: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.red[600],
  );

  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

mostrarCorrecto(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(
    content: Text(
      mensaje,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

mostrarCorrecUbi(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(
    content: Text(
      mensaje,
      style: TextStyle(color: Colors.white, fontSize: 15),
      textAlign: TextAlign.center,
    ),
    backgroundColor: ColorFondo.PRIMARY,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

mostrarCorrectoMSG(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  var snackBar = SnackBar(
    content: Container(
      height: 30,
      child: Text(
        mensaje,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    backgroundColor: Colors.green,
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

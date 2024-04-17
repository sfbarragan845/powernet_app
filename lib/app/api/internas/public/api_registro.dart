// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';
import '../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_KYC"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> recuperarClavePaso1;

Future<dynamic> postRegistro(String nombres, String cedula, String telefono, String direccion, String correo, String clave) async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/registro/api_registro_usuario.php');
    final body = {
      "token": tokenizer,
      "nombres": nombres,
      "cedula": cedula,
      "telefono": telefono,
      "direccion": direccion,
      "correo": correo,
      "clave": clave,
      "dispositivo": Preferences.idDispositivo.toString(),
      "registro_oauth": 'NO'
    };
    final response = await http.post(url, body: body);
    print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      recuperarClavePaso1 = Future.value(data);
      return null;
    }
  } catch (e) {
    print(e);
  }
}

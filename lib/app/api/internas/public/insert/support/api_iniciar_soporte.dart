import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_INICIAR_SOPORTE"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> iniciarsoporte;

Future<dynamic> IniciarSoporte(
    String pk, String id_tecnico, double latitud, double longitud) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_iniciar_soporte.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "id_pk": pk,
      "id_tecnico": id_tecnico,
      "token": tokenizer,
      "digitador": Preferences.usrNombre,
      "latitud": latitud.toString(),
      "longitud": longitud.toString()
    };
    final response = await http.post(url, body: body);
    print(url);
    print(body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      iniciarsoporte = Future.value(data);
      return null;
    }
  } catch (e) {
    //print(e);
  }
}

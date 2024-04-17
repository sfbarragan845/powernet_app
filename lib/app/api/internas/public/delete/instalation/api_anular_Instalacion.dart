import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_ANULAR_INSTALACION"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> anularInst;

Future<dynamic> AnularInstalacion(String id_instalacion, String id_servicio,
    String obs, String lat, String lng, String actualizar_coordenadas) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/anular/api_anular_instalacion.php');
    final body = {
      "observacion": obs,
      "token": tokenizer,
      "digitador": Preferences.usrNombre,
      "id_instalacion": id_instalacion,
      "id_servicio": id_servicio,
      "latitud": lat,
      "longitud": lng,
      "actualizar_coordenadas": actualizar_coordenadas
    };
    final response = await http.post(url, body: body);
    print(body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      anularInst = Future.value(data);
      print(response.statusCode);
      //return null;
    }
  } catch (e) {
    //print(e);
  }
}

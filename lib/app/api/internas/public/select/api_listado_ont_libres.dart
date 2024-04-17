// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_OBTENER_ONTS_LIBRES"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> lisONT;

Future<dynamic> listadoONTlibre(String idServ, String listar) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_buscarontlibres.php');
    print(url);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString(),
      "digitador": Preferences.usrNombre,
      "id_servicio": (idServ),
      "referencia_listar": listar
    };
    final response = await http.post(url, body: body,);
    print(body);
    String bodyBytes = utf8.decode(response.bodyBytes);
    final data = jsonDecode(bodyBytes);
    if (response.statusCode == 200 || response.statusCode == 201) {
      lisONT = Future.value(data);
    } else {
      lisONT = Future.value(data);
    }
    return lisONT;
  } catch (e) {
    print(e);
  }
}

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_ASIGNAR_ONT_INSTALACION"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> asigONT;

Future<dynamic> asignarONT(String idServ, String puertopon, int listar) async {
  asigONT = Future.value(null);
  try {
    var url =
        Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_asignaront.php');
    print(url);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString(),
      "digitador": Preferences.usrNombre,
      "id_servicio": (idServ),
      "puerto_pon": puertopon,
      "referencia_listar": listar.toString()
    };
    final response = await http.post(
      url,
      body: body,
    );
    print(body);
    String bodyBytes = utf8.decode(response.bodyBytes);
    final data = jsonDecode(bodyBytes);
    print(data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      asigONT = Future.value(data);
    } else {
      asigONT = Future.value(data);
    }
    return await asigONT;
  } catch (e) {
    print('INGRESE AL CATCH');

    print(e);
    return null;
  }
}

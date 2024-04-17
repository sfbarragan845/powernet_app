import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_ASIGNAR_TECNICO_SOPORTE"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> asignarSoporte;

Future<dynamic> AsignarSoporte(String pk, String id_tecnico) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_asignartecnico_soporte.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "id_pk": pk,
      "id_tecnico": id_tecnico,
      "token": tokenizer,
      "digitador": Preferences.usrNombre
    };
    final response = await http.post(url, body: body);
    print(body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      asignarSoporte = Future.value(data);
      //return null;
    }
    return await asignarSoporte;
  } catch (e) {
    return null;
    //print(e);
  }
}

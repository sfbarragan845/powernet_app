import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_ASIGNAR_TECNICO_INSTALACION"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> asignarInstalacion;

Future<dynamic> AsignarInstalacion(String pk, String id_tecnico) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_asignartecnico_instalacion.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "id_pk": pk,
      "id_tecnico": id_tecnico,
      "token": tokenizer,
      "digitador": Preferences.usrNombre
    };
    final response = await http.post(url, body: body);
    print(url);
    print(response.statusCode);
    print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      asignarInstalacion = Future.value(data);
    }
    return await asignarInstalacion;
  } catch (e) {
    return null;
    //print(e);
  }
}

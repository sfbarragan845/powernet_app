import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_CAMBIAR_CLAVE"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> cambiarClave;

Future<dynamic> postCambiarClave(String usuario, String clave) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/usuario/api_cambiarclave_v1.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "claveanterior": usuario,
      "clavenueva": clave,
      "token": tokenizer
    };
    final response = await http.post(url, body: body);
    // print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      cambiarClave = Future.value(data);
      return null;
    }
  } catch (e) {
    //print(e);
  }
}

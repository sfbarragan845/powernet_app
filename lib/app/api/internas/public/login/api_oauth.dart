// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_OAUTH"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> registroOauth;

Future<dynamic> postRegistroOauth(
    String nombres, String correo, String cuentaOauth) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/registro/api_registro_usuario_oauth.php');
    final body = {
      "token": tokenizer,
      "nombres": nombres,
      "correo": correo,
      "cuenta_oauth": cuentaOauth,
      "dispositivo": Preferences.idDispositivo.toString(),
      "registro_oauth": 'SI'
    };
    final response = await http.post(url, body: body);
    print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      registroOauth = Future.value(data);
      return null;
    }
  } catch (e) {
    print(e);
  }
}

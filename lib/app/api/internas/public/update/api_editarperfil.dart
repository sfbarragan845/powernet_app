// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_EDITAR_PERFIL"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> editarPerfil;

Future<dynamic> postEditarPerfil(String correo, String celular) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/usuario/api_editarperfil_v1.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "digitador": Preferences.usrNombre,
      "correo": correo,
      "celular": celular,
      "token": tokenizer
    };
    final response = await http.post(url, body: body);
    print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      editarPerfil = Future.value(data);
      return null;
    }
  } catch (e) {
    //print(e);
  }
}

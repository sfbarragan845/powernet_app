// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '/app/models/var_global.dart' as global;
import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';
import '../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_VERSIONAPP_TECNICO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> versionAPP;

Future<dynamic> postVersion(String Hola) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/version/api_listado_version.php');
    final body = {
      "token": tokenizer,
    };
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      versionAPP = Future.value(data);
      if (data['success'] == 'OK') {
        global.versionAPP = data['version'];
      }
      //return null;
    }
  } catch (e) {
    print(e);
  }
}

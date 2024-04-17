// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '/app/models/share_preferences.dart';
import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_COORDENADAS_SOPORTES"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> datosMarkUbi;

Future<dynamic> postMarkUbi() async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/tecnico/soportes/api_coordenadas_soportes.php');
    final body = {"token": tokenizer, "id_usuario": Preferences.usrID.toString()};
    final response = await http.post(url, body: body);
    print(url);
    print(body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      datosMarkUbi = Future.value(data);
      return null;
    }
  } catch (e) {
    //print(e);
  }
}

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LISTADO_TECNICOSISP"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> lisTecnico;

Future<dynamic> listadoTecnico(String email) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_listado_tecnicos.php');
    print(url);
    final body = {
      "token": tokenizer,
    };
    final response = await http.post(url, body: body);
    print(body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      lisTecnico = Future.value(data);
    }
    return lisTecnico;
  } catch (e) {
    print(e);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_RECUPERARCLAVE_PASO1"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> recuperarClavePaso1;

Future<dynamic> postRecuperarClaveP1(String cedula) async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/usuario/api_recuperaclavepaso1_v1.php');
    final body = {"cedula": cedula, "token": tokenizer};
    final response = await http.post(url, body: body);
    // print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      recuperarClavePaso1 = Future.value(data);
      return null;
    }
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
}

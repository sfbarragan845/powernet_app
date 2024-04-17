import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LISTADO_GPSMOTORIZADO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> datosTRACKING;

Future<dynamic> postTrackin(String idUser) async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/tracking/api_listado_tracking.php');
    final body = {"token": tokenizer, "id_usuario": idUser};
    print('Token de obtener Lista de bancos: $tokenizer');
    final response = await http.post(url, body: body);
    //print(body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      datosTRACKING = Future.value(data);
      print('aqui los datos' + data);
    }
  } catch (e) {
    //print(e);
  }
}

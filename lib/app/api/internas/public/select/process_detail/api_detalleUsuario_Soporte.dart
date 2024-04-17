import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_DETALLE_SOPORTE";
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> detallesoporte;

Future<dynamic> DetalleSoporte(
  String pk,
) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_detalle_soportes.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "id_pk": pk,
      "token": tokenizer,
    };
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      detallesoporte = Future.value(data);
    }
  } catch (e) {
    print(e);
  }
}

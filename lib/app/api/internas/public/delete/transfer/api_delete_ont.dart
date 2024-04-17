// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_BORRAR_ONT_TRASLADO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> delONT;

Future<dynamic> borrarONT(String idServ,) async {
  delONT = Future.value(null);
  try {
    var url =
        Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_borraront_traslado.php');
    print(url);
    final headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString(),
      "digitador": Preferences.usrNombre,
      "id_servicio": (idServ),
    };
    final response = await http.post(
      url,
      body: body,
    );
    print(body);
    String bodyBytes = utf8.decode(response.bodyBytes);
    final data = jsonDecode(bodyBytes);
    print(data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      delONT = Future.value(data);
    } else {
      delONT = Future.value(data);
    }
    return await delONT;
  } catch (e) {
    print('INGRESE AL CATCH');

    print(e);
    return null;
  }
}

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';
import '/app/models/var_global.dart' as global;

// ignore: constant_identifier_names
const String FORM = "FORM_ESTADO_PROCESOS"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

//late Future<dynamic> lisInstalaciones;

Future<dynamic> processStateStatistic() async {
  var url = Uri.parse(
      '$ROOT/app/$FOLDER/$IDENTYAPP/estadistica/api_estado_procesos.php');
  try {
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString(),
      "fecha_inicio": global.startDate.toString(),
      "fecha fin": global.endDate.toString(),
      "id_tecnico": global.id_technician
    };
    print(body);
    final response = await http.post(url, body: body);
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = json.decode(response.body);

      return data;
    }
  } catch (e) {
    print(e);
  }
}

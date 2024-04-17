// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:powernet/app/models/transfer/Datos_Traslado.dart';

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LISTADO_TRASLADOS_PENDIENTES"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

//late Future<dynamic> lisInstalaciones;

Future<dynamic> listadoTraslados(String email) async {
  var url = Uri.parse(
      '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_listado_traslados_pendientes.php');
  try {
    //login/api_login_v1.php
    //var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_login_v1.php');
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString()
    };
    final response = await http.post(url, body: body);
    final List<Datos_Traslados> traslados = [];
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = json.decode(response.body);
      print(data);
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        final evento = data['data'] as List<dynamic>;
        for (var eventos in evento) {
          traslados.add(Datos_Traslados.fromJson(eventos));
        }
      }
      return traslados;
    }
  } catch (e) {
    print(e);
  }
}

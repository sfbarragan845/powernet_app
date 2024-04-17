// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:powernet/app/models/support/Datos_Soportes.dart';

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LISTADO_SOPORTES_PENDIENTES"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

Future<dynamic> listadoSoportes(String email) async {
  var url = Uri.parse(
      '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_listado_soportes_pendientes.php');
  try {
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString()
    };
    final response = await http.post(url, body: body);
    final List<Datos_Soportes> registros = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        final evento = data['data'] as List<dynamic>;
        for (var eventos in evento) {
          registros.add(Datos_Soportes.fromJson(eventos));
        }
      }
      return registros;
    } else {
      return null;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

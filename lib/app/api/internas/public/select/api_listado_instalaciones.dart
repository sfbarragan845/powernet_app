// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../models/instalation/Datos_Instalaciones.dart';
import '/app/models/var_global.dart' as global;
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM =
    "FORM_LISTADO_INSTALACIONES_PENDIENTES"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

Future<dynamic> listadoInstalaciones(String email) async {
  var url = Uri.parse(
      '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_listado_instalaciones_pendientes.php');
  try {
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString()
    };
    final response = await http.post(url, body: body);
    final List<Datos_Instalaciones> registros = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final data2 = json.decode(response.body);
      global.data_prestacion = data2;
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        final evento = data['data'] as List<dynamic>;

        for (var eventos in evento) {
          registros.add(Datos_Instalaciones.fromJson(eventos));
        }
      }
      return registros;
    } else {
      return {};
    }
  } catch (e) {
    print(e);
    return null;
  }
}

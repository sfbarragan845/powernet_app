// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:powernet/app/models/charges/Datos_Documentos.dart';
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LISTADO_DOCUMENTOS"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

//late Future<dynamic> lisInstalaciones;

Future<dynamic> listadoDocumentos() async {
  var url = Uri.parse(
      '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_listado_documentos.php');
  try {
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString()
    };
    final response = await http.post(url, body: body);

    final List<DatosDocumentos> registros = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        final evento = data['data'] as List<dynamic>;
        for (var eventos in evento) {
          registros.add(DatosDocumentos.fromJson(eventos));
        }
      }
      return registros;
    }
  } catch (e) {
    print(e);
  }
}

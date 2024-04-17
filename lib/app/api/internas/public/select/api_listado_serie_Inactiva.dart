// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../pages/public/soporte/widgets/Datos_GarantiaSeries.dart';
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_SERIES_INACTIVAS"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> lisgarantia;

Future<dynamic> listadoGarantias(String email) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/productos/producto/api_listado_series_inactivas_productos.php');
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString(),
    };
    final response = await http.post(url, body: body);
    final List<lista_series_garantia> registros = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        final evento = data['data'] as List<dynamic>;
        for (var eventos in evento) {
          registros.add(lista_series_garantia.fromJson(eventos));
        }
      }
      return registros;
    }
  } catch (e) {
    print(e);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_FINALIZAR_ACTIVIDAD"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> finalizarRetiro;

Future<dynamic> FinalizarRetiro(
    String id_servicio,
    String id_cliente,
    String retiro_ejecutado_si_no,
    String equipos_devueltos_si_no,
    String detalle_equipos,
    String observacion,
    String motivo,
    String tipo_actividad) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/finalizar/api_finalizar_retiro.php');
    final body = {
      "id_servicio": id_servicio,
      "id_cliente": id_cliente,
      "token": tokenizer,
      "digitador": Preferences.usrNombre,
      "retiro_ejecutado_si_no": retiro_ejecutado_si_no,
      "equipos_devueltos_si_no": equipos_devueltos_si_no,
      "detalle_equipos": detalle_equipos,
      "observacion": observacion,
      "tipo_actividad": tipo_actividad,
      "motivo": motivo,
    };
    final response = await http.post(url, body: body);
    print(body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      finalizarRetiro = Future.value(data);
      print(response.statusCode);
      print(finalizarRetiro);
      //return null;
    }
  } catch (e) {
    //print(e);
  }
}

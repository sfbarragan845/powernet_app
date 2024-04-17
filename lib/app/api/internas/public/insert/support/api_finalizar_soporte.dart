import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_FINALIZAR_SOPORTE"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late dynamic finalizarsoporte;

Future<dynamic> Finalizaroporte(
    String pk,
    String id_tecnico,
    String catSolucion,
    String solucion,
    String factura,
    String detFactura) async {
  finalizarsoporte = null;
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_finalizar_soporte.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "id_pk": pk,
      "id_tecnico": id_tecnico,
      "token": tokenizer,
      "digitador": Preferences.usrNombre,
      "categoria_solucion": catSolucion.toString(),
      "solucion": solucion.toString(),
      "facturado_si_no": factura,
      "detalle_factura": detFactura
    };
    final response = await http.post(url, body: body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      finalizarsoporte = (data);
    }
    //return await finalizarsoporte;
  } catch (e) {
    //print(e);
  }
  return finalizarsoporte;
}

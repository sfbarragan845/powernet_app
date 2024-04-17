import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/number_symbols_data.dart';

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_FINALIZAR_SOPORTE"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> finalizarsoporte;

Future<dynamic> FinalizarInstalacion(
    String pk,
    String id_tecnico,
    String catSolucion,
    String solucion,
    String factura,
    String detFactura) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/facturas/api_generar_factura_instalacion.php');
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
      finalizarsoporte = Future.value(data);
      return null;
    }
  } catch (e) {
    //print(e);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_COBRO_DOCUMENTO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> finalizarCobro;

Future<dynamic> FinalizarCobro(
    int id_usuario,
    String estado_servicio,
    String generar_factura,
    String fecha_proporcional,
    int id_cliente,
    int id_servicio,
    int id_documento,
    String tipo_cobro,
    double valor_cobrado,
    String observacion,
    String fecha_cheque,
    String numero_cheque,
    String id_cuenta_bancaria) async {
  try {
    print('paso');
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/cobro/api_cobro_documento.php');
    final body = {
      "id_usuario": id_usuario.toString(),
      "digitador": Preferences.usrNombre,
      "estado_servicio": estado_servicio,
      "generar_factura": generar_factura,
      "fecha_proporcional": fecha_proporcional,
      "id_cliente": id_cliente.toString(),
      "token": tokenizer,
      "id_servicio": id_servicio.toString(),
      "id_documento": id_documento.toString(),
      "tipo_cobro": tipo_cobro,
      "valor_cobrado": valor_cobrado.toString(),
      "observacion": observacion,
      "fecha_cheque": fecha_cheque,
      "numero_cheque": numero_cheque,
      "id_cuenta_bancaria": id_cuenta_bancaria
    };
    print('paso2');
    print(url);
    print(body);

    final response = await http.post(url, body: body);
    print('paso3');

    print(response);
    print(body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      finalizarCobro = Future.value(data);
      print(response.statusCode);
      print(finalizarCobro);
      //return null;
    }
  } catch (e) {
    print(e);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_FACTURA_VENTA"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late dynamic semifactura;

Future<dynamic> SemiFactura(
    String cliente,
    String id_soporte,
    String id_Serv,
    String catSolucion,
    String solucion,
    String factura,
    String proAdicional,
    String id_tecnico,
    String valorCobrado,
    String productos,
    String productosAdicional,
    String equipos_retirados_si_no,
    String detalle_equipos_retirados,
    String auxiliar,
    String latitud,
    String longitud,
    String actualizar_cordenadas,
    String cuotasAdi,
    String personaPresente) async {
      semifactura = null;
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/facturas/api_generar_factura_soporte.php');
    final body = {
      "id_usuario": Preferences.usrID.toString(),
      "id_soporte": id_soporte,
      "id_servicio": id_Serv,
      "id_cliente": cliente,
      "token": tokenizer,
      "digitador": Preferences.usrNombre,
      "categoria_solucion": catSolucion.toString(),
      "solucion": solucion.toString(),
      "facturado_si_no": factura,
      "productos_adicionales_si_no": proAdicional,
      "id_tecnico": id_tecnico,
      "valor_cobrado": valorCobrado,
      "productos": productos,
      "productos_adicionales": productosAdicional,
      "equipos_retirados_si_no": equipos_retirados_si_no,
      "detalle_equipos_retirados": detalle_equipos_retirados,
      "auxiliar": auxiliar,
      "latitud": latitud,
      "longitud": longitud,
      "actualizar_coordenadas": actualizar_cordenadas,
      "cuotas_productos_adicionales":cuotasAdi,
      "persona_presente":personaPresente
    };
    final response = await http.post(url, body: body);
    print(body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      semifactura = (data);
      print(response.statusCode);
      print(semifactura);
      //return null;
    }
  } catch (e) {
    //print(e);
  }
  return semifactura;
}

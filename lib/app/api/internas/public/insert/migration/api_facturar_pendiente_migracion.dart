import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_FACTURA_VENTA"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> semiFacturaPendienteMig;

Future<dynamic> semiFacturaPendienteMigracion(
    String cliente,
    String productos,
    String id_insta,
    String id_Serv,
    String solucion,
    String factura,
    String id_tecnico,
    String valorCobrado,
    String adicional,
    String productos_adicionales,
    String equipos_retirados_si_no,
    String detalle_equipos_retirados,
    String auxiliar,
    String latitud,
    String longitud,
    XFile? foto,
    String actualizar_coordenadas,
    String cuotas,
    String persona,
    String cuotasAdicionales) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/facturas_pendientes/api_generar_factura_pendiente_migracion.php');

    var request = http.MultipartRequest('POST', url)
      ..fields['token'] = tokenizer
      ..fields['id_usuario'] = Preferences.usrID.toString()
      ..fields['id_tecnico'] = id_tecnico
      ..fields['id_migracion'] = id_insta
      ..fields['id_servicio'] = id_Serv
      ..fields['id_cliente'] = cliente
      ..fields['productos'] = productos
      ..fields['digitador'] = Preferences.usrNombre
      ..fields['solucion'] = solucion.toString()
      ..fields['facturado_si_no'] = factura
      ..fields['valor_cobrado'] = valorCobrado
      ..fields['productos_adicionales_si_no'] = adicional
      ..fields['productos_adicionales'] = productos_adicionales
      ..fields['equipos_retirados_si_no'] = equipos_retirados_si_no
      ..fields['detalle_equipos_retirados'] = detalle_equipos_retirados
      ..fields['auxiliar'] = auxiliar
      ..fields['latitud'] = latitud
      ..fields['longitud'] = longitud
      ..fields['persona_presente'] = persona
      ..fields['actualizar_coordenadas'] = actualizar_coordenadas
      ..fields['cuotas'] = cuotas
      ..fields['cuotas_productos_adicionales'] = cuotasAdicionales
      ..files.add(await http.MultipartFile.fromPath(
        'archivo1',
        foto!.path.toString(),
      ));

    print(url);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      semiFacturaPendienteMig = Future.value(data);
      print(response.statusCode);
    }
  } catch (e) {
    return null;
    //print(e);
  }
}

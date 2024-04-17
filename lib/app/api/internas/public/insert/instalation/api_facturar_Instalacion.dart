import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_FACTURA_VENTA"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late dynamic semifacturaInst;

Future<dynamic> semifacturaInstalacion(
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
    String actualizar_coordenadas,
    String auxiliar,
    String latitud,
    String longitud,
    XFile? foto,
    XFile? foto2,
    String personaPresente,
    String cuotas) async {
  semifacturaInst = null;
  try {
    var client = http.Client();
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/transacciones/facturas/api_generar_factura_instalacion.php');
    var request = http.MultipartRequest('POST', url)
      ..fields['token'] = tokenizer
      ..fields['id_usuario'] = Preferences.usrID.toString()
      ..fields['id_instalacion'] = id_insta
      ..fields['id_servicio'] = id_Serv
      ..fields['id_cliente'] = cliente
      ..fields['productos'] = productos
      ..fields['digitador'] = Preferences.usrNombre
      ..fields['solucion'] = solucion.toString()
      ..fields['facturado_si_no'] = factura
      ..fields['id_tecnico'] = id_tecnico
      ..fields['valor_cobrado'] = valorCobrado
      ..fields['productos_adicionales_si_no'] = adicional
      ..fields['productos_adicionales'] = productos_adicionales
      ..fields['actualizar_coordenadas'] = actualizar_coordenadas
      ..fields["equipos_retirados_si_no"] = 'NO'
      ..fields["detalle_equipos_retirados"] = ''
      ..fields['auxiliar'] = auxiliar
      ..fields['latitud'] = latitud
      ..fields['longitud'] = longitud
      ..fields['persona_presente'] = personaPresente
      ..fields['cuotas_productos_adicionales'] = cuotas
      ..files.add(await http.MultipartFile.fromPath(
        'archivo1',
        foto!.path.toString(),
      ))
      ..files.add(await http.MultipartFile.fromPath(
        'archivo2',
        foto2!.path.toString(),
      ));

    var response = await client.send(request).timeout(Duration(seconds: 30));
    print(response);
    if (response.statusCode == 200) {
      String body = await response.stream.bytesToString();
      final data = jsonDecode(body);
      print(data);
      semifacturaInst = (data);
    }
  } catch (e) {
    print(e);
  }
  return semifacturaInst;
}

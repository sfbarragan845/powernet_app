// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';
import '../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_GENERAR_PEDIDO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> generaPedido;

Future<dynamic> postGenerarPedido(String fechaRetiro, String horaDesde, String horaHasta, String formaPago, String papel, String carton, String plastico, String obsPedi,
    String lat, String long, String num_cuenta, XFile archivo1) async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/ordenes/api_generar_pedido.php');
    var request = http.MultipartRequest('POST', url)
      ..fields["token"] = tokenizer
      ..fields["id_cliente"] = Preferences.usrID.toString()
      ..fields["fecha_retiro"] = fechaRetiro
      ..fields["hora_desde"] = horaDesde
      ..fields["hora_hasta"] = horaHasta
      ..fields["forma_pago"] = formaPago
      ..fields["papel"] = papel
      ..fields["carton"] = carton
      ..fields["plastico"] = plastico
      ..fields["observacion_pedido"] = obsPedi
      ..fields["latitud"] = lat
      ..fields["longitud"] = long
      ..fields["numero_cuenta"] = num_cuenta
      ..fields["digitador"] = Preferences.usrNombre.toString()
      ..files.add(await http.MultipartFile.fromPath(
        'archivo1',
        archivo1.path.toString(),
      ));
    var response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final data = jsonDecode(responseString);
      generaPedido = Future.value(data);
    } else {
      // print('Something went wrong!');
    }

    print('Token de obtener cliente: $tokenizer');
    //final response = await http.post(url, body: body);
    print(url);
    print(response.statusCode);
    /* if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      generaPedido = Future.value(data);
      return null;
    }*/
  } catch (e) {
    //print(e);
  }
}

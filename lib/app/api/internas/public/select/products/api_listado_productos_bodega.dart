// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/products/listas_prod.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_PRODUCTOS"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

Future<dynamic> list_products_bodega() async {
  final url = Uri.parse(
      '$ROOT/app/$FOLDER/productos/producto/api_listado_productos_bodega.php');
  try {
    print(tokenizer);
    print(Preferences.usrID.toString());
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString(),
    };
    final respose = await http.post(url, body: body);
    final List<lista_producto> registros = [];
    if (respose.statusCode == 200) {
      print(respose.statusCode);
      print(respose.body);

      final data = json.decode(respose.body);
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        final eventos = data['data'] as List<dynamic>;
        for (var eventos in eventos) {
          registros.add(lista_producto.fromJson(eventos));
        }
      } else if (data['success'] == 'ERROR' &&
          data['status_code'] == "ERROR_SELECT") {}
      return registros;
    } else {
      print('Error al obtener los proyectos: ${respose.statusCode}');
    }
  } catch (error) {
    print('Error al llamar la API de Proyectos $error');
  }
}

// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:powernet/app/models/crm/CRM_Products.dart';
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_CRM_PRODUCTOS"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

Future<dynamic> ProductsCRMList() async {
  var url = Uri.parse('$ROOT/app/$FOLDER/crm/detalle/api_lista_productos.php');
  try {
    final body = {
      "token": tokenizer,
    };
    final response = await http.post(url, body: body);
    print(url);
    print(body);
    final List<CRMProducts> registros = [];
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = json.decode(response.body);
      if (data['success'] == 'OK' && data['status_code'] == "200") {
        print('hola 222---- ');
        final evento = data['data'] as List<dynamic>;

        print('aqui mi len---- ' + evento.length.toString());
        print(evento);
        for (var eventos in evento) {
          registros.add(CRMProducts.fromJson(eventos));
        }
        print('aqui mi lista---- ' + registros.toString());
      }
      return registros;
    }
  } catch (e) {
    print(e);
  }
}

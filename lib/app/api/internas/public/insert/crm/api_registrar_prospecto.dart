import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_CREAR_PROSPECTO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> registerProspect;

Future<dynamic> RegisterProspect(
  String oportunity_name,
  String client_name,
  String client_phone,
  String product_id,
  String product_price,
  String oportunity_description,
) async {
  try {
    print('paso');
    var url =
        Uri.parse('$ROOT/app/$FOLDER/crm/registro/api_crear_prospecto.php');
    final body = {
      "technician_id": Preferences.usrID.toString(),
      "typist": Preferences.usrNombre,
      "oportunity_name": oportunity_name,
      "client_name": client_name,
      "client_phone": client_phone,
      "product_id": product_id.toString(),
      "token": tokenizer,
      "product_price": product_price.toString(),
      "oportunity_description": oportunity_description,
    };
    print('paso2');
    print(url);
    print(body);
    print('paso4');

    final response = await http.post(url, body: body);

    print('paso3');

    print(response.body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);

      registerProspect = Future.value(data);
      print(response.statusCode);
      print(registerProspect);
    }
  } catch (e) {
    print(e);
  }
}

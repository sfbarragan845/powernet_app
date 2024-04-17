// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_NOTIFICAR_CHAT"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> finalizarPedido;

Future<dynamic> postChatFinalizarPedido(String motorizado, String cliente, String mensaje) async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/otros/chat/api_notificar_chat.php');
    final body = {
      "token": tokenizer,
      "motorizado_dispositivo": motorizado,
      "cliente_dispositivo": cliente,
      "mensaje": mensaje,
    };
    print(body);
    print('Token de obtener cliente: $tokenizer');
    final response = await http.post(url, body: body);
    print(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      print(data);
      finalizarPedido = Future.value(data);
      return null;
    }
  } catch (e) {
    //print(e);
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LOGIN_OAUTH"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> users;

Future<dynamic> dologinOauth(String email, String oauth) async {
  try {
    var url = Uri.parse(
        '$ROOT/app/$FOLDER/$IDENTYAPP/login/api_login_oauth_v1_1.php');
    final body = {
      "correo": email,
      "redsocial": oauth,
      "token": tokenizer,
      "dispositivo": Preferences.idDispositivo.toString()
    };
    final response = await http.post(url, body: body);
    print(body);
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      users = Future.value(data);
      if (data['success'] == 'OK') {
        // Guardo datos del usuario
        Preferences.logueado = true;
        // Preferences.isDarkmode = false;
        Preferences.usrID =
            int.parse(data['data_cliente']['user_id'].toString());
        Preferences.usrNombre = data['data_cliente']['user_name'];
        Preferences.usrCorreo = data['data_cliente']['user_mail'];
        Preferences.usrCelular = data['data_cliente']['user_celu'];
        Preferences.usrCedula = data['data_cliente']['user_cedu'];
        if (data['data_cliente']['user_foto'] == "" ||
            data['data_cliente']['user_foto'] == null) {
          Preferences.usrFoto = 'avatar-men.png';
        } else {
          Preferences.usrFoto = data['data_cliente']['user_foto'];
        }
      }
      return null;
    }
  } catch (e) {
    print(e);
  }
}

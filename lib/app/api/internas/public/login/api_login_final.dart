// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LOGINTECNICO"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> user;

Future<dynamic> dologin(String email, String password) async {
  try {
    var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_login_v1.php');
    //login/api_login_v1.php
    //var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_login_v1.php');
    final body = {
      "usuario": email,
      "clave": password,
      "token": tokenizer,
      "dispositivo": Preferences.idDispositivo.toString()
    };
    final response = await http.post(url, body: body);
    print(body);
    print(response.statusCode);
    print('aqui');
    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final data = jsonDecode(body);
      user = Future.value(data);
      print(data['data_cliente']);
      if (data['success'] == 'OK') {
        // Guardo datos del usuario
        Preferences.logueado = true;
        // Preferences.isDarkmode = false;
        Preferences.usrID = data['data_cliente']['user_id'];
        Preferences.usrNombre = data['data_cliente']['user_name'];
        Preferences.usrCorreo = data['data_cliente']['user_mail'];
        Preferences.usrCelular = data['data_cliente']['user_celu'];
        Preferences.usrCedula = data['data_cliente']['user_cedu'];
        Preferences.adminTecnico =
            data['data_cliente']['user_administrador_apptecnico'];
        Preferences.usrnickName = data['data_cliente']['user_nickname'];
        Preferences.usrPerfil = data['data_cliente']['user_perfil'];
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

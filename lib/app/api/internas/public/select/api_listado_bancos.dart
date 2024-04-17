// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';
import '../../../../models/charges/Datos_Bancos.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_LISTADO_BANCOS"; //formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

//late Future<dynamic> lisInstalaciones;

Future<dynamic> listadoBancos(String email) async {
  var url =
      Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/soportes/api_listado_bancos.php');
  try {
    //login/api_login_v1.php
    //var url = Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_login_v1.php');
    final body = {
      "token": tokenizer,
      "id_usuario": Preferences.usrID.toString()
    };
    final response = await http.post(url, body: body);
    print(url);
    print(body);
    final List<Datos_Bancos> registros = [];
    if (response.statusCode == 200) {
      print(response.statusCode);
      final data = json.decode(response.body);
      final data2 = json.decode(response.body);
      //global.data_prestacion = data2;
      if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
        print('hola 222---- ');
        final evento = data['data'] as List<dynamic>;

        //print(global.data_prestacion);
        print('aqui mi len---- ' + evento.length.toString());
        //print('aqui mi lista press---- ' + pres.toString());
        print(evento);
        for (var eventos in evento) {
          registros.add(Datos_Bancos.fromJson(eventos));
          //lista.add(registros.where((tipo_evento) => tipo_evento=='FESTIVAL'));
        }
        print('aqui mi lista---- ' + registros.toString());
        //globals.ListadoInstalacion.addAll(registros);
        //print('aqui mi lista---- ' + globals.ListadoInstalacion.toString());
      } /* else if (value['success'] == 'ERROR' &&
          value['status_code'] == "ERROR_SELECT") {
        //globals.mensaje = value['mensaje'];
      } */
      return registros;
      //lisInstalaciones = Future.value(data);

      //return null;
    }
  } catch (e) {
    print(e);
  }
}

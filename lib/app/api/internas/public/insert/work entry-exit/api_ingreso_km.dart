import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../../clases/cParametros.dart';
import '../../../../../core/cToken.dart';
import '../../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM =
    "FORM_REGISTRO_ENTRADAS"; //Se declara el formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> registroEntrada;

Future<dynamic> postRegistroEntrada(String latitud, String longitud) async {
  try {
    var uri = Uri.parse(
        '$ROOT/app/$FOLDER/tecnico/asistencia/api_registro_entradas.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['token'] = tokenizer
      ..fields['id_usuario'] = Preferences.usrID.toString()
      ..fields['digitador'] = Preferences.usrNombre.toString()
      ..fields['latitud'] = latitud
      ..fields['longitud'] = longitud;
    // ..files.add(await http.MultipartFile.fromPath(
    //   'archivo_foto',
    //   archivo1.path.toString(),
    // ));
    print(uri);
    print(tokenizer);

    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final data = jsonDecode(responseString);
      print('entrada');
      print(data);
      registroEntrada = Future.value(data);
    } else {
      print('Something went wrong!');
    }
  } catch (e) {
    // print(e);
  }
}

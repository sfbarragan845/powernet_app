import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/share_preferences.dart';

// ignore: constant_identifier_names
const String FORM = "FORM_EDITAR_FOTO"; //Se declara el formulario a acceder
final String tokenizer = generateMd5(Secret_Token, FORM); //Se genera Token

late Future<dynamic> kyc;
String num = '56';

void postEnviarfoto(XFile archivo1) async {
  try {
    var uri =
        Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_cambiar_foto_v1.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['token'] = tokenizer
      ..fields['id_usuario'] = Preferences.usrID.toString()
      ..fields['digitador'] = Preferences.usrNombre
      ..files.add(await http.MultipartFile.fromPath(
        'archivo1',
        archivo1.path.toString(),
      ));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final data = jsonDecode(responseString);
      kyc = Future.value(data);
    } else {
      // print('Something went wrong!');
    }
  } catch (e) {
    // print(e);
  }
}

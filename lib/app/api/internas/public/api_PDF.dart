import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ApiPdf{
  //static final PDF_URL = 'https://labzuna.com.bo/consultas/resultados/${globals.idSolicitud}';
  static Future<File> _storeFiles(String url, List<int> bytes)async{
final filename= basename(url);
final dir = await getApplicationDocumentsDirectory();
final file = File('${dir.path}/$filename');
await file.writeAsBytes(bytes, flush: true);
return file;
  }

  static loadNetwork(String url) async {
    final response= await http.get(Uri.parse(url));
final bytes = response.bodyBytes;
return _storeFiles(url, bytes);
  }
}
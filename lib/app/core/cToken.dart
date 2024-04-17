// ignore_for_file: file_names

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

// ignore: constant_identifier_names
const String Secret_Token = "FLUTTER2022ANDROIDIOS1991POWERNET"; //Según cToken server

generateMd5(String token, String form) {
  var content = const Utf8Encoder().convert(token + form); //Token & Formulario
  var md5 = crypto.md5; // Se escoge la encriptación
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}

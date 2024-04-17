// ignore_for_file: unused_field

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesCliente {
  static late SharedPreferences _prefs;

  static String _cliente = '';
  static String _foto = 'avatar-men.png';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get usrCliente {
    return _prefs.getString('usrListaCliente') ?? _cliente;
  }

  static set usrCliente(String name) {
    _cliente = name;
    _prefs.setString('usrListaCliente', name);
  }

  static logout() {
    _prefs.clear();
  }

  //  String get clientesJson {
  //   var pro = "[";
  //   int i = 0;
  //   _items.forEach((key, cartItem) {
  //     pro += "{";
  //     pro += "\"codigo\": \"${cartItem.id}\",";
  //     pro += "\"nombre\": \"${cartItem.nombre}\",";
  //     pro += "\"precio\": ${cartItem.precio},";
  //     pro += "\"cantidad\": ${cartItem.cantidad}";
  //     if (i + 1 != _items.length) {
  //       pro += "},";
  //     } else {
  //       pro += "}";
  //     }
  //     i++;
  //   });
  //   pro += "]";
  //   //print('JSONNNNNN: $pro');
  //   return pro;
  // }
}

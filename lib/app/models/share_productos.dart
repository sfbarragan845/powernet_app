import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProductos {
  static late SharedPreferences _prefs;

  static String _productos = '';
  // ignore: unused_field
  static String _categorias = '';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get usrProductos {
    return _prefs.getString('usrListaProductos') ?? _productos;
  }

  static set usrProductos(String name) {
    _productos = name;
    _prefs.setString('usrListaProductos', name);
  }

  static String get usrCategorias {
    return _prefs.getString('usrListaCategorias') ?? _productos;
  }

  static set usrCategorias(String name) {
    _categorias = name;
    _prefs.setString('usrListaCategorias', name);
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

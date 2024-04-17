import 'package:shared_preferences/shared_preferences.dart';

class PreferencesGuardar {
  static late SharedPreferences _prefs;

  static String _guardar = '';
  static String _formaPago = '';
  static String _clienteoffline = '';
  static String _parroquia = '';
  static String _parroquia_cod = '';
  static String _zona = '';
  static String _agregarcliente = '';
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String get usrGuardar {
    return _prefs.getString('usrListaGuardar') ?? _guardar;
  }

  static set usrGuardar(String name) {
    _guardar = name;
    _prefs.setString('usrListaGuardar', name);
  }

  static String get usrPago {
    return _prefs.getString('usrListaGuardarPago') ?? _formaPago;
  }

  static set usrPago(String name) {
    _formaPago = name;
    _prefs.setString('usrListaGuardarPago', name);
  }

  static String get usrClienteOffline {
    return _prefs.getString('usrListaGuardar_clienteoffline') ??
        _clienteoffline;
  }

  static set usrClienteOffline(String name) {
    _clienteoffline = name;
    _prefs.setString('usrListaGuardar_clienteoffline', name);
  }

  /////////////////////////////////
  static String get usrParroqui {
    return _prefs.getString('usrParroqui') ?? _parroquia;
  }

  static set usrParroqui(String name) {
    _parroquia = name;
    _prefs.setString('usrParroqui', name);
  }

  //
  static String get usrParroquiCod {
    return _prefs.getString('usrParroquiCod') ?? _parroquia_cod;
  }

  static set usrParroquiCod(String name) {
    _parroquia_cod = name;
    _prefs.setString('usrParroquiCod', name);
  }

  //
/////////////////////////////////////////
  ///
  static String get usrZona {
    return _prefs.getString('usrZona') ?? _zona;
  }

  static set usrZona(String name) {
    _zona = name;
    _prefs.setString('usrZona', name);
  }

  ///
  ///
  static String get usrAgregarCliente {
    return _prefs.getString('usrAgregarCliente') ?? _agregarcliente;
  }

  static set usrAgregarCliente(String name) {
    _agregarcliente = name;
    _prefs.setString('usrAgregarCliente', name);
  }

  ///
  ///
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

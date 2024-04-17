// import 'package:shared_preferences/shared_preferences.dart';

// class Preferences {
//   static late SharedPreferences _prefsClie;

//   static String _nombreCliente = '';

//   static Future init() async {
//     _prefsClie = await SharedPreferences.getInstance();
//   }

//   static String get usrNombre {
//     return _prefsClie.getString('usrNombreCliente') ?? _nombreCliente;
//   }

//   static set usrNombre(String name) {
//     _nombreCliente = name;
//     _prefsClie.setString('usrNombreCliente', name);
//   }
// }

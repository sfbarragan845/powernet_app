import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetServices {
  Future<bool> verificarConexion() async {
    return await InternetConnectionChecker().hasConnection;
  }
}

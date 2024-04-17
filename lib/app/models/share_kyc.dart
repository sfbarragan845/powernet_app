import 'package:shared_preferences/shared_preferences.dart';

class PreferencesKYC {
  static late SharedPreferences _prefskyc;

  static String _nombres = '';
  static String _apellidos = '';
  static String _cedula = '';
  static String _nacionalidad = '';
  static String _tipo = '';
  static String _telefono = '';
  static String _correo = '';
  static String _fotoAnverso = '';
  static String _fotoReverso = '';
  static String _fotoSelfie = '';
  static Future init() async {
    _prefskyc = await SharedPreferences.getInstance();
  }

// Desde Aqui

  static String get kycNombres {
    return _prefskyc.getString('kycNombre') ?? _nombres;
  }

  static set kycNombres(String name) {
    _nombres = name;
    _prefskyc.setString('kycNombre', name);
  }

  static String get kycApellidos {
    return _prefskyc.getString('kycApellido') ?? _apellidos;
  }

  static set kycApellidos(String name) {
    _apellidos = name;
    _prefskyc.setString('kycApellido', name);
  }

  static String get kycCedulas {
    return _prefskyc.getString('kycCedula') ?? _cedula;
  }

  static set kycCedulas(String name) {
    _cedula = name;
    _prefskyc.setString('kycCedulas', name);
  }

  static String get kycNacionalidad {
    return _prefskyc.getString('kycNacio') ?? _nacionalidad;
  }

  static set kycNacionalidad(String name) {
    _nacionalidad = name;
    _prefskyc.setString('kycNacio', name);
  }

  static String get kycTipo {
    return _prefskyc.getString('kycTipos') ?? _tipo;
  }

  static set kycTipo(String name) {
    _tipo = name;
    _prefskyc.setString('kycTipos', name);
  }

  static String get kycTelefono {
    return _prefskyc.getString('kycTelefono') ?? _telefono;
  }

  static set kycTelefono(String name) {
    _telefono = name;
    _prefskyc.setString('kycTelefono', name);
  }

  static String get kycCorreo {
    return _prefskyc.getString('kycCorreo') ?? _correo;
  }

  static set kycCorreo(String name) {
    _correo = name;
    _prefskyc.setString('kycCorreo', name);
  }

  static String get kycFotoAnverso {
    return _prefskyc.getString('kycFotoAnverso') ?? _fotoAnverso;
  }

  static set kycFotoAnverso(String name) {
    _fotoAnverso = name;
    _prefskyc.setString('kycFotoAnverso', name);
  }

  static String get kycFotoReverso {
    return _prefskyc.getString('kycFotoReverso') ?? _fotoReverso;
  }

  static set kycFotoReverso(String name) {
    _fotoReverso = name;
    _prefskyc.setString('kycFotoReverso', name);
  }

  static String get kycFotoSelfie {
    return _prefskyc.getString('kycFotoSelfie') ?? _fotoSelfie;
  }

  static set kycFotoSelfie(String name) {
    _fotoSelfie = name;
    _prefskyc.setString('kycFotoSelfie', name);
  }

  static limpiar() {
    _prefskyc.clear();
  }
}

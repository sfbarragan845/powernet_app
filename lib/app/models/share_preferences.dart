import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static bool _isDarkmode = false;

  static bool _logueado = false;
  static bool _veri = false;
  static bool _save = true;
  static int _idUser = 0;
  static int _idUserRecuperarClave = 0;
  static int _num_page = 0;

  static String _nombre = '';
  static String _usrnickName = '';
  static String _correo = '';
  static String _foto = 'avatar-men.png';
  static String _celular = '';
  static String _cedula = '';
  static String _usrperfil = '';
  static String _idDispositivo = '';
  static String _claveOauth = 'SINCLAVE';
  static String _latiLongi = '';
  static String _LatClient = '';
  static String _LngClient = '';
  static String _NumOrd = '';
  static String _oauth = 'NO';
  static String _TipoOuthSesion = '';
  static String _adminTecnico = 'NO';
  static String _serie = 'Visualizar serie';
  static String _ubiNavLat = '';
  static String _ubiNavLng = '';
  static String _LngMot = '';

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get isDarkmode {
    return _prefs.getBool('isDarkmode') ?? _isDarkmode;
  }

  static set isDarkmode(bool value) {
    _isDarkmode = value;
    _prefs.setBool('isDarkmode', value);
  }

// Desde Aqui
  static bool get logueado {
    return _prefs.getBool('Logueado') ?? _logueado;
  }

  static set logueado(bool value) {
    _logueado = value;
    _prefs.setBool('Logueado', value);
  }

  static bool get veri {
    return _prefs.getBool('_veri') ?? _veri;
  }

  static set veri(bool value) {
    _veri = value;
    _prefs.setBool('_veri', value);
  }

  static bool get save {
    return _prefs.getBool('_save') ?? _save;
  }

  static set save(bool value) {
    _save = value;
    _prefs.setBool('_save', value);
  }

  static int get usrID {
    return _prefs.getInt('usrID') ?? _idUser;
  }

  static set usrID(int value) {
    _idUser = value;
    _prefs.setInt('usrID', value);
  }

  static String get TipoOuthSesion {
    return _prefs.getString('TipoOuthSesion') ?? _TipoOuthSesion;
  }

  static set TipoOuthSesion(String name) {
    _TipoOuthSesion = name;
    _prefs.setString('TipoOuthSesion', name);
  }

  static String get serie {
    return _prefs.getString('_serie') ?? _serie;
  }

  static set serie(String name) {
    _serie = name;
    _prefs.setString('_serie', name);
  }

  static String get adminTecnico {
    return _prefs.getString('_adminTecnico') ?? _adminTecnico;
  }

  static set adminTecnico(String name) {
    _adminTecnico = name;
    _prefs.setString('_adminTecnico', name);
  }

  static int get num_page {
    return _prefs.getInt('num_page') ?? _num_page;
  }

  static set num_page(int value) {
    _num_page = value;
    _prefs.setInt('num_page', value);
  }

  static int get usrIDRecuperar {
    return _prefs.getInt('usrIDRecuperar') ?? _idUserRecuperarClave;
  }

  static set usrIDRecuperar(int value) {
    _idUserRecuperarClave = value;
    _prefs.setInt('usrIDRecuperar', value);
  }

  static String get usrNombre {
    return _prefs.getString('usrNombre') ?? _nombre;
  }

  static set usrNombre(String name) {
    _nombre = name;
    _prefs.setString('usrNombre', name);
  }

  static String get usrnickName {
    return _prefs.getString('_usrnickName') ?? _usrnickName;
  }

  static set usrnickName(String name) {
    _usrnickName = name;
    _prefs.setString('_usrnickName', name);
  }

  static String get usrOauth {
    return _prefs.getString('usrOauth') ?? _oauth;
  }

  static set usrOauth(String name) {
    _oauth = name;
    _prefs.setString('usrOauth', name);
  }

  static String get NumOrd {
    return _prefs.getString('NumOrd') ?? _NumOrd;
  }

  static set NumOrd(String nord) {
    _NumOrd = nord;
    _prefs.setString('NumOrd', nord);
  }

  static String get LatClient {
    return _prefs.getString('LatClient') ?? _LatClient;
  }

  static set LatClient(String ltclient) {
    _LatClient = ltclient;
    _prefs.setString('LatClient', ltclient);
  }

  static String get LngClient {
    return _prefs.getString('LngClient') ?? _LngClient;
  }

  static set LngClient(String lnclient) {
    _LngClient = lnclient;
    _prefs.setString('LngClient', lnclient);
  }

  static String get claveOauth {
    return _prefs.getString('claveOauth') ?? _claveOauth;
  }

  static set claveOauth(String clave) {
    _claveOauth = clave;
    _prefs.setString('claveOauth', clave);
  }

  static String get latiLongi {
    return _prefs.getString('latiLongi') ?? _latiLongi;
  }

  static set latiLongi(String latlon) {
    _claveOauth = latlon;
    _prefs.setString('latiLongi', latlon);
  }

  static String get usrCorreo {
    return _prefs.getString('usrCorreo') ?? _correo;
  }

  static set usrCorreo(String name) {
    _correo = name;
    _prefs.setString('usrCorreo', name);
  }

  static String get usrFoto {
    return _prefs.getString('usrFoto') ?? _foto;
  }

  static set usrFoto(String name) {
    _foto = name;
    _prefs.setString('usrFoto', name);
  }

  static String get usrCelular {
    return _prefs.getString('usrCelular') ?? _celular;
  }

  static set usrCelular(String name) {
    _celular = name;
    _prefs.setString('usrCelular', name);
  }

  static String get usrCedula {
    return _prefs.getString('usrCedula') ?? _cedula;
  }

  static set usrCedula(String name) {
    _cedula = name;
    _prefs.setString('usrCedula', name);
  }

  static String get usrPerfil {
    return _prefs.getString('usrPerfil') ?? _usrperfil;
  }

  static set usrPerfil(String name) {
    _usrperfil = name;
    _prefs.setString('usrPerfil', name);
  }

  static String get idDispositivo {
    return _prefs.getString('idDispositivo') ?? _idDispositivo;
  }

  static set idDispositivo(String name) {
    _idDispositivo = name;
    _prefs.setString('idDispositivo', name);
  }

  static String get ubiNavLat {
    return _prefs.getString('ubiNavLat') ?? _ubiNavLat;
  }

  static set ubiNavLat(String lt) {
    _ubiNavLat = lt;
    _prefs.setString('ubiNavLat', lt);
  }

  static String get ubiNavLng {
    return _prefs.getString('ubiNavLng') ?? _ubiNavLng;
  }

  static set ubiNavLng(String ln) {
    _ubiNavLng = ln;
    _prefs.setString('ubiNavLng', ln);
  }

  static String get LngMot {
    return _prefs.getString('LngMot') ?? _LngMot;
  }

  static set LngMot(String name) {
    _LngMot = name;
    _prefs.setString('LngMot', name);
  }

  static logout() {
    _prefs.clear();
    Preferences.isDarkmode = false;
    Preferences.logueado = false;
    //Preferences.usrID = 0;
  }
}

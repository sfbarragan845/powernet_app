// ignore_for_file: file_names

final RegExp _celular = RegExp(r"^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$");
final RegExp _nombre = RegExp(r"^([A-Z][A-Za-z.'\-]+) (?:([A-Z][A-Za-z.'\-]+) )?([A-Z][A-Za-z.'\-]+)$");
final RegExp _codigopostal = RegExp(r"^\d{5}(-\d{4})?$");
final RegExp _email =
    RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
final RegExp _url = RegExp(r"^(?:http|https):\/\/[\w\-_]+(?:\.[\w\-_]+)+[\w\-.,@?^=%&:/~\\+#]*$");
final RegExp _moneda = RegExp(r"^(\$|\u00A3|\u00A5|\uFFE5)(\d*\.\d+|\d+)$");
final RegExp _valores = RegExp(r"^(\|\u00A3|\u00A5|\uFFE5)(\d*\.\d+|\d+)$");
final RegExp _ip = RegExp(
    r"^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
final RegExp _fecha = RegExp(r"^\d{4}[-/](0?[1-9]|1[012])[-/](0?[1-9]|[12][0-9]|3[01])$");
final RegExp _hora = RegExp(r"^([0-1]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9])?( ([A-Z]{3}|GMT [-+]([0-9]|1[0-2])))?$");
final RegExp _htmletiquetas = RegExp(r"^<(?:([A-Za-z][A-Za-z0-9]*)\b[^>]*>(?:.*?)</\1>|[A-Za-z][A-Za-z0-9]*\b[^/>]*/>)$", multiLine: true);
final RegExp _clavenormal = RegExp(r"^(?=.*\d)(?=.*[~!@#$%^&*()_\-+=|\\{}[\]:;<>?/])(?=.*[A-Z])(?=.*[a-z])\S{5,99}$");
final RegExp _clavemedia = RegExp(r"^(((?=.*[a-z])(?=.*[A-Z]))|((?=.*[a-z])(?=.*[0-9]))|((?=.*[A-Z])(?=.*[0-9])))(?=.{6,})");
final RegExp _tarjetacredito = RegExp(r"^(?:3[47]\d{2}([\- ]?)\d{6}\1\d{5}|(?:4\d{3}|5[1-5]\d{2}|6011)([\- ]?)\d{4}\2\d{4}\2\d{4})$");
// Se validan extensiones de archivos, falta verificar su uso y aplicacion
final RegExp _hexadecimal = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
final RegExp _vector = RegExp(r'.(svg)$');
final RegExp _image = RegExp(r'.(jpeg|jpg|gif|png|bmp|webp)$');
final RegExp _audio = RegExp(r'.(mp3|wav|wma|amr|ogg)$');
final RegExp _video = RegExp(r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp)$');
final RegExp _txt = RegExp(r'.txt$');
final RegExp _doc = RegExp(r'.(doc|docx)$');
final RegExp _excel = RegExp(r'.(xls|xlsx)$');
final RegExp _ppt = RegExp(r'.(ppt|pptx)$');
final RegExp _apk = RegExp(r'.apk$');
final RegExp _pdf = RegExp(r'.pdf$');
final RegExp _html = RegExp(r'.html$');

class _Validator {
  const _Validator();
  bool phone(String input) => _celular.hasMatch(input);
  bool name(String input) => _nombre.hasMatch(input);
  bool postalCode(String input) => _codigopostal.hasMatch(input);
  bool email(String input) => _email.hasMatch(input);
  bool url(String input) => _url.hasMatch(input);
  bool currency(String input) => _moneda.hasMatch(input);
  bool ip(String input) => _ip.hasMatch(input);
  bool date(String input) => _fecha.hasMatch(input);
  bool time(String input) => _hora.hasMatch(input);
  bool htmlTags(String input) => _htmletiquetas.hasMatch(input);
  bool password(String input) => _clavenormal.hasMatch(input);
  bool mediumPassword(String input) => _clavemedia.hasMatch(input);
  bool creditCard(String input) => _tarjetacredito.hasMatch(input);
  // Se validan extensiones de archivos, falta verificar su uso y aplicacion
  bool hexadecimal(String input) => _hexadecimal.hasMatch(input);
  bool vector(String input) => _vector.hasMatch(input);
  bool image(String input) => _image.hasMatch(input);
  bool audio(String input) => _audio.hasMatch(input);
  bool video(String input) => _video.hasMatch(input);
  bool txt(String input) => _txt.hasMatch(input);
  bool doc(String input) => _doc.hasMatch(input);
  bool excel(String input) => _excel.hasMatch(input);
  bool ppt(String input) => _ppt.hasMatch(input);
  bool apk(String input) => _apk.hasMatch(input);
  bool pdf(String input) => _pdf.hasMatch(input);
  bool html(String input) => _html.hasMatch(input);
  bool valores(String input) => _valores.hasMatch(input);
}

const _Validator validator = _Validator();

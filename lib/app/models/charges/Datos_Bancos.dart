class Datos_Bancos {
  late int item;
  late String codigo;
  late String nombre;
  late String numero_cuenta;

  Datos_Bancos(
    this.item,
    this.codigo,
    this.nombre,
    this.numero_cuenta,
  );
  Datos_Bancos.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    codigo = json['codigo'];
    nombre = json['nombre'];
    numero_cuenta = json['numero_cuenta'];
  }
}

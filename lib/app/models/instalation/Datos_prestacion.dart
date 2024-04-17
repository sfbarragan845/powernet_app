class Datos_Prestacion {
  late int item;
  late String codigo_prestacion;
  late String nombre_prestacion;
  late String precio_prestacion;
  late String tipo_plan_prestacion;

  Datos_Prestacion(
    this.item,
    this.codigo_prestacion,
    this.nombre_prestacion,
    this.precio_prestacion,
    this.tipo_plan_prestacion,
  );
  Datos_Prestacion.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    codigo_prestacion =
        json['codigo_prestacion'] == null ? '' : json['codigo_prestacion'];
    nombre_prestacion =
        json['nombre_prestacion'] == null ? '' : json['nombre_prestacion'];
    precio_prestacion =
        json['precio_prestacion'] == null ? '' : json['precio_prestacion'];
    tipo_plan_prestacion = json['tipo_plan_prestacion'] == null
        ? ''
        : json['tipo_plan_prestacion'];
  }
}

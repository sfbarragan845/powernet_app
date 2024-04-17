class Datos_Migracion {
  late int item;
  late String codigo;
  late String tipo;
  late String estado;
  late String id_tecnico;
  late String usuario_asignado;
  late String fecha_asignacion;
  late String direccion;
  late String celular_cliente_1;
  late String celular_cliente_2;
  late String celular_cliente_3;
  late String celular_contactar;
  late String persona_contactar;
  late String nombre_comercial;
  late String codigo_servicio;
  late String id_servicio;
  late String id_cliente;
  late String codigo_prestacion;
  late String nombre_prestacion;
  late String precio_prestacion;
  //late String celular;

  Datos_Migracion(
    this.item,
    this.codigo,
    this.tipo,
    this.estado,
    this.id_tecnico,
    this.usuario_asignado,
    this.fecha_asignacion,
    this.direccion,
    this.nombre_comercial,
    this.codigo_servicio,
    this.id_servicio,
    this.celular_cliente_1,
    this.celular_cliente_2,
    this.celular_cliente_3,
    this.celular_contactar,
    this.persona_contactar,
    this.id_cliente,
    this.codigo_prestacion,
    this.nombre_prestacion,
    this.precio_prestacion,
    //this.celular,
  );

  Datos_Migracion.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    codigo = json['codigo'];
    tipo = json['tipo'];
    estado = json['estado'] == null ? '' : json['estado'];
    id_tecnico = json['id_tecnico'] == null ? '' : json['id_tecnico'];
    usuario_asignado =
        json['usuario_asignado'] == null ? '' : json['usuario_asignado'];
    ;
    fecha_asignacion =
        json['fecha_asignacion'] == null ? '' : json['fecha_asignacion'];
    direccion = json['direccion'];
    nombre_comercial = json['nombre_comercial'];
    codigo_servicio = json['codigo_servicio'];
    id_servicio = json['id_servicio'];
    celular_cliente_1 =
        json['celular_cliente_1'] == null ? '' : json['celular_cliente_1'];
    celular_cliente_2 =
        json['celular_cliente_2'] == null ? '' : json['celular_cliente_2'];
    celular_cliente_3 =
        json['celular_cliente_3'] == null ? '' : json['celular_cliente_3'];
    celular_contactar = json['celular'] == null ? '' : json['celular'];
    persona_contactar =
        json['persona_contactar'] == null ? '' : json['persona_contactar'];
    id_tecnico = json['id_tecnico'] == null || json['id_tecnico'] == ''
        ? ''
        : json['id_tecnico'];
    id_cliente = json['id_cliente'];
    codigo_prestacion =
        json['codigo_prestacion'] == null || json['codigo_prestacion'] == ''
            ? ''
            : json['codigo_prestacion'];
    nombre_prestacion =
        json['nombre_prestacion'] == null || json['nombre_prestacion'] == ''
            ? ''
            : json['nombre_prestacion'];
    precio_prestacion =
        json['precio_prestacion'] == null || json['precio_prestacion'] == ''
            ? ''
            : json['precio_prestacion'];
    //celular = json['celular'];
  }
}

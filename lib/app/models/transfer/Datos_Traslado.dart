class Datos_Traslados {
  late int item;
  late String codigo;
  late String codigo_prestacion;
  late String nombre_prestacion;
  late String precio_prestacion;
  late String tipo;
  late String estado;
  late String id_tecnico;
  late String usuario_asignado;
  late String fecha_asignacion;
  late String latitud_actual;
  late String longitud_actual;
  late String latitud_nueva;
  late String longitud_nueva;
  late String codigo_servicio;
  late String id_servicio;
  late String persona_contactar;
  late String celular_contactar;
  late String celular_cliente_1;
  late String celular_cliente_2;
  late String celular_cliente_3;
  late String nombre_comercial;
  late String id_cliente;

  Datos_Traslados(
    this.item,
    this.codigo,
    this.codigo_prestacion,
    this.nombre_prestacion,
    this.precio_prestacion,
    this.tipo,
    this.estado,
    this.id_tecnico,
    this.usuario_asignado,
    this.fecha_asignacion,
    this.latitud_actual,
    this.longitud_actual,
    this.latitud_nueva,
    this.longitud_nueva,
    this.codigo_servicio,
    this.id_servicio,
    this.nombre_comercial,
    this.persona_contactar,
    this.celular_cliente_1,
    this.celular_cliente_2,
    this.celular_cliente_3,
    this.celular_contactar,
    this.id_cliente,
    //this.celular,
  );

  Datos_Traslados.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    codigo = json['codigo'];
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
    tipo = json['tipo'];
    estado = json['estado'] == null ? '' : json['estado'];
    id_tecnico = json['id_tecnico'] == null ? '' : json['id_tecnico'];
    usuario_asignado =
        json['usuario_asignado'] == null ? '' : json['usuario_asignado'];
    ;
    fecha_asignacion =
        json['fecha_asignacion'] == null ? '' : json['fecha_asignacion'];
    latitud_actual = json['latitud_actual'];
    longitud_actual = json['longitud_actual'];
    latitud_nueva = json['latitud_nueva'];
    longitud_nueva = json['longitud_nueva'];
    persona_contactar = json['persona_contactar'];
    celular_contactar =
        json['celular_contactar'] == null ? '0' : json['celular_contactar'];
    nombre_comercial = json['nombre_comercial'];
    codigo_servicio = json['codigo_servicio'];
    id_servicio = json['id_servicio'];
    celular_cliente_1 =
        json['celular_cliente_1'] == null ? '0' : json['celular_cliente_1'];
    celular_cliente_2 =
        json['celular_cliente_2'] == null ? '0' : json['celular_cliente_2'];
    celular_cliente_3 =
        json['celular_cliente_3'] == null ? '0' : json['celular_cliente_3'];
    id_tecnico = json['id_tecnico'] == null || json['id_tecnico'] == ''
        ? ''
        : json['id_tecnico'];
    id_cliente = json['id_cliente'];

    //celular = json['celular'];
  }
}

class Datos_Soportes {
  late int item;
  late String codigo;
  late String estado;
  late String fecha_reportado;
  late String fecha_visitar;
  late String usuario_asignado;
  late String fecha_asignacion;
  late String direccion;
  late String nombre_comercial;
  late String codigo_servicio;
  late String incidente;
  late String persona_contactar;
  late String celular_contactar;
  late String celular_cliente_1;
  late String celular_cliente_2;
  late String celular_cliente_3;
  late String id_tecnico;
  late String categoria_incidente;
  late String prioridad_servicio;
  late String id_cliente;
  late String id_servicio;
  late String tipoConexion;
  //late String celular;

  Datos_Soportes(
    this.item,
    this.codigo,
    this.estado,
    this.fecha_reportado,
    this.fecha_visitar,
    this.usuario_asignado,
    this.fecha_asignacion,
    this.direccion,
    this.nombre_comercial,
    this.codigo_servicio,
    this.incidente,
    this.persona_contactar,
    this.celular_cliente_1,
    this.celular_cliente_2,
    this.celular_cliente_3,
    this.celular_contactar,
    this.id_tecnico,
    this.categoria_incidente,
    this.prioridad_servicio,
    this.id_cliente,
    this.id_servicio,
    this.tipoConexion
    //this.celular,
  );

  Datos_Soportes.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    codigo = json['codigo'];
    estado = json['estado'];
    fecha_reportado =
        json['fecha_reportado'] == null ? '' : json['fecha_reportado'];
    fecha_visitar = json['fecha_visitar'];
    usuario_asignado = json['usuario_asignado'];
    fecha_asignacion =
        json['fecha_asignacion'] == null ? '' : json['fecha_asignacion'];
    direccion = json['direccion'];
    nombre_comercial = json['nombre_comercial'];
    codigo_servicio = json['codigo_servicio'];
    incidente = json['incidente'];
    celular_cliente_1 =
        json['celular_cliente_1'] == null ? '0' : json['celular_cliente_1'];
    celular_cliente_2 =
        json['celular_cliente_2'] == null ? '0' : json['celular_cliente_2'];
    celular_cliente_3 =
        json['celular_cliente_3'] == null ? '0' : json['celular_cliente_3'];
    celular_contactar =
        json['celular_soporte'] == null ? '0' : json['celular_soporte'];
    id_tecnico = json['id_tecnico'] == null || json['id_tecnico'] == ''
        ? ''
        : json['id_tecnico'];
    categoria_incidente = json['categoria_incidente'];
    prioridad_servicio = json['prioridad_servicio'];
    id_cliente = json['id_cliente'];
    id_servicio = json['id_servicio'];
    tipoConexion = json['conexion'];
    //celular = json['celular'];
  }
}

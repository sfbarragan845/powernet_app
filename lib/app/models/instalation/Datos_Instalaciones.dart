

class Datos_Instalaciones {
  late int item;
  late String codigo;
  late String estado;
  late String fecha_reportado;
  late String fecha_instalar;
  late String usuario_asignado;
  late String fecha_asignacion;
  late String direccion;
  late String nombre_comercial;
  late String codigo_servicio;
  late String celular_cliente_1;
  late String celular_cliente_2;
  late String celular_cliente_3;
  //late String prestacion;
  late String id_tecnico;
  late String id_cliente;
  late String observacion_servicio;
  late String tipoConexion;
  late String id_servicio;

  Datos_Instalaciones(
      this.item,
      this.codigo,
      this.estado,
      this.fecha_reportado,
      this.fecha_instalar,
      this.usuario_asignado,
      this.fecha_asignacion,
      this.direccion,
      this.nombre_comercial,
      this.codigo_servicio,
      //this.prestacion,
      this.id_tecnico,
      this.id_cliente,
      this.observacion_servicio,
      this.celular_cliente_1,
      this.celular_cliente_2,
      this.celular_cliente_3,
      this.tipoConexion,
      this.id_servicio
      );
  Datos_Instalaciones.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    codigo = json['codigo'];
    estado = json['estado'];
    fecha_reportado =
        json['fecha_reportado'] == null ? '' : json['fecha_reportado'];
    fecha_instalar = json['fecha_instalar'];
    usuario_asignado = json['usuario_asignado'];
    fecha_asignacion =
        json['fecha_asignacion'] == null ? '' : json['fecha_asignacion'];
    direccion = json['direccion'];
    nombre_comercial = json['nombre_comercial'];
    codigo_servicio = json['codigo_servicio'];
    //prestacion =(json['prestaciones']['data_prestacion'][0]['codigo_prestacion']);
    celular_cliente_1=json['celular_cliente_1'];
    celular_cliente_2=json['celular_cliente_2'];
    celular_cliente_3=json['celular_cliente_3'];
    id_tecnico = json['id_tecnico'];
    id_cliente = json['id_cliente'];
    observacion_servicio= json['observacion_servicio'];
    tipoConexion = json['tipo_conexion'];
    id_servicio = json['id_servicio'];
  }
}

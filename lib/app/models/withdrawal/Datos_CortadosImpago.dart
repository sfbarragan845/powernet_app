class Datos_CortadosImpago {
  late int item;
  late String estado;
  late String direccion;
  late String nombre_comercial;
  late String codigo_servicio;
  late String id_servicio;
  late String persona_contactar;
  late String celular_corteimpago;
  late String celular_cliente_1;
  late String celular_cliente_2;
  late String celular_cliente_3;
  late String id_cliente;
  late String tipo_conexion;
  //late String celular;

  Datos_CortadosImpago(
    this.item,
    this.estado,
    this.direccion,
    this.nombre_comercial,
    this.codigo_servicio,
    this.id_servicio,
    this.persona_contactar,
    this.celular_cliente_1,
    this.celular_cliente_2,
    this.celular_cliente_3,
    this.id_cliente,
    this.tipo_conexion,
    //this.celular,
  );

  Datos_CortadosImpago.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    estado = json['estado'] == null ? '' : json['estado'];
    direccion = json['direccion'] == null ? '' : json['direccion'];
    nombre_comercial =
        json['nombre_comercial'] == null ? '' : json['nombre_comercial'];
    codigo_servicio = json['codigo_servicio'];
    id_servicio = json['id_servicio'];
    persona_contactar =
        json['persona_contactar'] == null ? '' : json['persona_contactar'];
    celular_corteimpago =
        json['celular_corteimpago'] == null ? '0' : json['celular_corteimpago'];
    celular_cliente_1 =
        json['celular_cliente_1'] == null ? '0' : json['celular_cliente_1'];
    celular_cliente_2 =
        json['celular_cliente_2'] == null ? '0' : json['celular_cliente_2'];
    celular_cliente_3 =
        json['celular_cliente_3'] == null ? '0' : json['celular_cliente_3'];
    id_cliente = json['id_cliente'].toString();
    tipo_conexion =
        json['tipo_conexion'] == null ? '' : json['tipo_conexion'].toString();
  }
}

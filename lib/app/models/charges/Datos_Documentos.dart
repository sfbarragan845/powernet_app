class DatosDocumentos {
  late int items;
  late String codigo;
  late String fecha_documento;
  late String numero_documento;
  late double total_documento;
  late double total_pagar;
  late double abono_documento;
  late double saldo_documento;
  late int id_servicio;
  late int id_cliente;
  late String nombre_cliente;
  late String estado_servicio;
  late String codigo_servicio;

  DatosDocumentos({
    required this.items,
    required this.codigo,
    required this.fecha_documento,
    required this.numero_documento,
    required this.total_documento,
    required this.total_pagar,
    required this.abono_documento,
    required this.saldo_documento,
    required this.id_servicio,
    required this.id_cliente,
    required this.nombre_cliente,
    required this.estado_servicio,
    required this.codigo_servicio,
  });
  @override
  toString() =>
      '{"items":"$items","codigo":"$codigo","fecha_documento":"$fecha_documento","numero_documento":"$numero_documento","total_documento":"$total_documento","total_pagar":"$total_pagar","abono_documento":"$abono_documento","saldo_documento":"$saldo_documento","id_servicio":"$id_servicio","id_cliente":"$id_cliente","nombre_cliente":"$nombre_cliente","estado_servicio":"$estado_servicio","codigo_servicio":"$codigo_servicio"}';

  DatosDocumentos.fromJson(Map<String, dynamic> json) {
    items = json['item'] == null || json['item'] == '' ? '' : json['item'];
    codigo = json['codigo'].toString();
    fecha_documento = json['fecha_documento'].toString();
    numero_documento = json['numero_documento'].toString();
    total_documento = double.parse(json['total_documento']);
    total_pagar = double.parse(json['total_pagar']);
    abono_documento = double.parse(json['abono_documento']);
    saldo_documento = double.parse(json['saldo_documento']);
    id_servicio = int.parse(json['id_servicio']);
    id_cliente = int.parse(json['id_cliente']);
    nombre_cliente = json['nombre_cliente'].toString();
    estado_servicio = json['estado_servicio'].toString();
    codigo_servicio = json['codigo_servicio'].toString();
  }
}

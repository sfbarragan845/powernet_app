class lista_producto {
  late int items;
  late String codigo;
  late String codigoProducto;
  late String nombre;
  late String stock;
  late String precio;
  late String categoria;
  late String descripcion;
  late String foto;
  late String tipo;
  late double total;
  late String serie;
  late String series;

  lista_producto({
    required this.items,
    required this.codigo,
    required this.codigoProducto,
    required this.nombre,
    required this.stock,
    required this.precio,
    required this.categoria,
    required this.descripcion,
    required this.foto,
    required this.tipo,
    required this.serie,
    required this.series,
    required this.total,
  });
  @override
  toString() =>
      '{"items":"$items","codigo":"$codigo","codigoProducto":"$codigoProducto","nombre":"$nombre","stock":"$stock","serie":"$serie","series":"${series.toString()}"}';

  lista_producto.fromJson(Map<String, dynamic> json) {
    items = json['item'] == null || json['item'] == '' ? '' : json['item'];
    codigo = json['codigo'].toString();
    codigoProducto = json['codigo_producto'].toString();
    nombre = json['nombre'].toString();
    stock = json['stock'].toString();
    precio = json['precio'].toString();
    categoria = json['categoria'].toString();
    descripcion = json['descripcion'].toString();
    foto = json['foto'].toString();
    tipo = json['tipo'].toString();
    serie = json['serie'].toString();
    series = json['series'].toString();
    total = 0;
  }
}

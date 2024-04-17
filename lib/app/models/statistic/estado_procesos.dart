class EstadoProcesos {
  late int item;
  late String estado;
  late String cantidad;
  late String tipo;

  EstadoProcesos({
    required this.item,
    required this.estado,
    required this.cantidad,
    required this.tipo,
  });

  factory EstadoProcesos.fromJson(Map<String, dynamic> json) {
    return EstadoProcesos(
      item: json['item'],
      estado: json['estado'],
      cantidad: json['cantidad'],
      tipo: json['tipo'],
    );
  }
  @override
  toString() =>
      '{"item":"$item","estado":"$estado","cantidad":"$cantidad","tipo":"$tipo"}';
}

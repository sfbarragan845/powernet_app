class TecnicoModel {
  late int item;
  late String codigo;
  late String tecnicos;

  TecnicoModel(
      {required this.item, required this.codigo, required this.tecnicos});

  factory TecnicoModel.fromJson(Map<String, dynamic> json) {
    return TecnicoModel(
      item: json['item'] ?? 0,
      codigo: json['codigo'] ?? '0',
      tecnicos: json['tecnicos'] ?? '',
    );
  }
  @override
  toString() => '{"item":"$item","codigo":"$codigo","tecnicos":"$tecnicos"}';
}

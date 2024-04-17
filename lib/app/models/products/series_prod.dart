class lista_seriesProd {
  late String items;
  late String codigo;
  late String serie1;
  late String serie2;
  late String serie3;
  late String estado;
  late String observacion;
  late String garantia_vigente;

  lista_seriesProd({
    required this.items,
    required this.codigo,
    required this.serie1,
    required this.serie2,
    required this.serie3,
    required this.estado,
    required this.observacion,
    required this.garantia_vigente,
  });
  @override
  toString() =>
      '[{"items":"$items","codigo":"$codigo","serie1":"$serie1","serie2":"$serie2","serie3":"$serie3","estado":"$estado","observacion":"${observacion.toString()}","garantia_vigente":"$garantia_vigente"}]';

  lista_seriesProd.fromJson(Map<String, dynamic> json) {
    items=json['item'].toString();
    codigo=json['codigo'].toString();
    serie1=json['serie1'].toString();
    serie2=json['serie2']==''||json['serie2']==null||json['serie2']==[]?'':json['serie2'].toString();
    serie3=json['serie3']==''||json['serie3']==null||json['serie3']==[]?'':json['serie3'].toString();
    estado=json['estado'].toString();
    observacion=json['observacion'].toString();
    garantia_vigente=json['garantia_vigente'];
  }
}

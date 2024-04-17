class lista_series_garantia {
  late String items;
  late String codigo_pro;
  late String nombre_pro;
  late String codigo;
  late String serie1;
  late String serie2;
  late String serie3;
  late String estado;
  late String observacion;
  late String garantia_vigente;
  late String vencimiento_garantia;

  lista_series_garantia({
    required this.items,
    required this.codigo_pro,
    required this.nombre_pro,
    required this.codigo,
    required this.serie1,
    required this.serie2,
    required this.serie3,
    required this.estado,
    required this.observacion,
    required this.garantia_vigente,
    required this.vencimiento_garantia,
  });
  @override
  toString() =>
      '[{"items":"$items","codigo":"$codigo","serie1":"$serie1","serie2":"$serie2","serie3":"$serie3","estado":"$estado","observacion":"${observacion.toString()}","garantia_vigente":"$garantia_vigente"}]';

  lista_series_garantia.fromJson(Map<String, dynamic> json) {
    items=json['item'].toString();
    codigo_pro=json['codigo_producto'];
    nombre_pro = json['nombre_producto'];
    codigo=json['codigo'].toString();
    serie1=json['serie1'].toString();
    serie2=json['serie2']==''||json['serie2']==null||json['serie2']==[]?'':json['serie2'].toString();
    serie3=json['serie3']==''||json['serie3']==null||json['serie3']==[]?'':json['serie3'].toString();
    estado=json['estado'].toString();
    observacion=json['observacion'].toString();
    garantia_vigente=json['garantia_vigente'];
    vencimiento_garantia=json['vencimiento_garantia'];
  }
}

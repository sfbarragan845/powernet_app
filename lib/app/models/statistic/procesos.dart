import 'package:powernet/app/models/statistic/estado_procesos.dart';

class ProcesosModel {
  List<EstadoProcesos> instalaciones;
  List<EstadoProcesos> soportes;
  List<EstadoProcesos> migraciones;
  List<EstadoProcesos> traslados;

  ProcesosModel({
    required this.instalaciones,
    required this.soportes,
    required this.migraciones,
    required this.traslados,
  });

  factory ProcesosModel.fromJson(Map<String, dynamic> json) {
    List<EstadoProcesos> instalacionesList = (json['instalaciones'] as List)
        .map((item) => EstadoProcesos.fromJson(item))
        .toList();
    List<EstadoProcesos> migracionesList = (json['migraciones'] as List)
        .map((item) => EstadoProcesos.fromJson(item))
        .toList();
    List<EstadoProcesos> soportesList = (json['soportes'] as List)
        .map((item) => EstadoProcesos.fromJson(item))
        .toList();
    List<EstadoProcesos> trasladosList = (json['traslados'] as List)
        .map((item) => EstadoProcesos.fromJson(item))
        .toList();

    return ProcesosModel(
      instalaciones: instalacionesList,
      migraciones: migracionesList,
      soportes: soportesList,
      traslados: trasladosList,
    );
  }
}

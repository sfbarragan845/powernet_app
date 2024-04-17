import 'dart:async';

import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powernet/app/api/internas/public/select/statistic/api_estadistica.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../../../models/statistic/estado_procesos.dart';
import '../../../../models/statistic/procesos.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '/app/models/var_global.dart' as global;

class EstadisticaScreens extends StatefulWidget {
  const EstadisticaScreens({super.key});

  @override
  State<EstadisticaScreens> createState() => _EstadisticaScreensState();
}

class _EstadisticaScreensState extends State<EstadisticaScreens> {
  late Timer _timer;

  void startTimer() {
    // Crea un Timer periódico que se ejecutará cada 5 segundos
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // Llama a la función `initial` aquí
      loadStatistics();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      DateTime fechaConHora = DateTime.now(); // Obtiene la fecha y hora actual
      DateTime fechaSinHora =
          DateTime(fechaConHora.year, fechaConHora.month, fechaConHora.day);
      global.startDate = fechaSinHora;
      global.endDate = fechaSinHora;
      global.id_technician = '0';
      global.statistic_type_process = 'INSTALACION';
    });
    // Añadir un listener para detectar cambios de pestaña

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer
        .cancel(); // Detiene el Timer cuando el widget se destruye para evitar fugas de memoria
  }

  Future<void> loadStatistics() async {
    final data = await processStateStatistic();
    if (data != null) {
      if (mounted) {
        setState(() {
          global.listProcessState.clear();

          ProcesosModel dataModel = ProcesosModel(
            instalaciones: (data['data']['instalaciones'] as List)
                .map((item) => EstadoProcesos.fromJson(item))
                .toList(),
            migraciones: (data['data']['migraciones'] as List)
                .map((item) => EstadoProcesos.fromJson(item))
                .toList(),
            soportes: (data['data']['soportes'] as List)
                .map((item) => EstadoProcesos.fromJson(item))
                .toList(),
            traslados: (data['data']['traslados'] as List)
                .map((item) => EstadoProcesos.fromJson(item))
                .toList(),
          );
          print(dataModel.soportes);
          global.listProcessState.add(dataModel);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.white,
              labelColor: ColorFondo.BTNUBI,
              unselectedLabelColor: const Color.fromRGBO(255, 255, 255, 1),
              labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(
                fontSize: 10,
              ),
              tabs: [
                Tab(
                    icon: Container(
                        width: 21,
                        child: Image.asset(
                            'assets/images/instalaciones_blanco.png')),
                    child: Text(
                      'Instalación',
                    )),
                Tab(
                    icon: Container(
                        height: 21,
                        child: Image.asset(
                            'assets/images/totalsoporte_blanco.png')),
                    child: Text('Soporte')),
                Tab(
                    icon: Container(
                        height: 21,
                        child:
                            Image.asset('assets/images/migracion_blanco.png')),
                    child: Text('Migración')),
                Tab(
                    icon: Container(
                        height: 21,
                        child:
                            Image.asset('assets/images/traslados_blanco.png')),
                    child: Text('Traslado')),
              ],
            ),
            title: Text('Estadística',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          drawer: const MenuPrincipal(),
          body: TabBarView(children: [
            statistics('INSTALACION'),
            statistics('SOPORTE'),
            statistics('MIGRACION'),
            statistics('TRASLADO')
          ]),
        ));
  }

  Widget statistics(tipo) {
    double varWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(children: [
        SizedBox(
          height: 20,
        ),
        dateTimePicker(varWidth),
        SizedBox(
          height: 20,
        ),
        selectTechnician(varWidth),
        SizedBox(
          height: 20,
        ),
        Center(
          child: global.listProcessState.length == 0
              ? Image.asset('assets/images/loading_chart.gif')
              : Column(
                  children: <Widget>[
                    Container(
                      height: 300,
                      child: SfCartesianChart(
                        primaryXAxis:
                            CategoryAxis(), // Definir un eje de categoría
                        isTransposed: true,
                        series: <BarSeries<EstadoProcesos, String>>[
                          BarSeries<EstadoProcesos, String>(
                            dataSource: tipo == 'INSTALACION'
                                ? global.listProcessState[0].instalaciones
                                : tipo == 'SOPORTE'
                                    ? global.listProcessState[0].soportes
                                    : tipo == 'MIGRACION'
                                        ? global.listProcessState[0].migraciones
                                        : global.listProcessState[0].traslados,
                            xValueMapper: (EstadoProcesos proceso, _) =>
                                proceso.estado,
                            yValueMapper: (EstadoProcesos proceso, _) =>
                                int.parse(proceso.cantidad),
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true, textStyle: TextStyle(color:ColorFondo.BTNUBI)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        )
      ]),
    );
  }

  Widget dateTimePicker(varWidth) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(ColorFondo.BTNUBI)),
      onPressed: () {
        showCustomDateRangePicker(context,
            dismissible: true,
            minimumDate: DateTime(2010, 1, 1),
            maximumDate: DateTime.now().add(const Duration(days: 30)),
            endDate: global.endDate,
            startDate: global.startDate, onApplyClick: (start, end) {
          setState(() {
            global.endDate = end;
            global.startDate = start;
          });
          loadStatistics();
        },
            onCancelClick: () {},
            backgroundColor: ColorFondo.BLANCO,
            primaryColor: ColorFondo.PRIMARY);
      },
      child: Container(
          width: varWidth / 1.8,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  DateFormat(
                          'dd/MM/yyyy - ${DateFormat('dd/MM/yyyy').format(global.endDate!)}')
                      .format(global.startDate!),
                  style: TextStyle(color: Colors.white)),
              const Icon(Icons.calendar_today_outlined, color: Colors.white),
            ],
          )),
    );
  }

  Widget selectTechnician(varWidth) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          sombra(Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Tecnicos: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: varWidth,
                      child: SearchableDropdown<int>(
                        hintText: Text('${global.selected_technician}'),
                        margin: const EdgeInsets.all(15),
                        items: List.generate(
                            global.listTecnicos.length,
                            (i) => SearchableDropdownMenuItem(
                                value: int.parse(global.listTecnicos[i].codigo),
                                label: global.listTecnicos[i].tecnicos,
                                child: Container(
                                  width: varWidth * 0.7,
                                  child: Text(global.listTecnicos[i].tecnicos),
                                ))),
                        onChanged: (int? value) {
                          if (value != null) {
                            debugPrint('$value');
                            setState(() {
                              print('mi value ${value}');
                              global.id_technician = value.toString();

                              int posicion = global.listTecnicos.indexWhere(
                                  (elemento) =>
                                      elemento.codigo == global.id_technician);
                              print(posicion);
                              if (posicion != -1) {
                                global.selected_technician =
                                    global.listTecnicos[posicion].tecnicos;
                              } else {
                                global.selected_technician = 'TODOS';
                              }
                            });
                          } else {
                            setState(() {
                              global.id_technician = '0';
                            });
                          }

                          loadStatistics();
                        },
                      ))),
            ],
          )))
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../api/internas/public/select/api_listado_cortadosimpago.dart';
import '../../../../api/internas/public/select/api_listado_suspenciones.dart';
import '../../../../api/internas/public/select/process_detail/api_detalleUsuario_CortadosImpago.dart';
import '../../../../api/internas/public/select/process_detail/api_detalleUsuario_Suspencion.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../models/withdrawal/Datos_CortadosImpago.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '../../registrarSolucionRetiro/screens/registrar_solucion_retiro.dart';
import '../widget/contactos_retiros.dart';
import '../widget/select_cortadosimpago.dart';
import '/app/models/var_global.dart' as global;

class ProcesoEspecificoRetiros extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ProcesoEspecificoRetiros(),
    );
  }

  @override
  _ProcesoEspecificoRetiros createState() => _ProcesoEspecificoRetiros();
}

class _ProcesoEspecificoRetiros extends State<ProcesoEspecificoRetiros> {
  var suma = 0;
  int nowAnio = DateTime.now().year;
  int nowMon = DateTime.now().month;
  int nowDay = DateTime.now().day;

  List<Datos_CortadosImpago> _foundCortadosImpago = [];
  List<Datos_CortadosImpago> _foundSuspencion = [];

  final _formKey = GlobalKey<FormState>();
  final _formKeySuspencion = GlobalKey<FormState>();
  int _cant = 0;
  String _tipocondicion = 'Select...';
  String _tipoape = 'Select...';
  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = ColorFondo.BTNUBI;
  String _tipotecnico = 'Seleccionar';
  @override
  void initState() {
    super.initState();

    //Borrar Despues
    global.ListadoInstalacion.clear();

    //CLEAR cut off for non-payment LISTS
    global.ListadoCortadosImpago.clear();
    _foundCortadosImpago.clear();

    global.ListadoSuspenciones.clear();
    _foundSuspencion.clear();

    listadoCortadosImpago('').then((value) {
      if (mounted) {
        setState(() {
          print(value);
          global.ListadoCortadosImpago.addAll(value);
          _foundCortadosImpago.addAll(global.ListadoCortadosImpago);
        });
      }
    });

    listadoSuspenciones('').then((value) {
      if (mounted) {
        setState(() {
          print('aqui mis suspenciones');
          print(value);
          global.ListadoSuspenciones.addAll(value);
          _foundSuspencion.addAll(global.ListadoSuspenciones);
        });
      }
    });
  }

  // SEARCH FILTER
  void _filtroCortadosImpago(String busqueda) {
    List<Datos_CortadosImpago> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.ListadoCortadosImpago;
      } else {
        results = global.ListadoCortadosImpago.where((cortados) {
          Intl.defaultLocale = 'es';
          return cortados.nombre_comercial
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              cortados.codigo_servicio
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }
      setState(() {
        this._foundCortadosImpago = results;
      });
    }
  }

  void _filtroSuspencion(String busqueda) {
    List<Datos_CortadosImpago> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.ListadoSuspenciones;
      } else {
        results = global.ListadoSuspenciones.where((suspencion) {
          Intl.defaultLocale = 'es';
          return suspencion.nombre_comercial
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              suspencion.codigo_servicio
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }
      setState(() {
        this._foundSuspencion = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            global.tipoRequerimiento,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: ColorFondo.PRIMARY,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
                fontSize: 17.0,
                fontFamily: 'Family Name',
                fontWeight: FontWeight.bold), //For Selected tab
            unselectedLabelStyle: TextStyle(
                fontSize: 12.0,
                fontFamily: 'Family Name'), //For Un-selected Tabs
            tabs: [
              Tab(
                text: "Cortados Impago",
              ),
              Tab(text: "Suspenciones"),
            ],
          ),
        ),
        drawer: const MenuPrincipal(),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: sombra(
                              Container(
                                width: varWidth,
                                child: TextField(
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    onChanged: (value) =>
                                        _filtroCortadosImpago(value),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              width: 2, color: Colors.white54)),
                                      labelStyle: TextStyle(
                                          color: Color.fromARGB(137, 0, 0, 0)),
                                      labelText: 'Busqueda inteligente',
                                      suffixIcon: Icon(Icons.search,
                                          color: Colors.white54),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white54)),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Color.fromARGB(255, 161, 161, 161),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          //color: Colors.blue,
                          width: 110,

                          child: Text(
                            'IP Radio',
                            style: TextStyle(
                                fontSize: 15,
                                color: _colorColum2,
                                fontWeight: FontWeight.bold),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          //color: Colors.red,
                          width: 150,
                          child: Text(
                            'Apellidos y Nombres',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: _colorColum1),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SingleChildScrollView(
                      //scrollDirection: Axis.horizontal,
                      child: Container(
                        //color: Colors.amber,
                        height: varHeight * 0.64,
                        child: ListView.separated(
                          itemCount: _foundCortadosImpago.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                            color: Colors.black,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color.fromARGB(255, 8, 112, 162),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 110,
                                          child: Text(
                                            _foundCortadosImpago[index]
                                                .tipo_conexion,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _colorColum1),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ProgressDialog progressDialog =
                                              ProgressDialog(context);
                                          progressDialog.show();
                                          setState(() {
                                            global.id_pk =
                                                _foundCortadosImpago[index]
                                                    .id_servicio;
                                          });
                                          DetalleCortadoImpago(global.id_pk)
                                              .then((_) {
                                            detallecortadoimpago.then((value) {
                                              print('Prueba API Pedidos');
                                              print('aqii');
                                              print(value['success']);
                                              if (value['success'] == 'OK') {
                                                print(value);
                                                setState(() {
                                                  global.identidad_detCortados =
                                                      value['data'][0]
                                                          ['identidad'];
                                                  global.itemDetSoporte =
                                                      value['data'][0]['item'];
                                                  global.cliente_detCortados =
                                                      value['data'][0]
                                                          ['cliente'];
                                                  global.codigo_servicio_detCortados =
                                                      value['data'][0]
                                                          ['codigo_servicio'];
                                                  global.ancho_banda_subida_detCortados =
                                                      value['data'][0][
                                                              'ancho_banda_subida'] ??
                                                          '0';
                                                  global.ancho_banda_bajada_detCortados =
                                                      value['data'][0][
                                                              'ancho_banda_bajada'] ??
                                                          '0';
                                                  global.comparticion_detCortados =
                                                      value['data'][0]
                                                          ['comparticion'];
                                                  global.estado_servicio_detCortados =
                                                      value['data'][0]
                                                          ['estado_servicio'];
                                                  global.latitud_detCortados =
                                                      value['data'][0]
                                                              ['latitud'] ??
                                                          '0';
                                                  global.longitud_detCortados =
                                                      value['data'][0]
                                                              ['longitud'] ??
                                                          '0';
                                                  global.contactar_detCortados =
                                                      value['data'][0]
                                                              ['contactar'] ??
                                                          '0';
                                                  global.direccion_detCortados =
                                                      value['data'][0]
                                                          ['direccion'];
                                                  global.codigo_cliente_detCortados =
                                                      value['data'][0]
                                                          ['codigo_cliente'];
                                                  global.ip_servicio_detCortados =
                                                      value['data'][0]
                                                          ['ip_servicio'];
                                                  global.saldo_servicio_detCortados =
                                                      value['data'][0][
                                                              'saldo_servicio'] +
                                                          0.00;
                                                  global.fecha_factura_detCortados =
                                                      value['data'][0]
                                                          ['fecha_factura'];
                                                  global.fecha_corte_detCortados =
                                                      value['data'][0]
                                                          ['fecha_corte'];
                                                  global.meses_activos_detCortados =
                                                      value['data'][0]
                                                          ['meses_activos'];
                                                  global.referencias_personales_detCortados =
                                                      value['data'][0][
                                                          'referencias_personales'];
                                                  global.foto_servicio_detCortados =
                                                      value['data'][0]
                                                          ['foto_servicio'];
                                                });
                                                progressDialog.dismiss();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectCortadosImpago()));
                                              } else if (value['success'] ==
                                                  'ERROR') {
                                                mostrarError(
                                                    context, value['mensaje']);
                                              }
                                            });
                                          });

                                          print('Valencia Quitnero');
                                        },
                                        child: Container(
                                          width: 200,
                                          child: Center(
                                              child: Text(
                                            _foundCortadosImpago[index]
                                                .nombre_comercial,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: _colorColum2),
                                            textAlign: TextAlign.center,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: varWidth,
                                    height: varHeight * 0.08,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorFondo.BTNUBI,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          _foundCortadosImpago[index]
                                                      .nombre_comercial ==
                                                  ''
                                              ? MainAxisAlignment.center
                                              : MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            ProgressDialog progressDialog =
                                                ProgressDialog(context);
                                            progressDialog.show();
                                            setState(() {
                                              global.id_pk =
                                                  _foundCortadosImpago[index]
                                                      .id_servicio;
                                            });
                                            DetalleCortadoImpago(global.id_pk)
                                                .then((_) {
                                              detallecortadoimpago
                                                  .then((value) {
                                                print('Prueba API Pedidos');
                                                print('aqii');
                                                print(value['success']);
                                                if (value['success'] == 'OK') {
                                                  print(value);
                                                  setState(() {
                                                    global.identidad_detCortados =
                                                        value['data'][0]
                                                            ['identidad'];
                                                    global.itemDetSoporte =
                                                        value['data'][0]
                                                            ['item'];
                                                    global.cliente_detCortados =
                                                        value['data'][0]
                                                            ['cliente'];
                                                    global.codigo_servicio_detCortados =
                                                        value['data'][0]
                                                            ['codigo_servicio'];
                                                    global.ancho_banda_subida_detCortados =
                                                        value['data'][0][
                                                                'ancho_banda_subida'] ??
                                                            '0';
                                                    global.ancho_banda_bajada_detCortados =
                                                        value['data'][0][
                                                                'ancho_banda_bajada'] ??
                                                            '0';
                                                    global.comparticion_detCortados =
                                                        value['data'][0]
                                                            ['comparticion'];
                                                    global.estado_servicio_detCortados =
                                                        value['data'][0]
                                                            ['estado_servicio'];
                                                    global.latitud_detCortados =
                                                        value['data'][0]
                                                                ['latitud'] ??
                                                            '0';
                                                    global.longitud_detCortados =
                                                        value['data'][0]
                                                                ['longitud'] ??
                                                            '0';
                                                    global.contactar_detCortados =
                                                        value['data'][0]
                                                                ['contactar'] ??
                                                            '0';
                                                    global.direccion_detCortados =
                                                        value['data'][0]
                                                            ['direccion'];
                                                    global.codigo_cliente_detCortados =
                                                        value['data'][0]
                                                            ['codigo_cliente'];
                                                    global.ip_servicio_detCortados =
                                                        value['data'][0]
                                                            ['ip_servicio'];
                                                    global.saldo_servicio_detCortados =
                                                        value['data'][0][
                                                                'saldo_servicio'] +
                                                            0.00;
                                                    global.fecha_factura_detCortados =
                                                        value['data'][0]
                                                            ['fecha_factura'];
                                                    global.fecha_corte_detCortados =
                                                        value['data'][0]
                                                            ['fecha_corte'];
                                                    global.meses_activos_detCortados =
                                                        value['data'][0]
                                                            ['meses_activos'];
                                                    global.referencias_personales_detCortados =
                                                        value['data'][0][
                                                            'referencias_personales'];
                                                    global.foto_servicio_detCortados =
                                                        value['data'][0]
                                                            ['foto_servicio'];
                                                    global.ip_radio_detCortados =
                                                        value['data'][0]
                                                            ['ip_radio'];
                                                  });
                                                  progressDialog.dismiss();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SelectCortadosImpago()));
                                                } else if (value['success'] ==
                                                    'ERROR') {
                                                  mostrarError(context,
                                                      value['mensaje']);
                                                }
                                              });
                                            });
                                          },
                                          child: Container(
                                            width: varWidth / 3.5,
                                            height: varHeight,
                                            //color: Colors.amber,
                                            child: Center(
                                                child: Text('Detalle',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17))),
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: Container(
                                            width: 2,
                                            height: varHeight,
                                            color: Color(0xFF808080),
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: GestureDetector(
                                            onTap: () async {
                                              ProgressDialog progressDialog =
                                                  ProgressDialog(context);
                                              progressDialog.show();
                                              List<String> coorLat = [''];
                                              List<String> coorLng = [''];
                                              var status = await Permission
                                                  .location.status;
                                              global.id_pk =
                                                  _foundCortadosImpago[index]
                                                      .id_servicio;
                                              global.id_cliente =
                                                  _foundCortadosImpago[index]
                                                      .id_cliente;
                                              print("codigo");
                                              print(_foundCortadosImpago[index]
                                                  .id_servicio);
                                              print(global.id_pk);
                                              progressDialog.dismiss();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegistrarSolucionRetiro()));

                                              /* if (status.isDenied) {
                                                if (await Permission.location
                                                    .request()
                                                    .isGranted) {
                                                  List<String> coordenadas = [
                                                    ''
                                                  ];
                                                  if (status.isDenied) {
                                                    if (await Permission
                                                        .location
                                                        .request()
                                                        .isGranted) {
                                                      final postInicial =
                                                          await Geolocator
                                                              .getCurrentPosition();
                                                      final String posi =
                                                          postInicial
                                                              .toString();
                                                      var now = DateTime.now();
                                                      var formatter =
                                                          DateFormat(
                                                              'yyyy-MM-dd');
                                                      String formattedDate =
                                                          formatter.format(now);

                                                      if (postInicial != '') {
                                                        setState(() {
                                                          //Preferences.DateRequest = formattedDate;

                                                          coordenadas =
                                                              posi.split(',');
                                                          if (coordenadas
                                                                  .first !=
                                                              '') {
                                                            coorLat =
                                                                (coordenadas
                                                                        .first)
                                                                    .split(
                                                                        ': ');
                                                            coorLng =
                                                                (coordenadas
                                                                        .last)
                                                                    .split(
                                                                        ': ');
                                                          }

                                                          print(
                                                              'Estoy por aquiii2 ${coorLat.last}');
                                                          print(
                                                              'Estoy por fueraAAA ${coorLng.last}');
                                                          //_postEnviarUbicacion.call();
                                                        });
                                                      } else {
                                                        if (await Permission
                                                            .speech
                                                            .isPermanentlyDenied) {
                                                          openAppSettings();
                                                        }
                                                        mostrarError(context,
                                                            'No hay acceso a la ubicación');
                                                      }
                                                    } else {
                                                      final postInicial =
                                                          await Geolocator
                                                              .getCurrentPosition();
                                                      final String posi =
                                                          postInicial
                                                              .toString();
                                                      var now = DateTime.now();
                                                      var formatter =
                                                          DateFormat(
                                                              'yyyy-MM-dd');
                                                      String formattedDate =
                                                          formatter.format(now);
                                                      if (postInicial != '') {
                                                        setState(() {
                                                          //Preferences.DateRequest = formattedDate;

                                                          coordenadas =
                                                              posi.split(',');
                                                          if (coordenadas
                                                                  .first !=
                                                              '') {
                                                            coorLat =
                                                                (coordenadas
                                                                        .first)
                                                                    .split(
                                                                        ': ');
                                                            coorLng =
                                                                (coordenadas
                                                                        .last)
                                                                    .split(
                                                                        ': ');
                                                          }

                                                          print(
                                                              'Estoy por aquiii3 ${coorLat.last}');
                                                          print(
                                                              'Estoy por fueraAAA ${coorLng.last}');
                                                          //_postEnviarUbicacion.call();
                                                        });
                                                      }
                                                    }
                                                  } else {
                                                    print('aqui');
                                                    if (await Permission.speech
                                                        .isPermanentlyDenied) {
                                                      print('aqui2');

                                                      openAppSettings();
                                                    } else {
                                                      openAppSettings();
                                                    }
                                                    mostrarError(context,
                                                        'Se requiere acceso a ubicación');
                                                  }
                                                } else {
                                                  if (await Permission.location
                                                      .request()
                                                      .isGranted) {
                                                    List<String> coordenadas = [
                                                      ''
                                                    ];
                                                    if (status.isDenied) {
                                                      if (await Permission
                                                          .location
                                                          .request()
                                                          .isGranted) {
                                                        final postInicial =
                                                            await Geolocator
                                                                .getCurrentPosition();
                                                        final String posi =
                                                            postInicial
                                                                .toString();
                                                        var now =
                                                            DateTime.now();
                                                        var formatter =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        String formattedDate =
                                                            formatter
                                                                .format(now);
                                                        if (postInicial != '') {
                                                          setState(() {
                                                            //Preferences.DateRequest = formattedDate;

                                                            coordenadas =
                                                                posi.split(',');
                                                            if (coordenadas
                                                                    .first !=
                                                                '') {
                                                              coorLat =
                                                                  (coordenadas
                                                                          .first)
                                                                      .split(
                                                                          ': ');
                                                              coorLng =
                                                                  (coordenadas
                                                                          .last)
                                                                      .split(
                                                                          ': ');
                                                            }

                                                            print(
                                                                'Estoy por aquiii4 ${coorLat.last}');
                                                            print(
                                                                'Estoy por fueraAAA ${coorLng.last}');
                                                            //_postEnviarUbicacion.call();
                                                          });
                                                        }
                                                      } else {
                                                        if (await Permission
                                                            .speech
                                                            .isPermanentlyDenied) {
                                                          openAppSettings();
                                                        }
                                                        mostrarError(context,
                                                            'No hay acceso a la ubicación');
                                                      }
                                                    } else {
                                                      final postInicial =
                                                          await Geolocator
                                                              .getCurrentPosition();
                                                      final String posi =
                                                          postInicial
                                                              .toString();
                                                      var now = DateTime.now();
                                                      var formatter =
                                                          DateFormat(
                                                              'yyyy-MM-dd');
                                                      String formattedDate =
                                                          formatter.format(now);
                                                      if (postInicial != '') {
                                                        setState(() {
                                                          //Preferences.DateRequest = formattedDate;

                                                          coordenadas =
                                                              posi.split(',');
                                                          if (coordenadas
                                                                  .first !=
                                                              '') {
                                                            coorLat =
                                                                (coordenadas
                                                                        .first)
                                                                    .split(
                                                                        ': ');
                                                            coorLng =
                                                                (coordenadas
                                                                        .last)
                                                                    .split(
                                                                        ': ');
                                                          }

                                                          print(
                                                              'Estoy por aquiii5 ${coorLat.last}');
                                                          print(
                                                              'Estoy por fueraAAA ${coorLng.last}');
                                                          //_postEnviarUbicacion.call();

                                                          global.clienteFactura =
                                                              _foundCortadosImpago[
                                                                      index]
                                                                  .nombre_comercial;
                                                          print('aqui');
                                                          print(global
                                                              .clienteFactura);
                                                        });
                                                      }
                                                    }
                                                  } else {
                                                    print('aqui');
                                                    if (await Permission.speech
                                                        .isPermanentlyDenied) {
                                                      print('aqui2');

                                                      openAppSettings();
                                                    } else {
                                                      openAppSettings();
                                                    }
                                                    mostrarError(context,
                                                        'Se requiere acceso a ubicación');
                                                  }
                                                }
                                              } */
                                            },
                                            child: Container(
                                              width: varWidth / 3.5,
                                              height: varHeight,
                                              //0color: Colors.blueAccent,
                                              child: Center(
                                                  child: Text('Solucionar',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17))),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 2,
                                          height: varHeight,
                                          color: Color(0xFF808080),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              global.celular1_detCortados =
                                                  _foundCortadosImpago[index]
                                                      .celular_cliente_1
                                                      .toString();
                                              global.celular2_detCortados =
                                                  _foundCortadosImpago[index]
                                                      .celular_cliente_2
                                                      .toString();
                                              global.celular3_detCortados =
                                                  _foundCortadosImpago[index]
                                                      .celular_cliente_3
                                                      .toString();
                                              global.celular_corteimpago_detCortados =
                                                  _foundCortadosImpago[index]
                                                      .celular_corteimpago
                                                      .toString();

                                              print(
                                                  global.celular1_detCortados);

                                              print(
                                                  global.celular2_detCortados);
                                              print(
                                                  global.celular3_detCortados);
                                              print(
                                                  global.celular1_detCortados);
                                            });
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    ContactosRetiros.route());
                                          },
                                          child: Container(
                                            width: varWidth / 3.5,
                                            height: varHeight,
                                            //color: Colors.redAccent,
                                            child: Center(
                                                child: Text('Contactos',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17))),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //SECONDARY TAB
            SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKeySuspencion,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: sombra(
                                Container(
                                  width: varWidth,
                                  child: TextField(
                                      style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      onChanged: (value) =>
                                          _filtroSuspencion(value),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                color: Colors.white54)),
                                        labelStyle: TextStyle(
                                            color:
                                                Color.fromARGB(137, 0, 0, 0)),
                                        labelText: 'Busqueda inteligente',
                                        suffixIcon: Icon(Icons.search,
                                            color: Colors.white54),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white54)),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color.fromARGB(255, 161, 161, 161),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            //color: Colors.blue,
                            width: 110,

                            child: Text(
                              'IP Radio',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: _colorColum2,
                                  fontWeight: FontWeight.bold),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            //color: Colors.red,
                            width: 150,
                            child: Text(
                              'Apellidos y Nombres',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: _colorColum1),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SingleChildScrollView(
                        //scrollDirection: Axis.horizontal,
                        child: Container(
                          //color: Colors.amber,
                          height: varHeight * 0.64,
                          child: ListView.separated(
                            itemCount: _foundSuspencion.length,
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const Divider(
                              color: Colors.black,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 8, 112, 162),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 110,
                                            child: Text(
                                              _foundSuspencion[index]
                                                  .tipo_conexion,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: _colorColum1),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ProgressDialog progressDialog =
                                                ProgressDialog(context);
                                            progressDialog.show();
                                            setState(() {
                                              global.id_pk =
                                                  _foundSuspencion[index]
                                                      .id_servicio;
                                            });
                                            DetalleSuspenciones(global.id_pk)
                                                .then((_) {
                                              detallesuspenciones.then((value) {
                                                print('Prueba API Pedidos');
                                                print('aqii');
                                                print(value['success']);
                                                if (value['success'] == 'OK') {
                                                  print(value);
                                                  setState(() {
                                                    print('2');
                                                    global.identidad_detCortados =
                                                        value['data'][0]
                                                            ['identidad'];
                                                    global.itemDetSoporte =
                                                        value['data'][0]
                                                            ['item'];
                                                    global.cliente_detCortados =
                                                        value['data'][0]
                                                            ['cliente'];
                                                    global.codigo_servicio_detCortados =
                                                        value['data'][0]
                                                            ['codigo_servicio'];
                                                    global.ancho_banda_subida_detCortados =
                                                        value['data'][0][
                                                                'ancho_banda_subida'] ??
                                                            '0';
                                                    global.ancho_banda_bajada_detCortados =
                                                        value['data'][0][
                                                                'ancho_banda_bajada'] ??
                                                            '0';
                                                    global.comparticion_detCortados =
                                                        value['data'][0]
                                                            ['comparticion'];
                                                    global.estado_servicio_detCortados =
                                                        value['data'][0]
                                                            ['estado_servicio'];
                                                    global.latitud_detCortados =
                                                        value['data'][0]
                                                            ['latitud'];
                                                    global.longitud_detCortados =
                                                        value['data'][0]
                                                            ['longitud'];
                                                    global.contactar_detCortados =
                                                        value['data'][0]
                                                            ['contactar'];
                                                    global.direccion_detCortados =
                                                        value['data'][0]
                                                            ['direccion'];
                                                    global.codigo_cliente_detCortados =
                                                        value['data'][0]
                                                            ['codigo_cliente'];
                                                    global.ip_servicio_detCortados =
                                                        value['data'][0]
                                                            ['ip_servicio'];
                                                    global.saldo_servicio_detCortados =
                                                        value['data'][0][
                                                                'saldo_servicio'] +
                                                            0.00;
                                                    global.fecha_factura_detCortados =
                                                        value['data'][0]
                                                            ['fecha_factura'];
                                                    global.fecha_corte_detCortados =
                                                        value['data'][0]
                                                            ['fecha_corte'];
                                                    global.meses_activos_detCortados =
                                                        value['data'][0]
                                                            ['meses_activos'];
                                                    global.referencias_personales_detCortados =
                                                        value['data'][0][
                                                            'referencias_personales'];
                                                    global.foto_servicio_detCortados =
                                                        value['data'][0]
                                                            ['foto_servicio'];
                                                  });
                                                  progressDialog.dismiss();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              SelectCortadosImpago()));
                                                } else if (value['success'] ==
                                                    'ERROR') {
                                                  mostrarError(context,
                                                      value['mensaje']);
                                                }
                                              });
                                            });

                                            print('Valencia Quitnero');
                                          },
                                          child: Container(
                                            width: 200,
                                            child: Center(
                                                child: Text(
                                              _foundSuspencion[index]
                                                  .nombre_comercial,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: _colorColum2),
                                              textAlign: TextAlign.center,
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: varWidth,
                                      height: varHeight * 0.08,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorFondo.BTNUBI,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            _foundSuspencion[index]
                                                        .nombre_comercial ==
                                                    ''
                                                ? MainAxisAlignment.center
                                                : MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              ProgressDialog progressDialog =
                                                  ProgressDialog(context);
                                              progressDialog.show();
                                              setState(() {
                                                global.id_pk =
                                                    _foundSuspencion[index]
                                                        .id_servicio;
                                              });
                                              DetalleSuspenciones(global.id_pk)
                                                  .then((_) {
                                                detallesuspenciones
                                                    .then((value) {
                                                  print('Prueba API Pedidos');
                                                  print('aqii2');
                                                  print(value['success']);
                                                  if (value['success'] ==
                                                      'OK') {
                                                    print(value);
                                                    setState(() {
                                                      global.identidad_detCortados =
                                                          value['data'][0]
                                                              ['identidad'];
                                                      global.itemDetSoporte =
                                                          value['data'][0]
                                                              ['item'];
                                                      global.cliente_detCortados =
                                                          value['data'][0]
                                                              ['cliente'];
                                                      global.codigo_servicio_detCortados =
                                                          value['data'][0][
                                                              'codigo_servicio'];
                                                      global.ancho_banda_subida_detCortados =
                                                          value['data'][0][
                                                                  'ancho_banda_subida'] ??
                                                              '0';
                                                      global.ancho_banda_bajada_detCortados =
                                                          value['data'][0][
                                                                  'ancho_banda_bajada'] ??
                                                              '0';
                                                      global.comparticion_detCortados =
                                                          value['data'][0]
                                                              ['comparticion'];
                                                      global.estado_servicio_detCortados =
                                                          value['data'][0][
                                                              'estado_servicio'];
                                                      global.latitud_detCortados =
                                                          value['data'][0]
                                                              ['latitud'];
                                                      global.longitud_detCortados =
                                                          value['data'][0]
                                                              ['longitud'];
                                                      global.contactar_detCortados =
                                                          value['data'][0]
                                                              ['contactar'];
                                                      global.direccion_detCortados =
                                                          value['data'][0]
                                                              ['direccion'];
                                                      global.codigo_cliente_detCortados =
                                                          value['data'][0][
                                                              'codigo_cliente'];
                                                      global.ip_servicio_detCortados =
                                                          value['data'][0]
                                                              ['ip_servicio'];
                                                      global.saldo_servicio_detCortados =
                                                          value['data'][0][
                                                                  'saldo_servicio'] +
                                                              0.00;
                                                      global.fecha_factura_detCortados =
                                                          value['data'][0]
                                                              ['fecha_factura'];
                                                      global.fecha_corte_detCortados =
                                                          value['data'][0]
                                                              ['fecha_corte'];
                                                      global.meses_activos_detCortados =
                                                          value['data'][0]
                                                              ['meses_activos'];
                                                      global.referencias_personales_detCortados =
                                                          value['data'][0][
                                                              'referencias_personales'];
                                                      global.foto_servicio_detCortados =
                                                          value['data'][0]
                                                              ['foto_servicio'];
                                                      global.ip_radio_detCortados =
                                                          value['data'][0]
                                                              ['ip_radio'];
                                                    });
                                                    progressDialog.dismiss();
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SelectCortadosImpago()));
                                                  } else if (value['success'] ==
                                                      'ERROR') {
                                                    mostrarError(context,
                                                        value['mensaje']);
                                                  }
                                                });
                                              });
                                            },
                                            child: Container(
                                              width: varWidth / 3.5,
                                              height: varHeight,
                                              //color: Colors.amber,
                                              child: Center(
                                                  child: Text('Detalle',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17))),
                                            ),
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: Container(
                                              width: 2,
                                              height: varHeight,
                                              color: Color(0xFF808080),
                                            ),
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: GestureDetector(
                                              onTap: () async {
                                                ProgressDialog progressDialog =
                                                    ProgressDialog(context);
                                                progressDialog.show();
                                                List<String> coorLat = [''];
                                                List<String> coorLng = [''];
                                                var status = await Permission
                                                    .location.status;

                                                global.id_pk =
                                                    _foundSuspencion[index]
                                                        .id_servicio;
                                                global.id_cliente =
                                                    _foundSuspencion[index]
                                                        .id_cliente;

                                                print("codigo");
                                                print(global.id_pk);

                                                progressDialog.dismiss();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarSolucionRetiro()));

                                                if (status.isDenied) {
                                                  if (await Permission.location
                                                      .request()
                                                      .isGranted) {
                                                    List<String> coordenadas = [
                                                      ''
                                                    ];
                                                    if (status.isDenied) {
                                                      if (await Permission
                                                          .location
                                                          .request()
                                                          .isGranted) {
                                                        final postInicial =
                                                            await Geolocator
                                                                .getCurrentPosition();
                                                        final String posi =
                                                            postInicial
                                                                .toString();
                                                        var now =
                                                            DateTime.now();
                                                        var formatter =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        String formattedDate =
                                                            formatter
                                                                .format(now);

                                                        if (postInicial != '') {
                                                          setState(() {
                                                            //Preferences.DateRequest = formattedDate;

                                                            coordenadas =
                                                                posi.split(',');
                                                            if (coordenadas
                                                                    .first !=
                                                                '') {
                                                              coorLat =
                                                                  (coordenadas
                                                                          .first)
                                                                      .split(
                                                                          ': ');
                                                              coorLng =
                                                                  (coordenadas
                                                                          .last)
                                                                      .split(
                                                                          ': ');
                                                            }

                                                            print(
                                                                'Estoy por aquiii2 ${coorLat.last}');
                                                            print(
                                                                'Estoy por fueraAAA ${coorLng.last}');
                                                            //_postEnviarUbicacion.call();
                                                          });
                                                        } else {
                                                          if (await Permission
                                                              .speech
                                                              .isPermanentlyDenied) {
                                                            openAppSettings();
                                                          }
                                                          mostrarError(context,
                                                              'No hay acceso a la ubicación');
                                                        }
                                                      } else {
                                                        final postInicial =
                                                            await Geolocator
                                                                .getCurrentPosition();
                                                        final String posi =
                                                            postInicial
                                                                .toString();
                                                        var now =
                                                            DateTime.now();
                                                        var formatter =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        String formattedDate =
                                                            formatter
                                                                .format(now);
                                                        if (postInicial != '') {
                                                          setState(() {
                                                            //Preferences.DateRequest = formattedDate;

                                                            coordenadas =
                                                                posi.split(',');
                                                            if (coordenadas
                                                                    .first !=
                                                                '') {
                                                              coorLat =
                                                                  (coordenadas
                                                                          .first)
                                                                      .split(
                                                                          ': ');
                                                              coorLng =
                                                                  (coordenadas
                                                                          .last)
                                                                      .split(
                                                                          ': ');
                                                            }

                                                            print(
                                                                'Estoy por aquiii3 ${coorLat.last}');
                                                            print(
                                                                'Estoy por fueraAAA ${coorLng.last}');
                                                            //_postEnviarUbicacion.call();
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      print('aqui');
                                                      if (await Permission
                                                          .speech
                                                          .isPermanentlyDenied) {
                                                        print('aqui2');

                                                        openAppSettings();
                                                      } else {
                                                        openAppSettings();
                                                      }
                                                      mostrarError(context,
                                                          'Se requiere acceso a ubicación');
                                                    }
                                                  } else {
                                                    if (await Permission
                                                        .location
                                                        .request()
                                                        .isGranted) {
                                                      List<String> coordenadas =
                                                          [''];
                                                      if (status.isDenied) {
                                                        if (await Permission
                                                            .location
                                                            .request()
                                                            .isGranted) {
                                                          final postInicial =
                                                              await Geolocator
                                                                  .getCurrentPosition();
                                                          final String posi =
                                                              postInicial
                                                                  .toString();
                                                          var now =
                                                              DateTime.now();
                                                          var formatter =
                                                              DateFormat(
                                                                  'yyyy-MM-dd');
                                                          String formattedDate =
                                                              formatter
                                                                  .format(now);
                                                          if (postInicial !=
                                                              '') {
                                                            setState(() {
                                                              //Preferences.DateRequest = formattedDate;

                                                              coordenadas = posi
                                                                  .split(',');
                                                              if (coordenadas
                                                                      .first !=
                                                                  '') {
                                                                coorLat =
                                                                    (coordenadas
                                                                            .first)
                                                                        .split(
                                                                            ': ');
                                                                coorLng =
                                                                    (coordenadas
                                                                            .last)
                                                                        .split(
                                                                            ': ');
                                                              }

                                                              print(
                                                                  'Estoy por aquiii4 ${coorLat.last}');
                                                              print(
                                                                  'Estoy por fueraAAA ${coorLng.last}');
                                                              //_postEnviarUbicacion.call();
                                                            });
                                                          }
                                                        } else {
                                                          if (await Permission
                                                              .speech
                                                              .isPermanentlyDenied) {
                                                            openAppSettings();
                                                          }
                                                          mostrarError(context,
                                                              'No hay acceso a la ubicación');
                                                        }
                                                      } else {
                                                        final postInicial =
                                                            await Geolocator
                                                                .getCurrentPosition();
                                                        final String posi =
                                                            postInicial
                                                                .toString();
                                                        var now =
                                                            DateTime.now();
                                                        var formatter =
                                                            DateFormat(
                                                                'yyyy-MM-dd');
                                                        String formattedDate =
                                                            formatter
                                                                .format(now);
                                                        if (postInicial != '') {
                                                          setState(() {
                                                            //Preferences.DateRequest = formattedDate;

                                                            coordenadas =
                                                                posi.split(',');
                                                            if (coordenadas
                                                                    .first !=
                                                                '') {
                                                              coorLat =
                                                                  (coordenadas
                                                                          .first)
                                                                      .split(
                                                                          ': ');
                                                              coorLng =
                                                                  (coordenadas
                                                                          .last)
                                                                      .split(
                                                                          ': ');
                                                            }

                                                            print(
                                                                'Estoy por aquiii5 ${coorLat.last}');
                                                            print(
                                                                'Estoy por fueraAAA ${coorLng.last}');
                                                            //_postEnviarUbicacion.call();

                                                            global.clienteFactura =
                                                                _foundSuspencion[
                                                                        index]
                                                                    .nombre_comercial;
                                                            print('aqui');
                                                            print(global
                                                                .clienteFactura);
                                                          });
                                                        }
                                                      }
                                                    } else {
                                                      print('aqui');
                                                      if (await Permission
                                                          .speech
                                                          .isPermanentlyDenied) {
                                                        print('aqui2');

                                                        openAppSettings();
                                                      } else {
                                                        openAppSettings();
                                                      }
                                                      mostrarError(context,
                                                          'Se requiere acceso a ubicación');
                                                    }
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: varWidth / 3.5,
                                                height: varHeight,
                                                //0color: Colors.blueAccent,
                                                child: Center(
                                                    child: Text('Solucionar',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17))),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 2,
                                            height: varHeight,
                                            color: Color(0xFF808080),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                global.celular1_detCortados =
                                                    _foundSuspencion[index]
                                                        .celular_cliente_1
                                                        .toString();
                                                global.celular2_detCortados =
                                                    _foundSuspencion[index]
                                                        .celular_cliente_2
                                                        .toString();
                                                global.celular3_detCortados =
                                                    _foundSuspencion[index]
                                                        .celular_cliente_3
                                                        .toString();
                                                global.celular_corteimpago_detCortados =
                                                    _foundSuspencion[index]
                                                        .celular_corteimpago
                                                        .toString();

                                                print(global
                                                    .celular1_detCortados);

                                                print(global
                                                    .celular2_detCortados);
                                                print(global
                                                    .celular3_detCortados);
                                                print(global
                                                    .celular1_detCortados);
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      ContactosRetiros.route());
                                            },
                                            child: Container(
                                              width: varWidth / 3.5,
                                              height: varHeight,
                                              //color: Colors.redAccent,
                                              child: Center(
                                                  child: Text('Contactos',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17))),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

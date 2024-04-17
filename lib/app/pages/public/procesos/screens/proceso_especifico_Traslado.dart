import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powernet/app/api/internas/public/insert/transfer/api_iniciar_traslados.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_tecnico.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_traslados.dart';
import 'package:powernet/app/api/internas/public/select/process_detail/api_detalleUsuario_Traslado.dart';
import 'package:powernet/app/models/transfer/Datos_Traslado.dart';
import 'package:powernet/app/pages/public/registrarSolucionTraslados/screens/Solucion_Traslado.dart';
import 'package:powernet/app/pages/public/soporte/screens/asignar_tecnico.dart';

import '../../../../api/internas/public/select/api_listado_ont_libres.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../models/instalation/Datos_Instalaciones.dart';
import '../../../../models/products/listas_prod.dart';
import '../../../../models/products/series_prod.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../asignar_ont_onu/asignar_ont_onu.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '../widget/contactosTraslados.dart';
import '../widget/select_traslado.dart';
import '/app/models/var_global.dart' as global;

class ProcesoEspecificoTraslado extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ProcesoEspecificoTraslado(),
    );
  }

  @override
  _ProcesoEspecificoTrasladoState createState() =>
      _ProcesoEspecificoTrasladoState();
}

class _ProcesoEspecificoTrasladoState extends State<ProcesoEspecificoTraslado> {
  var suma = 0;
  int nowAnio = DateTime.now().year;
  int nowMon = DateTime.now().month;
  int nowDay = DateTime.now().day;
  List<Datos_Instalaciones> _foundInstalaciones = [];
  List<Datos_Traslados> _foundTraslado = [];
  Future<void> mostrarList() async {
    setState(() {
      global.tecnicoAcomp.add('Seleccionar');
    });
    for (var i = 0; i < global.listarTecnicos.length; i++) {
      global.tecnicoAcomp.add(global.listarTecnicos[i]['tecnicos']);
    }
  }

  final _formKey = GlobalKey<FormState>();

  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = ColorFondo.BTNUBI;

  @override
  void initState() {
    super.initState();
    global.ListadoInstalacion.clear();
    global.ListadoTraslados.clear();
    global.ListadoSoportes.clear();
    global.ListadoTraslados.clear();
    _foundTraslado.clear();

    listadoTraslados('').then((value) {
      if (mounted) {
        setState(() {
          global.ListadoTraslados.addAll(value);
          _foundTraslado = global.ListadoTraslados;
        });
      }
    });
  }

  void _filtroSoporte(String busqueda) {
    List<Datos_Traslados> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.ListadoTraslados;
      } else {
        results = global.ListadoTraslados.where((trs) {
          Intl.defaultLocale = 'es';
          return trs.nombre_comercial
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              trs.codigo_servicio
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              trs.tipo
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              trs.estado
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }
      setState(() {
        this._foundTraslado = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Traslados',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorFondo.PRIMARY,
      ),
      drawer: const MenuPrincipal(),
      body: SingleChildScrollView(
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
                              onChanged: (value) => _filtroSoporte(value),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white54)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(137, 0, 0, 0)),
                                labelText: 'Busqueda inteligente',
                                suffixIcon:
                                    Icon(Icons.search, color: Colors.white54),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white54)),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      /* Navigator.of(context)
                                        .pushReplacement(SelectInsidencias.route()); */
                    },
                    child: Container(
                      //color: Colors.blue,
                      width: 110,

                      child: Text(
                        'Incidente',
                        style: TextStyle(
                            fontSize: 15,
                            color: _colorColum2,
                            fontWeight: FontWeight.bold),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* Navigator.of(context)
                                        .pushReplacement(SelectInsidencias.route()); */
                    },
                    child: Container(
                      //color: Colors.red,
                      width: 110,
                      child: Text(
                        'Apellidos y Nombres',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: _colorColum1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /*  Navigator.of(context)
                                        .pushReplacement(AsignarTecnicos.route()); */
                    },
                    child: Container(
                      //color: Colors.green,
                      width: 110,
                      child: Text('Asignado',
                          style: TextStyle(
                              color: _colorColum2,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          textAlign: TextAlign
                              .center) /* Text('Solucionar',style: TextStyle(
                              color: _colorColum2,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)) */
                      ,
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
                    itemCount: _foundTraslado.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _foundTraslado[index].estado == 'PENDIENTE'
                                ? Color.fromARGB(255, 247, 147, 30)
                                : _foundTraslado[index].estado == 'ASIGNADO'
                                    ? Color.fromARGB(255, 98, 171, 78)
                                    : _foundTraslado[index].estado == 'INICIADO'
                                        ? Color.fromARGB(255, 8, 112, 162)
                                        : _foundTraslado[index].estado ==
                                                'FINALIZADO'
                                            ? Colors.green
                                            : Colors.red),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    width: 110,
                                    child: Text(
                                      _foundTraslado[index].tipo,
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum1),
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
                                          _foundTraslado[index].codigo;
                                    });
                                    DetalleTraslado(global.id_pk).then((_) {
                                      detalletraslado.then((value) {
                                        print('Prueba API Pedidos');
                                        if (value['success'] == 'OK') {
                                          print(value);
                                          setState(() {
                                            global.item_DetTraslados =
                                                value['data'][0]['item'];
                                            global.codigo_DetTraslados =
                                                value['data'][0]['codigo'];
                                            global.identificacion_DetTraslados =
                                                value['data'][0]['identidad'];
                                            global.cliente_DetTraslados =
                                                value['data'][0]['cliente'];
                                            global.codigo_servicio_DetTraslados =
                                                value['data'][0]
                                                    ['codigo_servicio'];
                                            global.fechaMigracion_DetTraslados =
                                                value['data'][0]
                                                    ['fecha_migracion'];
                                            global.registrado_DetTraslados =
                                                value['data'][0]['registrado'];
                                            global.ancho_banda_subida_DetTraslados =
                                                value['data'][0][
                                                        'ancho_banda_subida'] ??
                                                    '0';
                                            global.ancho_banda_bajada_DetTraslados =
                                                value['data'][0][
                                                        'ancho_banda_bajada'] ??
                                                    '0';
                                            global.comparticion_DetTraslados =
                                                value['data'][0]
                                                    ['comparticion'];
                                            global.estado_servicio_DetTraslados =
                                                value['data'][0]
                                                    ['estado_servicio'];
                                            global.latitud_actual_DetTraslados =
                                                value['data'][0]['latitud'];
                                            global.longitud_actual_DetTraslados =
                                                value['data'][0]['longitud'];
                                            /* global.latitud_nueva_DetTraslados =
                                                  value['data'][0]['latitud_nueva'];
                                              global.longitud_nueva_DetTraslados =
                                                  value['data'][0]['longitud_nueva']; */
                                            global.estado_soporte_DetTraslados =
                                                value['data'][0]
                                                    ['estado_soporte'];
                                            global.id_tecnico_DetTraslados =
                                                value['data'][0]['id_tecnico'];
                                            global.usuario_asignado_DetTraslados =
                                                value['data'][0]
                                                    ['usuario_asignado'];
                                            global.fecha_asignacion_DetTraslados =
                                                value['data'][0][
                                                            'fecha_asignacion'] ==
                                                        null
                                                    ? ''
                                                    : value['data'][0]
                                                        ['fecha_asignacion'];
                                            /* global.direccion_DetTraslados =
                                                  value['data'][0]['direccion']; */
                                            global.id_cliente_DetTraslados =
                                                value['data'][0]['id_cliente'];
                                            global.direccion_DetTraslados =
                                                value['data'][0]['direccion'];
                                            global.ip_traslado =
                                                value['data'][0]['ip_servicio'];
                                            global.red_ip_traslado =
                                                value['data'][0]['red_ip'];
                                            global.mascara_ip_traslado =
                                                value['data'][0]['mascara_ip'];
                                            global.observacion_traslado =
                                                value['data'][0]['observacion'];
                                            global.foto_servicio_DetTraslados =
                                                value['data'][0]
                                                    ['foto_servicio'];
                                            global.vlan_traslado =
                                                value['data'][0]['vlan'];
                                            global.gateway_traslado =
                                                value['data'][0]['gateway'];
                                          });
                                          progressDialog.dismiss();

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectTraslado()));
                                        } else if (value['success'] ==
                                            'ERROR') {
                                          mostrarError(
                                              context, value['mensaje']);
                                        }
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 110,
                                    child: Center(
                                        child: Text(
                                      _foundTraslado[index].nombre_comercial,
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum2),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    global.id_pk = _foundTraslado[index].codigo;

                                    listadoTecnico('hola').then((_) {
                                      lisTecnico.then((value) {
                                        print('Prueba API Pedidos');
                                        if (value['success'] == 'OK') {
                                          print(value);

                                          global.listarTecnicos = value['data'];
                                          // mostrarList();
                                          print(global.listarTecnicos);
                                          /*  Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AsignarTecnicos())); */
                                          Navigator.of(context)
                                              .push(AsignarTecnicos.route());
                                        } else if (value['success'] ==
                                            'ERROR') {
                                          mostrarError(
                                              context, value['mensaje']);
                                        }
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 110,
                                    child: Text(
                                        _foundTraslado[index]
                                                    .usuario_asignado ==
                                                ''
                                            ? 'Seleccionar'
                                            : _foundTraslado[index]
                                                .usuario_asignado,
                                        style: TextStyle(
                                            color: _colorColum1,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        textAlign: TextAlign.center),
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
                                mainAxisAlignment: global
                                            .ListadoTraslados[index]
                                            .usuario_asignado ==
                                        ''
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        global.listarONTLIBRES.clear();
                                        global.id_pk =
                                            (_foundTraslado[index].id_servicio)
                                                .toString();
                                      });
                                      if (_foundTraslado[index].tipo ==
                                              'ANTENA A FIBRA OPTICA' ||
                                          _foundTraslado[index].tipo ==
                                              'FIBRA OPTICA A FIBRA OPTICA') {
                                        ProgressDialog progressDialog =
                                            ProgressDialog(context);
                                        progressDialog.show();

                                        listadoONTlibre(global.id_pk, '2')
                                            .then((_) {
                                          lisONT.then((value) {
                                            print(value);
                                            if (value['success'] == 'OK') {
                                              setState(() {
                                                global.listarONTLIBRES =
                                                    value['data'];
                                              });
                                              progressDialog.dismiss();
                                              print(global.listarONTLIBRES);
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      AsignarONT.route(
                                                          "TRANSFER"));
                                            } else {
                                              progressDialog.dismiss();
                                              mostrarErrorMSG(
                                                  context, value['mensaje']);
                                            }
                                          });
                                        });
                                        /* DetalleInstalacion(global.id_pk)
                                          .then((_) {
                                        detalleinstalacion.then((value) {
                                          print('Prueba API Pedidos');
                                          if (value['success'] == 'OK') {
                                            print(value);
                                            setState(() {
                                              global.identificacionInstalacion =
                                                  value['data'][0]['identidad'];
                                              global.itemDetInstalacion =
                                                  value['data'][0]['item'];
                                              global.codigoDetSoporte =
                                                  value['data'][0]['codigo'];
                                              global.clienteDetInstalacion =
                                                  value['data'][0]['cliente'];
                                              global.codigo_servicioDetInstalacion =
                                                  value['data'][0]
                                                      ['codigo_servicio'];
                                              global.fecha_instalarDetInstalacion =
                                                  value['data'][0]
                                                      ['fecha_instalar'];
                                              global.registradoDetInstalacion =
                                                  value['data'][0]
                                                      ['registrado'];
                                              global.ancho_banda_subidaDetInstalacion =
                                                  value['data'][0][
                                                              'ancho_banda_subida'] ==
                                                          null
                                                      ? '0'
                                                      : value['data'][0][
                                                          'ancho_banda_subida'];
                                              global.ancho_banda_bajadaDetInstalacion =
                                                  value['data'][0][
                                                              'ancho_banda_bajada'] ==
                                                          null
                                                      ? '0'
                                                      : value['data'][0][
                                                          'ancho_banda_bajada'];
                                              global.comparticionDetInstalacion =
                                                  value['data'][0]
                                                      ['comparticion'];
                                              global.estado_servicioDetInstalacion =
                                                  value['data'][0]
                                                      ['estado_servicio'];
                                              global.latitudDetInstalacion =
                                                  value['data'][0]['latitud'];
                                              global.longitudDetInstalacion =
                                                  value['data'][0]['longitud'];
                                              global.estado_instalacionDetInstalacion =
                                                  value['data'][0]
                                                      ['estado_instalacion'];
                                              global.usuario_asignadoDetInstalacion =
                                                  value['data'][0]
                                                      ['usuario_asignado'];
                                              global.usuario_asignadoDetInstalacion =
                                                  value['data'][0]
                                                      ['usuario_asignado'];
                                              global.fecha_asignacionDetInstalacion =
                                                  value['data'][0][
                                                              'fecha_asignacion'] ==
                                                          null
                                                      ? ''
                                                      : value['data'][0]
                                                          ['fecha_asignacion'];
                                              global.direccionDetInstalacion =
                                                  value['data'][0]['direccion'];
                                              global.ip_instalacion =
                                                  value['data'][0]
                                                      ['ip_servicio'];
                                              global.red_ip_instalacion =
                                                  value['data'][0]['red_ip'];
                                              global.mascara_ip_instalacion =
                                                  value['data'][0]
                                                      ['mascara_ip'];
                                              global.vlan_instalacion =
                                                  value['data'][0]['vlan'];
                                            });
                                            progressDialog.dismiss();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectInstalacion()));
                                          } else if (value['success'] ==
                                              'ERROR') {
                                            mostrarError(
                                                context, value['mensaje']);
                                          }
                                        });
                                      });
                                     */
                                      } else {
                                        AwesomeDialog(
                                                dismissOnTouchOutside: false,
                                                context: context,
                                                dialogType: DialogType.info,
                                                animType: AnimType.topSlide,
                                                headerAnimationLoop: true,
                                                //title: 'ADVERTENCIA',
                                                dialogBackgroundColor:
                                                    Colors.white,
                                                desc:
                                                    'Solo se puede asignar ONT cuando el tipo de conexión es de fibra óptica.',
                                                btnOkOnPress: () {},
                                                //btnOkIcon: Icons.cancel,
                                                btnOkText: 'Aceptar',
                                                btnOkColor: ColorFondo.BTNUBI
                                                //  btnOkColor: Colors.red,
                                                )
                                            .show();
                                      }
                                      /* setState(() {
                                        global.id_pk =
                                            _foundTraslado[index].codigo;
                                      });
                                      DetalleTraslado(global.id_pk).then((_) {
                                        detalletraslado.then((value) {
                                          print('Prueba API Pedidos');
                                          if (value['success'] == 'OK') {
                                            print(value);
                                            setState(() {
                                              global.item_DetTraslados =
                                                  value['data'][0]['item'];
                                              global.codigo_DetTraslados =
                                                  value['data'][0]['codigo'];
                                              global.identificacion_DetTraslados =
                                                  value['data'][0]['identidad'];
                                              global.cliente_DetTraslados =
                                                  value['data'][0]['cliente'];
                                              global.codigo_servicio_DetTraslados =
                                                  value['data'][0]
                                                      ['codigo_servicio'];
                                              global.fechaMigracion_DetTraslados =
                                                  value['data'][0]
                                                      ['fecha_migracion'];
                                              global.registrado_DetTraslados =
                                                  value['data'][0]
                                                      ['registrado'];
                                              global.ancho_banda_subida_DetTraslados =
                                                  value['data'][0][
                                                          'ancho_banda_subida'] ??
                                                      '0';
                                              global.ancho_banda_bajada_DetTraslados =
                                                  value['data'][0][
                                                          'ancho_banda_bajada'] ??
                                                      '0';
                                              global.comparticion_DetTraslados =
                                                  value['data'][0]
                                                      ['comparticion'];
                                              global.estado_servicio_DetTraslados =
                                                  value['data'][0]
                                                      ['estado_servicio'];
                                              global.latitud_actual_DetTraslados =
                                                  value['data'][0]['latitud'];
                                              global.longitud_actual_DetTraslados =
                                                  value['data'][0]['longitud'];
                                              /* global.latitud_nueva_DetTraslados =
                                                  value['data'][0]['latitud_nueva'];
                                              global.longitud_nueva_DetTraslados =
                                                  value['data'][0]['longitud_nueva']; */
                                              global.estado_soporte_DetTraslados =
                                                  value['data'][0]
                                                      ['estado_soporte'];
                                              global.id_tecnico_DetTraslados =
                                                  value['data'][0]
                                                      ['id_tecnico'];
                                              global.usuario_asignado_DetTraslados =
                                                  value['data'][0]
                                                      ['usuario_asignado'];
                                              global.fecha_asignacion_DetTraslados =
                                                  value['data'][0][
                                                              'fecha_asignacion'] ==
                                                          null
                                                      ? ''
                                                      : value['data'][0]
                                                          ['fecha_asignacion'];
                                              /* global.direccion_DetTraslados =
                                                  value['data'][0]['direccion']; */
                                              global.id_cliente_DetTraslados =
                                                  value['data'][0]
                                                      ['id_cliente'];
                                              global.direccion_DetTraslados =
                                                  value['data'][0]['direccion'];
                                              global.ip_traslado = value['data']
                                                  [0]['ip_servicio'];
                                              global.foto_servicio_DetTraslados =
                                                  value['data'][0]
                                                      ['foto_servicio'];
                                              global.vlan_traslado =
                                                  value['data'][0]['vlan'];
                                            });
                                            progressDialog.dismiss();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectTraslado()));
                                          } else if (value['success'] ==
                                              'ERROR') {
                                            mostrarError(
                                                context, value['mensaje']);
                                          }
                                        });
                                      });
                                     */
                                    },
                                    child: Container(
                                      width: varWidth / 3.5,
                                      height: varHeight,
                                      //color: Colors.amber,
                                      child: Center(
                                          child: Text('Agregar ONT',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _foundTraslado[index]
                                                .usuario_asignado ==
                                            ''
                                        ? false
                                        : true,
                                    child: Container(
                                      width: 2,
                                      height: varHeight,
                                      color: Color(0xFF808080),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _foundTraslado[index]
                                                .usuario_asignado ==
                                            ''
                                        ? false
                                        : true,
                                    child: GestureDetector(
                                      onTap: () async {
                                        ProgressDialog progressDialog =
                                            ProgressDialog(context);
                                        progressDialog.show();
                                        List<String> coorLat = [''];
                                        List<String> coorLng = [''];
                                        var status =
                                            await Permission.location.status;

                                        if (_foundTraslado[index].estado ==
                                            'ASIGNADO') {
                                          if (status.isDenied) {
                                            if (await Permission.location
                                                .request()
                                                .isGranted) {
                                              List<String> coordenadas = [''];
                                              if (status.isDenied) {
                                                if (await Permission.location
                                                    .request()
                                                    .isGranted) {
                                                  final postInicial =
                                                      await Geolocator
                                                          .getCurrentPosition();
                                                  final String posi =
                                                      postInicial.toString();
                                                  var now = DateTime.now();
                                                  var formatter =
                                                      DateFormat('yyyy-MM-dd');
                                                  String formattedDate =
                                                      formatter.format(now);
                                                  if (postInicial != '') {
                                                    setState(() {
                                                      //Preferences.DateRequest = formattedDate;

                                                      coordenadas =
                                                          posi.split(',');
                                                      if (coordenadas.first !=
                                                          '') {
                                                        coorLat =
                                                            (coordenadas.first)
                                                                .split(': ');
                                                        coorLng =
                                                            (coordenadas.last)
                                                                .split(': ');
                                                      }

                                                      print(
                                                          'Estoy por aquiii6 ${coorLat.last}');
                                                      print(
                                                          'Estoy por fueraAAA ${coorLng.last}');
                                                      //_postEnviarUbicacion.call();
                                                    });
                                                    if (global
                                                            .tipoRequerimiento ==
                                                        'Instalaciones') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundInstalaciones[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      setState(() {});
                                                    } else {
                                                      if (_foundTraslado[index]
                                                              .estado ==
                                                          'ASIGNADO') {
                                                        setState(() {
                                                          global.id_pk =
                                                              (_foundTraslado[
                                                                          index]
                                                                      .codigo)
                                                                  .toString();
                                                        });
                                                        IniciarTraslados(
                                                                _foundTraslado[
                                                                        index]
                                                                    .codigo,
                                                                _foundTraslado[
                                                                        index]
                                                                    .id_tecnico,
                                                                double.parse(
                                                                    coorLat
                                                                        .last),
                                                                double.parse(
                                                                    coorLng
                                                                        .last))
                                                            .then((_) {
                                                          iniciartraslado
                                                              .then((value) {
                                                            print(
                                                                'Prueba API Pedidos');
                                                            if (value[
                                                                    'success'] ==
                                                                'OK') {
                                                              print(value);
                                                              mostrarCorrecto(
                                                                  context,
                                                                  value[
                                                                      'mensaje']);
                                                              progressDialog
                                                                  .dismiss();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      ProcesoEspecificoTraslado
                                                                          .route());
                                                            } else if (value[
                                                                    'success'] ==
                                                                'ERROR') {
                                                              mostrarError(
                                                                  context,
                                                                  value[
                                                                      'mensaje']);
                                                            }
                                                          });
                                                        });
                                                      }
                                                    }
                                                  }
                                                } else {
                                                  if (await Permission.speech
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
                                                    postInicial.toString();
                                                var now = DateTime.now();
                                                var formatter =
                                                    DateFormat('yyyy-MM-dd');
                                                String formattedDate =
                                                    formatter.format(now);
                                                if (postInicial != '') {
                                                  setState(() {
                                                    //Preferences.DateRequest = formattedDate;

                                                    coordenadas =
                                                        posi.split(',');
                                                    if (coordenadas.first !=
                                                        '') {
                                                      coorLat =
                                                          (coordenadas.first)
                                                              .split(': ');
                                                      coorLng =
                                                          (coordenadas.last)
                                                              .split(': ');
                                                    }

                                                    print(
                                                        'Estoy por aquiii7 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (global
                                                          .tipoRequerimiento ==
                                                      'Instalaciones') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundInstalaciones[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    setState(() {});
                                                  } else {
                                                    if (_foundTraslado[index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundTraslado[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarTraslados(
                                                              _foundTraslado[
                                                                      index]
                                                                  .codigo,
                                                              _foundTraslado[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciartraslado
                                                            .then((value) {
                                                          print(
                                                              'Prueba API Pedidos');
                                                          if (value[
                                                                  'success'] ==
                                                              'OK') {
                                                            print(value);
                                                            mostrarCorrecto(
                                                                context,
                                                                value[
                                                                    'mensaje']);
                                                            progressDialog
                                                                .dismiss();
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                                    ProcesoEspecificoTraslado
                                                                        .route());
                                                          } else if (value[
                                                                  'success'] ==
                                                              'ERROR') {
                                                            mostrarError(
                                                                context,
                                                                value[
                                                                    'mensaje']);
                                                          }
                                                        });
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                            } else {
                                              print('aqui');
                                              if (await Permission
                                                  .speech.isPermanentlyDenied) {
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
                                              List<String> coordenadas = [''];
                                              if (status.isDenied) {
                                                if (await Permission.location
                                                    .request()
                                                    .isGranted) {
                                                  final postInicial =
                                                      await Geolocator
                                                          .getCurrentPosition();
                                                  final String posi =
                                                      postInicial.toString();
                                                  var now = DateTime.now();
                                                  var formatter =
                                                      DateFormat('yyyy-MM-dd');
                                                  String formattedDate =
                                                      formatter.format(now);
                                                  if (postInicial != '') {
                                                    setState(() {
                                                      //Preferences.DateRequest = formattedDate;

                                                      coordenadas =
                                                          posi.split(',');
                                                      if (coordenadas.first !=
                                                          '') {
                                                        coorLat =
                                                            (coordenadas.first)
                                                                .split(': ');
                                                        coorLng =
                                                            (coordenadas.last)
                                                                .split(': ');
                                                      }

                                                      print(
                                                          'Estoy por aquiii8 ${coorLat.last}');
                                                      print(
                                                          'Estoy por fueraAAA ${coorLng.last}');
                                                      //_postEnviarUbicacion.call();
                                                    });
                                                    if (global
                                                            .tipoRequerimiento ==
                                                        'Instalaciones') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundInstalaciones[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      setState(() {});
                                                    } else {
                                                      if (_foundTraslado[index]
                                                              .estado ==
                                                          'ASIGNADO') {
                                                        setState(() {
                                                          global.id_pk =
                                                              (_foundTraslado[
                                                                          index]
                                                                      .codigo)
                                                                  .toString();
                                                        });
                                                        IniciarTraslados(
                                                                _foundTraslado[
                                                                        index]
                                                                    .codigo,
                                                                _foundTraslado[
                                                                        index]
                                                                    .id_tecnico,
                                                                double.parse(
                                                                    coorLat
                                                                        .last),
                                                                double.parse(
                                                                    coorLng
                                                                        .last))
                                                            .then((_) {
                                                          iniciartraslado
                                                              .then((value) {
                                                            print(
                                                                'Prueba API Pedidos');
                                                            if (value[
                                                                    'success'] ==
                                                                'OK') {
                                                              print(value);
                                                              mostrarCorrecto(
                                                                  context,
                                                                  value[
                                                                      'mensaje']);
                                                              progressDialog
                                                                  .dismiss();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushReplacement(
                                                                      ProcesoEspecificoTraslado
                                                                          .route());
                                                            } else if (value[
                                                                    'success'] ==
                                                                'ERROR') {
                                                              mostrarError(
                                                                  context,
                                                                  value[
                                                                      'mensaje']);
                                                            }
                                                          });
                                                        });
                                                      }
                                                    }
                                                  }
                                                } else {
                                                  if (await Permission.speech
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
                                                    postInicial.toString();
                                                var now = DateTime.now();
                                                var formatter =
                                                    DateFormat('yyyy-MM-dd');
                                                String formattedDate =
                                                    formatter.format(now);
                                                if (postInicial != '') {
                                                  setState(() {
                                                    //Preferences.DateRequest = formattedDate;

                                                    coordenadas =
                                                        posi.split(',');
                                                    if (coordenadas.first !=
                                                        '') {
                                                      coorLat =
                                                          (coordenadas.first)
                                                              .split(': ');
                                                      coorLng =
                                                          (coordenadas.last)
                                                              .split(': ');
                                                    }

                                                    print(
                                                        'Estoy por aquiii1 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (global
                                                          .tipoRequerimiento ==
                                                      'Instalaciones') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundInstalaciones[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    setState(() {});
                                                  } else {
                                                    if (_foundTraslado[index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundTraslado[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarTraslados(
                                                              _foundTraslado[
                                                                      index]
                                                                  .codigo,
                                                              _foundTraslado[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciartraslado
                                                            .then((value) {
                                                          print(
                                                              'Prueba API Pedidos');
                                                          if (value[
                                                                  'success'] ==
                                                              'OK') {
                                                            print(value);
                                                            mostrarCorrecto(
                                                                context,
                                                                value[
                                                                    'mensaje']);
                                                            progressDialog
                                                                .dismiss();
                                                            Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                                    ProcesoEspecificoTraslado
                                                                        .route());
                                                          } else if (value[
                                                                  'success'] ==
                                                              'ERROR') {
                                                            mostrarError(
                                                                context,
                                                                value[
                                                                    'mensaje']);
                                                          }
                                                        });
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                            } else {
                                              print('aqui');
                                              if (await Permission
                                                  .speech.isPermanentlyDenied) {
                                                print('aqui2');

                                                openAppSettings();
                                              } else {
                                                openAppSettings();
                                              }
                                              mostrarError(context,
                                                  'Se requiere acceso a ubicación');
                                            }
                                          }
                                        } else if (_foundTraslado[index]
                                                .estado ==
                                            'INICIADO') {
                                          setState(() {
                                            global.tecnicoAcomp.clear();
                                            global.listarTecnicos.clear();
                                            global.selectAcomp = 'Seleccionar';
                                            global.items.clear();
                                            global.arrayPrestacionInst.clear();
                                            global.serieProducts.clear();
                                            global.serieProducts.clear();
                                            global.nTickets.clear();
                                            global.nDescuento.clear();
                                            global.nfacturaSiNo.clear();
                                            global.detalleSoluTraslados = '';
                                            global.itemsAdcionales.clear();
                                            global.procedeTraslado = 'SI';
                                            global.isRealizaTraslado = true;
                                            global.serieProductsAdicional
                                                .clear();
                                            global.serieProductsAdicional
                                                .clear();
                                            global.nTicketsAdicionales.clear();
                                            global.nDescuentoAdicional.clear();
                                            global.nfacturaSiNoAdicional
                                                .clear();
                                            global.detalleSoluTraslados = '';
                                            print('por aca');
                                            global.codigo_servicio_DetTraslados =
                                                _foundTraslado[index]
                                                    .id_servicio;
                                            global.id_pk =
                                                _foundTraslado[index].codigo;
                                            global.id_tecnico_DetTraslados =
                                                _foundTraslado[index]
                                                    .id_tecnico;
                                            global.id_cliente_DetTraslados =
                                                _foundTraslado[index]
                                                    .id_cliente;
                                            global.codigo_prestacionTraslados =
                                                _foundTraslado[index]
                                                    .codigo_prestacion;
                                            global.nombre_prestacionTraslados =
                                                _foundTraslado[index]
                                                    .nombre_prestacion;
                                            global.precio_prestacionTraslados =
                                                _foundTraslado[index]
                                                    .precio_prestacion;
                                            global.cliente_DetTraslados =
                                                _foundTraslado[index]
                                                    .nombre_comercial;
                                            global.codigo_servicio_DetTraslado_mostrar =
                                                _foundTraslado[index]
                                                    .codigo_servicio;
                                          });
                                          if (global.codigo_prestacionTraslados !=
                                                  '0' &&
                                              double.parse(global
                                                      .precio_prestacionTraslados) >
                                                  0) {
                                            global.items.add(lista_producto(
                                              serie: 'NO',
                                              series: 'SN',
                                              items: 9999999,
                                              codigo: global
                                                  .codigo_prestacionTraslados,
                                              codigoProducto: global
                                                  .codigo_prestacionTraslados,
                                              nombre: global
                                                  .nombre_prestacionTraslados,
                                              stock: '1',
                                              precio: global
                                                  .precio_prestacionTraslados,
                                              categoria: 'SN',
                                              descripcion: 'SN',
                                              foto: 'SN',
                                              tipo: 'SERVICIO',
                                              total: double.parse('0'),
                                            ));
                                            global.serieProducts.add(
                                                lista_seriesProd(
                                                    items: 'SN',
                                                    codigo: 'SN',
                                                    serie1: 'SN',
                                                    serie2: 'SN',
                                                    serie3: 'SN',
                                                    estado: 'SN',
                                                    observacion: 'SN',
                                                    garantia_vigente: 'NO'));
                                            global.nTickets.add(1);
                                            global.nfacturaSiNo.add('SI');
                                            global.nDescuento.add(0);
                                          }

                                          listadoTecnico('hola').then((_) {
                                            lisTecnico.then((value) async {
                                              print('Prueba API Pedidos');
                                              if (value['success'] == 'OK') {
                                                print(value);
                                                setState(() {
                                                  global.listarTecnicos =
                                                      value['data'];
                                                });
                                                await mostrarList();
                                                progressDialog.dismiss();
                                                print(global
                                                    .id_cliente_DetTraslados);
                                                setState(() {
                                                  global.deleteImg = true;
                                                  global.persona_presente = '';
                                                  global.nCuotasAdicionales =
                                                      '1';
                                                  global.checkBoxValue = false;
                                                  global.ischecked = true;
                                                  global.btnRecibeProd = false;
                                                  global.detalleEquiposRetirados =
                                                      '';
                                                  global.visiblecuotasadi =
                                                      false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarTraslados()));
                                              } else if (value['success'] ==
                                                  'ERROR') {
                                                mostrarError(
                                                    context, value['mensaje']);
                                                progressDialog.dismiss();
                                                print(global
                                                    .id_cliente_DetTraslados);
                                                setState(() {
                                                  global.deleteImg = true;
                                                  global.persona_presente = '';
                                                  global.nCuotasAdicionales =
                                                      '1';
                                                  global.checkBoxValue = false;
                                                  global.ischecked = true;
                                                  global.btnRecibeProd = false;
                                                  global.detalleEquiposRetirados =
                                                      '';
                                                  global.visiblecuotasadi =
                                                      false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarTraslados()));
                                              }
                                            });
                                          });
                                        }

                                        if (status.isDenied) {
                                          if (await Permission.location
                                              .request()
                                              .isGranted) {
                                            List<String> coordenadas = [''];
                                            if (status.isDenied) {
                                              if (await Permission.location
                                                  .request()
                                                  .isGranted) {
                                                final postInicial =
                                                    await Geolocator
                                                        .getCurrentPosition();
                                                final String posi =
                                                    postInicial.toString();
                                                var now = DateTime.now();
                                                var formatter =
                                                    DateFormat('yyyy-MM-dd');
                                                String formattedDate =
                                                    formatter.format(now);
                                                if (postInicial != '') {
                                                  setState(() {
                                                    //Preferences.DateRequest = formattedDate;

                                                    coordenadas =
                                                        posi.split(',');
                                                    if (coordenadas.first !=
                                                        '') {
                                                      coorLat =
                                                          (coordenadas.first)
                                                              .split(': ');
                                                      coorLng =
                                                          (coordenadas.last)
                                                              .split(': ');
                                                    }

                                                    print(
                                                        'Estoy por aquiii2 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });

                                                  if (_foundTraslado[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundTraslado[index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarTraslados(
                                                            _foundTraslado[
                                                                    index]
                                                                .codigo,
                                                            _foundTraslado[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciartraslado
                                                          .then((value) {
                                                        print(
                                                            'Prueba API Pedidos');
                                                        if (value['success'] ==
                                                            'OK') {
                                                          print(value);
                                                          mostrarCorrecto(
                                                              context,
                                                              value['mensaje']);
                                                          progressDialog
                                                              .dismiss();
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  ProcesoEspecificoTraslado
                                                                      .route());
                                                        } else if (value[
                                                                'success'] ==
                                                            'ERROR') {
                                                          mostrarError(context,
                                                              value['mensaje']);
                                                        }
                                                      });
                                                    });
                                                  }
                                                }
                                              } else {
                                                if (await Permission.speech
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
                                                  postInicial.toString();
                                              var now = DateTime.now();
                                              var formatter =
                                                  DateFormat('yyyy-MM-dd');
                                              String formattedDate =
                                                  formatter.format(now);
                                              if (postInicial != '') {
                                                setState(() {
                                                  //Preferences.DateRequest = formattedDate;

                                                  coordenadas = posi.split(',');
                                                  if (coordenadas.first != '') {
                                                    coorLat =
                                                        (coordenadas.first)
                                                            .split(': ');
                                                    coorLng = (coordenadas.last)
                                                        .split(': ');
                                                  }

                                                  print(
                                                      'Estoy por aquiii3 ${coorLat.last}');
                                                  print(
                                                      'Estoy por fueraAAA ${coorLng.last}');
                                                  //_postEnviarUbicacion.call();
                                                });

                                                if (_foundTraslado[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    global.id_pk =
                                                        (_foundTraslado[index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarTraslados(
                                                          _foundTraslado[index]
                                                              .codigo,
                                                          _foundTraslado[index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciartraslado
                                                        .then((value) {
                                                      print(
                                                          'Prueba API Pedidos');
                                                      if (value['success'] ==
                                                          'OK') {
                                                        print(value);
                                                        mostrarCorrecto(context,
                                                            value['mensaje']);
                                                        progressDialog
                                                            .dismiss();
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                ProcesoEspecificoTraslado
                                                                    .route());
                                                      } else if (value[
                                                              'success'] ==
                                                          'ERROR') {
                                                        mostrarError(context,
                                                            value['mensaje']);
                                                      }
                                                    });
                                                  });
                                                }
                                              }
                                            }
                                          } else {
                                            print('aqui');
                                            if (await Permission
                                                .speech.isPermanentlyDenied) {
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
                                            List<String> coordenadas = [''];
                                            if (status.isDenied) {
                                              if (await Permission.location
                                                  .request()
                                                  .isGranted) {
                                                final postInicial =
                                                    await Geolocator
                                                        .getCurrentPosition();
                                                final String posi =
                                                    postInicial.toString();
                                                var now = DateTime.now();
                                                var formatter =
                                                    DateFormat('yyyy-MM-dd');
                                                String formattedDate =
                                                    formatter.format(now);
                                                if (postInicial != '') {
                                                  setState(() {
                                                    //Preferences.DateRequest = formattedDate;

                                                    coordenadas =
                                                        posi.split(',');
                                                    if (coordenadas.first !=
                                                        '') {
                                                      coorLat =
                                                          (coordenadas.first)
                                                              .split(': ');
                                                      coorLng =
                                                          (coordenadas.last)
                                                              .split(': ');
                                                    }

                                                    print(
                                                        'Estoy por aquiii4 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });

                                                  if (_foundTraslado[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundTraslado[index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarTraslados(
                                                            _foundTraslado[
                                                                    index]
                                                                .codigo,
                                                            _foundTraslado[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciartraslado
                                                          .then((value) {
                                                        print(
                                                            'Prueba API Pedidos');
                                                        if (value['success'] ==
                                                            'OK') {
                                                          print(value);
                                                          mostrarCorrecto(
                                                              context,
                                                              value['mensaje']);
                                                          progressDialog
                                                              .dismiss();
                                                          Navigator.of(context)
                                                              .pushReplacement(
                                                                  ProcesoEspecificoTraslado
                                                                      .route());
                                                        } else if (value[
                                                                'success'] ==
                                                            'ERROR') {
                                                          mostrarError(context,
                                                              value['mensaje']);
                                                        }
                                                      });
                                                    });
                                                  }
                                                }
                                              } else {
                                                if (await Permission.speech
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
                                                  postInicial.toString();
                                              var now = DateTime.now();
                                              var formatter =
                                                  DateFormat('yyyy-MM-dd');
                                              String formattedDate =
                                                  formatter.format(now);
                                              if (postInicial != '') {
                                                setState(() {
                                                  //Preferences.DateRequest = formattedDate;

                                                  coordenadas = posi.split(',');
                                                  if (coordenadas.first != '') {
                                                    coorLat =
                                                        (coordenadas.first)
                                                            .split(': ');
                                                    coorLng = (coordenadas.last)
                                                        .split(': ');
                                                  }

                                                  print(
                                                      'Estoy por aquiii5 ${coorLat.last}');
                                                  print(
                                                      'Estoy por fueraAAA ${coorLng.last}');
                                                  //_postEnviarUbicacion.call();
                                                  global.clienteFactura =
                                                      _foundTraslado[index]
                                                          .nombre_comercial;
                                                  print('aqui');
                                                  print(global.clienteFactura);
                                                });

                                                if (_foundTraslado[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    print('aqui toy' +
                                                        _foundTraslado[index]
                                                            .codigo_servicio);
                                                    global.codigo_servicioDetSoporte =
                                                        _foundTraslado[index]
                                                            .codigo_servicio;
                                                    global.id_pk =
                                                        (_foundTraslado[index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarTraslados(
                                                          _foundTraslado[index]
                                                              .codigo,
                                                          _foundTraslado[index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciartraslado
                                                        .then((value) {
                                                      print(
                                                          'Prueba API Pedidos');
                                                      if (value['success'] ==
                                                          'OK') {
                                                        print(value);
                                                        mostrarCorrecto(context,
                                                            value['mensaje']);
                                                        progressDialog
                                                            .dismiss();
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                                ProcesoEspecificoTraslado
                                                                    .route());
                                                      } else if (value[
                                                              'success'] ==
                                                          'ERROR') {
                                                        mostrarError(context,
                                                            value['mensaje']);
                                                      }
                                                    });
                                                  });
                                                }
                                              }
                                            }
                                          } else {
                                            print('aqui');
                                            if (await Permission
                                                .speech.isPermanentlyDenied) {
                                              print('aqui2');

                                              openAppSettings();
                                            } else {
                                              openAppSettings();
                                            }
                                            mostrarError(context,
                                                'Se requiere acceso a ubicación');
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: varWidth / 3.5,
                                        height: varHeight,
                                        //0color: Colors.blueAccent,
                                        child: Center(
                                            child: Text(
                                                _foundTraslado[index].estado ==
                                                        'ASIGNADO'
                                                    ? 'Iniciar'
                                                    : 'Solucionar',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
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
                                        global.persona_contactar_traslados =
                                            _foundTraslado[index]
                                                .persona_contactar;
                                        global.celular_DetTraslados =
                                            _foundTraslado[index]
                                                .celular_contactar;
                                        global.celular1_DetTraslados =
                                            _foundTraslado[index]
                                                .celular_cliente_1
                                                .toString();
                                        global.celular2_DetTraslados =
                                            _foundTraslado[index]
                                                .celular_cliente_2
                                                .toString();
                                        global.celular3_DetTraslados =
                                            _foundTraslado[index]
                                                .celular_cliente_3
                                                .toString();
                                      });
                                      Navigator.of(context).pushReplacement(
                                          ContactosTraslados.route());
                                    },
                                    child: Container(
                                      width: varWidth / 3.5,
                                      height: varHeight,
                                      //color: Colors.redAccent,
                                      child: Center(
                                          child: Text('Contactos',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

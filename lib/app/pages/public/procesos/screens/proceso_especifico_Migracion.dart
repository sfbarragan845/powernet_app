import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_migraciones.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_tecnico.dart';
import 'package:powernet/app/api/internas/public/select/process_detail/api_detalleUsuario_Migracion.dart';
import 'package:powernet/app/models/migration/Datos_Migracion.dart';
import 'package:powernet/app/pages/public/procesos/widget/contactosMigracion.dart';
import 'package:powernet/app/pages/public/procesos/widget/select_migracion.dart';
import 'package:powernet/app/pages/public/registrarSolucionMigracion/screens/Solucion_Migracion.dart';
import 'package:powernet/app/pages/public/soporte/screens/asignar_tecnico.dart';

import '../../../../api/internas/public/insert/migration/api_iniciar_migracion.dart';
import '../../../../api/internas/public/select/api_listado_ont_libres.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../models/products/listas_prod.dart';
import '../../../../models/products/series_prod.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../asignar_ont_onu/asignar_ont_onu.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '/app/models/var_global.dart' as global;

class ProcesoEspecificoMigracion extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ProcesoEspecificoMigracion(),
    );
  }

  @override
  _ProcesoEspecificoMigracionState createState() =>
      _ProcesoEspecificoMigracionState();
}

class _ProcesoEspecificoMigracionState
    extends State<ProcesoEspecificoMigracion> {
  var suma = 0;
  int nowAnio = DateTime.now().year;
  int nowMon = DateTime.now().month;
  int nowDay = DateTime.now().day;
  List<Datos_Migracion> _foundMigracion = [];
  final _formKey = GlobalKey<FormState>();
  int _cant = 0;
  String _tipocondicion = 'Select...';
  String _tipoape = 'Select...';
  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = ColorFondo.BTNUBI;
  String _tipotecnico = 'Seleccionar';

  Future<void> mostrarList() async {
    setState(() {
      global.tecnicoAcomp.add('Seleccionar');
    });
    for (var i = 0; i < global.listarTecnicos.length; i++) {
      global.tecnicoAcomp.add(global.listarTecnicos[i]['tecnicos']);
    }
    print('aqui el listado que se envia: ' + global.tecnicoAcomp.toString());
  }

  @override
  void initState() {
    super.initState();
    global.ListadoInstalacion.clear();
    global.ListadoMigraciones.clear();
    _foundMigracion.clear();

    listadoMigraciones('').then((value) {
      if (mounted) {
        setState(() {
          global.ListadoMigraciones.addAll(value);
          _foundMigracion = global.ListadoMigraciones;
        });
      }
    });
  }

  void _filtroSoporte(String busqueda) {
    List<Datos_Migracion> results = [];
    //List<Datos_Instalaciones> subResult = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.ListadoMigraciones;
      } else {
        results = global.ListadoMigraciones.where((mig) {
          Intl.defaultLocale = 'es';
          return mig.nombre_comercial
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              mig.codigo_servicio
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              mig.tipo
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              mig.estado
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }
      setState(() {
        this._foundMigracion = results;
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
          'Migraciones',
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
                    itemCount: _foundMigracion.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _foundMigracion[index].estado == 'PENDIENTE'
                                ? Color.fromARGB(255, 247, 147, 30)
                                : _foundMigracion[index].estado == 'ASIGNADO'
                                    ? Color.fromARGB(255, 98, 171, 78)
                                    : _foundMigracion[index].estado ==
                                            'INICIADO'
                                        ? Color.fromARGB(255, 8, 112, 162)
                                        : _foundMigracion[index].estado ==
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
                                      _foundMigracion[index].tipo,
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
                                          _foundMigracion[index].codigo;
                                    });
                                    DetalleMigracion(global.id_pk).then((_) {
                                      detallemigracion.then((value) {
                                        print('Prueba API Pedidos');
                                        if (value['success'] == 'OK') {
                                          print(value);
                                          setState(() {
                                            global.item_DetMigracion =
                                                value['data'][0]['item'];
                                            global.codigo_DetMigracion =
                                                value['data'][0]['codigo'];
                                            global.identificacion_DetMigracion =
                                                value['data'][0]['identidad'];
                                            global.cliente_DetMigracion =
                                                value['data'][0]['cliente'];
                                            global.codigo_servicio_DetMigracion =
                                                value['data'][0]
                                                    ['codigo_servicio'];
                                            global.fechaMigracion_DetMigracion =
                                                value['data'][0]
                                                    ['fecha_migracion'];
                                            global.registrado_DetMigracion =
                                                value['data'][0]['registrado'];
                                            global.ancho_banda_subida_DetMigracion =
                                                value['data'][0][
                                                        'ancho_banda_subida'] ??
                                                    '0';
                                            global.ancho_banda_bajada_DetMigracion =
                                                value['data'][0][
                                                        'ancho_banda_bajada'] ??
                                                    '0';
                                            global.comparticion_DetMigracion =
                                                value['data'][0]
                                                    ['comparticion'];
                                            global.estado_servicio_DetMigracion =
                                                value['data'][0]
                                                    ['estado_servicio'];
                                            global.latitud_Detmigracion =
                                                value['data'][0]['latitud'];
                                            global.longitud_DetMigracion =
                                                value['data'][0]['longitud'];
                                            global.estado_soporte_DetMigracion =
                                                value['data'][0]
                                                    ['estado_soporte'];
                                            global.id_tecnico_DetMigracion =
                                                value['data'][0]
                                                            ['id_tecnico'] ==
                                                        null
                                                    ? ''
                                                    : value['data'][0]
                                                        ['id_tecnico'];
                                            global.usuario_asignado_DetMigracion =
                                                value['data'][0][
                                                            'usuario_asignado'] ==
                                                        null
                                                    ? ''
                                                    : value['data'][0]
                                                        ['usuario_asignado'];
                                            global.fecha_asignacion_DetMigracion =
                                                value['data'][0][
                                                            'fecha_asignacion'] ==
                                                        null
                                                    ? ''
                                                    : value['data'][0]
                                                        ['fecha_asignacion'];
                                            ;
                                            global.direccion_DetMigracion =
                                                value['data'][0]['direccion'];
                                            global.id_cliente_DetMigracion =
                                                value['data'][0]['id_cliente'];
                                            global.ip_migracion =
                                                value['data'][0]['ip_servicio'];
                                            global.red_ip_migracion =
                                                value['data'][0]['red_ip'];
                                            global.mascara_ip_migracion =
                                                value['data'][0]['mascara_ip'];
                                            global.foto_servicio_DetMigracion =
                                                value['data'][0]
                                                    ['foto_servicio'];
                                            global.observacion_migracion =
                                                value['data'][0]['observacion'];
                                            global.vlan_migracion =
                                                value['data'][0]['vlan'];
                                            global.gateway_migracion =
                                                value['data'][0]['gateway'];
                                          });
                                          progressDialog.dismiss();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectMigracion()));
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
                                      _foundMigracion[index].nombre_comercial,
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum2),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    global.id_pk =
                                        _foundMigracion[index].codigo;

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
                                        _foundMigracion[index]
                                                    .usuario_asignado ==
                                                ''
                                            ? 'Seleccionar'
                                            : _foundMigracion[index]
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
                                            .ListadoMigraciones[index]
                                            .usuario_asignado ==
                                        ''
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      /* ProgressDialog progressDialog =
                                          ProgressDialog(context);
                                      progressDialog.show(); */
                                      setState(() {
                                        global.listarONTLIBRES.clear();
                                        global.id_pk =
                                            (_foundMigracion[index].id_servicio)
                                                .toString();
                                      });
                                      if (_foundMigracion[index].tipo ==
                                              'ANTENA A FIBRA OPTICA' ||
                                          _foundMigracion[index].tipo ==
                                              'ANTENA A FIBRA ÓPTICA') {
                                        ProgressDialog progressDialog =
                                            ProgressDialog(context);
                                        progressDialog.show();

                                        listadoONTlibre(global.id_pk, '1')
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
                                                          "MIGRATION"));
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
                                      /* DetalleMigracion(global.id_pk).then((_) {
                                        detallemigracion.then((value) {
                                          print('Prueba API Pedidos');
                                          if (value['success'] == 'OK') {
                                            print(value);
                                            setState(() {
                                              global.item_DetMigracion =
                                                  value['data'][0]['item'];
                                              global.codigo_DetMigracion =
                                                  value['data'][0]['codigo'];
                                              global.identificacion_DetMigracion =
                                                  value['data'][0]['identidad'];
                                              global.cliente_DetMigracion =
                                                  value['data'][0]['cliente'];
                                              global.codigo_servicio_DetMigracion =
                                                  value['data'][0]
                                                      ['codigo_servicio'];
                                              global.fechaMigracion_DetMigracion =
                                                  value['data'][0]
                                                      ['fecha_migracion'];
                                              global.registrado_DetMigracion =
                                                  value['data'][0]
                                                      ['registrado'];
                                              global.ancho_banda_subida_DetMigracion =
                                                  value['data'][0][
                                                          'ancho_banda_subida'] ??
                                                      '0';
                                              global.ancho_banda_bajada_DetMigracion =
                                                  value['data'][0][
                                                          'ancho_banda_bajada'] ??
                                                      '0';
                                              global.comparticion_DetMigracion =
                                                  value['data'][0]
                                                      ['comparticion'];
                                              global.estado_servicio_DetMigracion =
                                                  value['data'][0]
                                                      ['estado_servicio'];
                                              global.latitud_Detmigracion =
                                                  value['data'][0]['latitud'];
                                              global.longitud_DetMigracion =
                                                  value['data'][0]['longitud'];
                                              global.estado_soporte_DetMigracion =
                                                  value['data'][0]
                                                      ['estado_soporte'];
                                              global.id_tecnico_DetMigracion =
                                                  value['data'][0]
                                                              ['id_tecnico'] ==
                                                          null
                                                      ? ''
                                                      : value['data'][0]
                                                          ['id_tecnico'];
                                              global.usuario_asignado_DetMigracion =
                                                  value['data'][0][
                                                              'usuario_asignado'] ==
                                                          null
                                                      ? ''
                                                      : value['data'][0]
                                                          ['usuario_asignado'];
                                              global.fecha_asignacion_DetMigracion =
                                                  value['data'][0][
                                                              'fecha_asignacion'] ==
                                                          null
                                                      ? ''
                                                      : value['data'][0]
                                                          ['fecha_asignacion'];
                                              ;
                                              global.direccion_DetMigracion =
                                                  value['data'][0]['direccion'];
                                              global.id_cliente_DetMigracion =
                                                  value['data'][0]
                                                      ['id_cliente'];
                                              global.ip_migracion =
                                                  value['data'][0]
                                                      ['ip_servicio'];
                                              global.foto_servicio_DetMigracion =
                                                  value['data'][0]
                                                      ['foto_servicio'];
                                              global.vlan_migracion =
                                                  value['data'][0]['vlan'];
                                            });
                                            progressDialog.dismiss();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectMigracion()));
                                          } else if (value['success'] ==
                                              'ERROR') {
                                            mostrarError(
                                                context, value['mensaje']);
                                          }
                                        });
                                      }); */
                                    },
                                    child: Container(
                                      width: varWidth / 3.5,
                                      height: varHeight,
                                      //color: Colors.amber,
                                      child: Center(
                                          child: Text('Agregar ONT',
                                              style: TextStyle(
                                                  color: _foundMigracion[index]
                                                              .tipo ==
                                                          'ANTENA A FIBRA ÓPTICA'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _foundMigracion[index]
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
                                    visible: _foundMigracion[index]
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

                                        if (_foundMigracion[index].estado ==
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
                                                          'Estoy por aquiii1 ${coorLat.last}');
                                                      print(
                                                          'Estoy por fueraAAA ${coorLng.last}');
                                                      //_postEnviarUbicacion.call();
                                                    });
                                                    if (global
                                                            .tipoRequerimiento ==
                                                        'Instalaciones') {
                                                      /* setState(() {
                                                        global.id_pk =
                                                            (_foundInstalaciones[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      }); */
                                                      setState(() {});
                                                    } else {
                                                      if (_foundMigracion[index]
                                                              .estado ==
                                                          'ASIGNADO') {
                                                        setState(() {
                                                          global.id_pk =
                                                              (_foundMigracion[
                                                                          index]
                                                                      .codigo)
                                                                  .toString();
                                                        });
                                                        IniciarMigracion(
                                                                _foundMigracion[
                                                                        index]
                                                                    .codigo,
                                                                _foundMigracion[
                                                                        index]
                                                                    .id_tecnico,
                                                                double.parse(
                                                                    coorLat
                                                                        .last),
                                                                double.parse(
                                                                    coorLng
                                                                        .last))
                                                            .then((_) {
                                                          iniciarmigracion
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
                                                                      ProcesoEspecificoMigracion
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
                                                        'Estoy por aquiii2 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (global
                                                          .tipoRequerimiento ==
                                                      'Instalaciones') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundMigracion[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    setState(() {});
                                                  } else {
                                                    if (_foundMigracion[index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundMigracion[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarMigracion(
                                                              _foundMigracion[
                                                                      index]
                                                                  .codigo,
                                                              _foundMigracion[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciarmigracion
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
                                                                    ProcesoEspecificoMigracion
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
                                                          'Estoy por aquiii3 ${coorLat.last}');
                                                      print(
                                                          'Estoy por fueraAAA ${coorLng.last}');
                                                      //_postEnviarUbicacion.call();
                                                    });
                                                    if (global
                                                            .tipoRequerimiento ==
                                                        'Instalaciones') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundMigracion[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      setState(() {});
                                                    } else {
                                                      if (_foundMigracion[index]
                                                              .estado ==
                                                          'ASIGNADO') {
                                                        setState(() {
                                                          global.id_pk =
                                                              (_foundMigracion[
                                                                          index]
                                                                      .codigo)
                                                                  .toString();
                                                        });
                                                        IniciarMigracion(
                                                                _foundMigracion[
                                                                        index]
                                                                    .codigo,
                                                                _foundMigracion[
                                                                        index]
                                                                    .id_tecnico,
                                                                double.parse(
                                                                    coorLat
                                                                        .last),
                                                                double.parse(
                                                                    coorLng
                                                                        .last))
                                                            .then((_) {
                                                          iniciarmigracion
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
                                                                      ProcesoEspecificoMigracion
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
                                                        'Estoy por aquiii4 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (global
                                                          .tipoRequerimiento ==
                                                      'Instalaciones') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundMigracion[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    setState(() {});
                                                  } else {
                                                    if (_foundMigracion[index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundMigracion[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarMigracion(
                                                              _foundMigracion[
                                                                      index]
                                                                  .codigo,
                                                              _foundMigracion[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciarmigracion
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
                                                                    ProcesoEspecificoMigracion
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
                                        } else if (_foundMigracion[index]
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
                                            global.itemsAdcionales.clear();
                                            global.serieProductsAdicional
                                                .clear();
                                            global.serieProductsAdicional
                                                .clear();
                                            global.nTicketsAdicionales.clear();
                                            global.nDescuentoAdicional.clear();
                                            global.nfacturaSiNoAdicional
                                                .clear();
                                            global.detalleSoluMigracion = '';
                                            global.procedeMigracion = 'SI';
                                            global.isRealizaMigracion = true;
                                            global.codigo_servicio_DetMigracion =
                                                _foundMigracion[index]
                                                    .id_servicio;
                                            global.id_pk =
                                                _foundMigracion[index].codigo;
                                            global.id_tecnico_DetMigracion =
                                                _foundMigracion[index]
                                                    .id_tecnico;
                                            global.id_cliente_DetMigracion =
                                                _foundMigracion[index]
                                                    .id_cliente;
                                            global.codigo_prestacionMigra =
                                                _foundMigracion[index]
                                                    .codigo_prestacion;
                                            global.nombre_prestacionMigra =
                                                _foundMigracion[index]
                                                    .nombre_prestacion;
                                            global.precio_prestacionMigra =
                                                _foundMigracion[index]
                                                    .precio_prestacion;
                                            global.cliente_DetMigracion =
                                                _foundMigracion[index]
                                                    .nombre_comercial;
                                            global.codigo_servicio_DetMigracion_mostrar =
                                                _foundMigracion[index]
                                                    .codigo_servicio;
                                          });

                                          //PRESTACIONES MIGRACIÓN
                                          if (global.codigo_prestacionMigra !=
                                                  '0' &&
                                              double.parse(global
                                                      .precio_prestacionMigra) >
                                                  0) {
                                            global.items.add(lista_producto(
                                              serie: 'NO',
                                              series: 'SN',
                                              items: 9999999,
                                              codigo:
                                                  global.codigo_prestacionMigra,
                                              codigoProducto:
                                                  global.codigo_prestacionMigra,
                                              nombre:
                                                  global.nombre_prestacionMigra,
                                              stock: '1',
                                              precio:
                                                  global.precio_prestacionMigra,
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
                                                print('AQUI CODIGO MIGRACION' +
                                                    ' ' +
                                                    global
                                                        .codigo_servicio_DetMigracion +
                                                    ' ' +
                                                    _foundMigracion[index]
                                                        .id_servicio);
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
                                                            RegistrarMigracion()));
                                              } else if (value['success'] ==
                                                  'ERROR') {
                                                mostrarError(
                                                    context, value['mensaje']);
                                                progressDialog.dismiss();
                                                print('AQUI CODIGO MIGRACION' +
                                                    ' ' +
                                                    global
                                                        .codigo_servicio_DetMigracion +
                                                    ' ' +
                                                    _foundMigracion[index]
                                                        .id_servicio);
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
                                                            RegistrarMigracion()));
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
                                                        'Estoy por aquiii5 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });

                                                  if (_foundMigracion[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundMigracion[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarMigracion(
                                                            _foundMigracion[
                                                                    index]
                                                                .codigo,
                                                            _foundMigracion[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarmigracion
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
                                                                  ProcesoEspecificoMigracion
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
                                                      'Estoy por aquiii6 ${coorLat.last}');
                                                  print(
                                                      'Estoy por fueraAAA ${coorLng.last}');
                                                  //_postEnviarUbicacion.call();
                                                });

                                                if (_foundMigracion[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    global.id_pk =
                                                        (_foundMigracion[index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarMigracion(
                                                          _foundMigracion[index]
                                                              .codigo,
                                                          _foundMigracion[index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciarmigracion
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
                                                                ProcesoEspecificoMigracion
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
                                                        'Estoy por aquiii7 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });

                                                  if (_foundMigracion[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundMigracion[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarMigracion(
                                                            _foundMigracion[
                                                                    index]
                                                                .codigo,
                                                            _foundMigracion[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarmigracion
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
                                                                  ProcesoEspecificoMigracion
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
                                                      'Estoy por aquiii8 ${coorLat.last}');
                                                  print(
                                                      'Estoy por fueraAAA ${coorLng.last}');
                                                  //_postEnviarUbicacion.call();
                                                  global.clienteFactura =
                                                      _foundMigracion[index]
                                                          .nombre_comercial;
                                                  print('aqui');
                                                  print(global.clienteFactura);
                                                });

                                                if (_foundMigracion[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    print('aqui toy' +
                                                        _foundMigracion[index]
                                                            .codigo_servicio);
                                                    global.codigo_servicioDetSoporte =
                                                        _foundMigracion[index]
                                                            .codigo_servicio;
                                                    global.id_pk =
                                                        (_foundMigracion[index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarMigracion(
                                                          _foundMigracion[index]
                                                              .codigo,
                                                          _foundMigracion[index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciarmigracion
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
                                                                ProcesoEspecificoMigracion
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
                                                _foundMigracion[index].estado ==
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
                                        global.celular1_DetMigracion =
                                            _foundMigracion[index]
                                                .celular_cliente_1
                                                .toString();
                                        global.celular2_DetMigracion =
                                            _foundMigracion[index]
                                                .celular_cliente_2
                                                .toString();
                                        global.celular3_DetMigracion =
                                            _foundMigracion[index]
                                                .celular_cliente_3
                                                .toString();
                                        global.celular_DetMigracion =
                                            _foundMigracion[index]
                                                .celular_contactar
                                                .toString();
                                        global.persona_contactar_migracion =
                                            _foundMigracion[index]
                                                .persona_contactar
                                                .toString();
                                      });
                                      Navigator.of(context).pushReplacement(
                                          ContactosMigracion.route());
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

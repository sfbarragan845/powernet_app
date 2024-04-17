import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powernet/app/api/internas/public/insert/support/api_iniciar_soporte.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_tecnico.dart';
import 'package:powernet/app/api/internas/public/select/process_detail/api_detalleUsuario_Soporte.dart';
import 'package:powernet/app/models/support/Datos_Soportes.dart';
import 'package:powernet/app/pages/public/registrarSolucion/screens/registrar_solucion.dart';
import 'package:powernet/app/pages/public/soporte/screens/asignar_tecnico.dart';

import '../../../../api/internas/public/select/api_listado_ont_libres.dart';
import '../../../../api/internas/public/select/api_listado_soportes.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../asignar_ont_onu/asignar_ont_onu.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '../widget/contactos.dart';
import '../widget/select_insidente.dart';
import '/app/models/var_global.dart' as global;

class ProcesoEspecificoIncidente extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ProcesoEspecificoIncidente(),
    );
  }

  @override
  _ProcesoEspecificoIncidenteState createState() =>
      _ProcesoEspecificoIncidenteState();
}

class _ProcesoEspecificoIncidenteState
    extends State<ProcesoEspecificoIncidente> {
  var suma = 0;
  int nowAnio = DateTime.now().year;
  int nowMon = DateTime.now().month;
  int nowDay = DateTime.now().day;
  List<Datos_Soportes> _foundSoportes = [];
  Future<void> mostrarList() async {
    setState(() {
      global.tecnicoAcomp.add('Seleccionar');
    });
    for (var i = 0; i < global.listarTecnicos.length; i++) {
      global.tecnicoAcomp.add(global.listarTecnicos[i]['tecnicos']);
    }
    print('aqui el listado que se envia: ' + global.tecnicoAcomp.toString());
  }

  final _formKey = GlobalKey<FormState>();

  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = ColorFondo.BTNUBI;
  @override
  void initState() {
    super.initState();
    global.ListadoInstalacion.clear();
    global.ListadoSoportes.clear();
    _foundSoportes.clear();

    listadoSoportes('').then((value) {
      if (mounted) {
        setState(() {
          global.ListadoSoportes.addAll(value);
          _foundSoportes = global.ListadoSoportes;
        });
      }
    });
  }

  void _filtroSoporte(String busqueda) {
    List<Datos_Soportes> results = [];
    //List<Datos_Instalaciones> subResult = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.ListadoSoportes;
      } else {
        results = global.ListadoSoportes.where((sop) {
          Intl.defaultLocale = 'es';
          return DateFormat.yMMMMd()
                  .format(DateTime.parse(sop.fecha_reportado))
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              sop.nombre_comercial
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              sop.codigo_servicio
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              sop.categoria_incidente
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              sop.estado
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }
      setState(() {
        this._foundSoportes = results;
      });
    }
    // print(_foundEvents.length);
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Soportes',
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
                    itemCount: _foundSoportes.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _foundSoportes[index].estado == 'PENDIENTE'
                                ? Color.fromARGB(255, 247, 147, 30)
                                : _foundSoportes[index].estado == 'ASIGNADO'
                                    ? Color.fromARGB(255, 98, 171, 78)
                                    : _foundSoportes[index].estado == 'INICIADO'
                                        ? Color.fromARGB(255, 8, 112, 162)
                                        : _foundSoportes[index].estado ==
                                                'FINALIZADO'
                                            ? Colors.green
                                            : Colors.red
                            /* global.tipoRequerimiento=='Instalaciones'?
                          int.parse(global.ListadoInstalacion[index].fecha_instalar.substring(0,4))>=nowAnio?
                          int.parse(global.ListadoInstalacion[index].fecha_instalar.substring(5,7))>=nowMon?
                          int.parse(global.ListadoInstalacion[index].fecha_instalar.substring(8,10))==nowDay?Color.fromARGB(255, 247, 147, 30):
                          int.parse(global.ListadoInstalacion[index].fecha_instalar.substring(8,10))<nowDay?Colors.red:Colors.green:
                          Colors.red:Colors.red:global.tipoRequerimiento=='Incidentes'?
                          int.parse(global.ListadoSoportes[index].fecha_reportado.substring(0,4))>=nowAnio?
                          int.parse(global.ListadoSoportes[index].fecha_reportado.substring(5,7))>=nowMon?
                          int.parse(global.ListadoSoportes[index].fecha_reportado.substring(8,10))==nowDay?Color.fromARGB(255, 247, 147, 30):
                          int.parse(global.ListadoSoportes[index].fecha_reportado.substring(9,10))<nowDay?Colors.red:Colors.green:
                          Colors.red:Colors.red:Colors.red, */
                            ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    /* Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectInsidencias())); */
                                    /* Navigator.of(context)
                                            .pushReplacement(SelectInsidencias.route()); */
                                  },
                                  child: Container(
                                    width: 110,
                                    child: Text(
                                      _foundSoportes[index].categoria_incidente,
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
                                          _foundSoportes[index].codigo;
                                    });
                                    DetalleSoporte(global.id_pk).then((_) {
                                      detallesoporte.then((value) {
                                        print('Prueba API Pedidos');
                                        if (value['success'] == 'OK') {
                                          print(value);
                                          setState(() {
                                            global.identidadcodigoDetSoporte =
                                                value['data'][0]['identidad'];
                                            global.itemDetSoporte =
                                                value['data'][0]['item'];
                                            global.codigoDetSoporte =
                                                value['data'][0]['codigo'];
                                            global.clienteDetSoporte =
                                                value['data'][0]['cliente'];
                                            global.codigo_servicioDetSoporte =
                                                value['data'][0]
                                                    ['codigo_servicio'];
                                            global.fecha_visitarDetSoporte =
                                                value['data'][0]
                                                    ['fecha_visitar'];
                                            global.registradoDetSoporte =
                                                value['data'][0]['registrado'];
                                            global.incidenteDetSoporte =
                                                value['data'][0]['incidente'] ==
                                                            '' ||
                                                        value['data'][0]
                                                                ['incidente'] ==
                                                            null
                                                    ? 'hola'
                                                    : value['data'][0]
                                                        ['incidente'];
                                            global.ancho_banda_subidaDetSoporte =
                                                value['data'][0][
                                                        'ancho_banda_subida'] ??
                                                    '0';
                                            global.ancho_banda_bajadaDetSoporte =
                                                value['data'][0][
                                                        'ancho_banda_bajada'] ??
                                                    '0';
                                            global.comparticionDetSoporte =
                                                value['data'][0]
                                                    ['comparticion'];
                                            global.estado_servicioDetSoporte =
                                                value['data'][0]
                                                    ['estado_servicio'];
                                            global.latitudDetSoporte =
                                                value['data'][0]['latitud'];
                                            global.longitudDetSoporte =
                                                value['data'][0]['longitud'];
                                            global.estado_soporteDetSoporte =
                                                value['data'][0]
                                                    ['estado_soporte'];
                                            global.contactarDetSoporte =
                                                value['data'][0]['contactar'];
                                            global.usuario_asignadoDetSoporte =
                                                value['data'][0]
                                                    ['usuario_asignado'];
                                            global.fecha_asignacionDetSoporte =
                                                value['data'][0][
                                                            'fecha_asignacion'] ==
                                                        null
                                                    ? ''
                                                    : value['data'][0]
                                                        ['fecha_asignacion'];
                                            global.direccionDetSoporte =
                                                value['data'][0]['direccion'];
                                            global.categoria_incidenteDetSoporte =
                                                value['data'][0]
                                                    ['categoria_incidente'];
                                            global.prioridad_servicioDetSoporte =
                                                value['data'][0]
                                                    ['prioridad_servicio'];
                                            global.codigo_clienteSoporte =
                                                value['data'][0]['id_cliente'];
                                            global.ip_soporte =
                                                value['data'][0]['ip_servicio'];
                                            global.red_ip_soporte =
                                                value['data'][0]['red_ip'];
                                            global.mascara_ip_soporte =
                                                value['data'][0]['mascara_ip'];
                                            global.foto_servicio_DetSoporte =
                                                value['data'][0]
                                                    ['foto_servicio'];
                                            global.observacion_soporte =
                                                value['data'][0]['observacion'];
                                            global.vlan_soporte =
                                                value['data'][0]['vlan'];
                                            global.gateway_soporte =
                                                value['data'][0]['gateway'];
                                          });
                                          progressDialog.dismiss();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectInsidencias()));
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
                                    width: 110,
                                    child: Center(
                                        child: Text(
                                      global.tipoRequerimiento ==
                                              'Instalaciones'
                                          ? _foundSoportes[index]
                                              .nombre_comercial
                                          : _foundSoportes[index]
                                              .nombre_comercial,
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum2),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    global.id_pk = _foundSoportes[index].codigo;

                                    listadoTecnico('hola').then((_) {
                                      lisTecnico.then((value) {
                                        print('Prueba API Pedidos');
                                        if (value['success'] == 'OK') {
                                          print(value);

                                          global.listarTecnicos = value['data'];
                                          mostrarList();
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
                                        _foundSoportes[index]
                                                    .usuario_asignado ==
                                                ''
                                            ? 'Seleccionar'
                                            : _foundSoportes[index]
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
                                mainAxisAlignment:
                                    _foundSoportes[index].usuario_asignado == ''
                                        ? MainAxisAlignment.center
                                        : MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      /* ProgressDialog progressDialog =
                                          ProgressDialog(context);
                                      progressDialog.show(); */
                                      /* setState(() {
                                        global.id_pk =
                                            _foundSoportes[index].id_servicio;
                                      }); */
                                      if (_foundSoportes[index].tipoConexion ==
                                          'FIBRA OPTICA') {
                                        ProgressDialog progressDialog =
                                            ProgressDialog(context);
                                        progressDialog.show();
                                        setState(() {
                                          global.listarONTLIBRES.clear();
                                          global.id_pk = (_foundSoportes[index]
                                                  .id_servicio)
                                              .toString();
                                        });
                                        listadoONTlibre(global.id_pk, '3')
                                            .then((_) {
                                          lisONT.then((value) {
                                            print(value);
                                            print('listado ont');
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
                                                          "SUPORT"));
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
                                      /* DetalleSoporte(global.id_pk).then((_) {
                                        detallesoporte.then((value) {
                                          print('Prueba API Pedidos');
                                          if (value['success'] == 'OK') {
                                            print(value);
                                            setState(() {
                                              global.identidadcodigoDetSoporte =
                                                  value['data'][0]['identidad'];
                                              global.itemDetSoporte =
                                                  value['data'][0]['item'];
                                              global.codigoDetSoporte =
                                                  value['data'][0]['codigo'];
                                              global.clienteDetSoporte =
                                                  value['data'][0]['cliente'];
                                              global.codigo_servicioDetSoporte =
                                                  value['data'][0]
                                                      ['codigo_servicio'];
                                              global.fecha_visitarDetSoporte =
                                                  value['data'][0]
                                                      ['fecha_visitar'];
                                              global.registradoDetSoporte =
                                                  value['data'][0]
                                                      ['registrado'];
                                              global
                                                  .incidenteDetSoporte = value[
                                                                  'data'][0]
                                                              ['incidente'] ==
                                                          '' ||
                                                      value['data'][0]
                                                              ['incidente'] ==
                                                          null
                                                  ? 'hola'
                                                  : value['data'][0]
                                                      ['incidente'];
                                              global.ancho_banda_subidaDetSoporte =
                                                  value['data'][0][
                                                          'ancho_banda_subida'] ??
                                                      '0';
                                              global.ancho_banda_bajadaDetSoporte =
                                                  value['data'][0][
                                                          'ancho_banda_bajada'] ??
                                                      '0';
                                              global.comparticionDetSoporte =
                                                  value['data'][0]
                                                      ['comparticion'];
                                              global.estado_servicioDetSoporte =
                                                  value['data'][0]
                                                      ['estado_servicio'];
                                              global.latitudDetSoporte =
                                                  value['data'][0]['latitud'];
                                              global.longitudDetSoporte =
                                                  value['data'][0]['longitud'];
                                              global.estado_soporteDetSoporte =
                                                  value['data'][0]
                                                      ['estado_soporte'];
                                              global.contactarDetSoporte =
                                                  value['data'][0]['contactar'];
                                              global.usuario_asignadoDetSoporte =
                                                  value['data'][0]
                                                      ['usuario_asignado'];
                                              global.fecha_asignacionDetSoporte =
                                                  value['data'][0][
                                                              'fecha_asignacion'] ==
                                                          null
                                                      ? ''
                                                      : value['data'][0]
                                                          ['fecha_asignacion'];
                                              global.direccionDetSoporte =
                                                  value['data'][0]['direccion'];
                                              global.categoria_incidenteDetSoporte =
                                                  value['data'][0]
                                                      ['categoria_incidente'];
                                              global.prioridad_servicioDetSoporte =
                                                  value['data'][0]
                                                      ['prioridad_servicio'];
                                              global.ip_soporte = value['data']
                                                  [0]['ip_servicio'];
                                              global.foto_servicio_DetSoporte =
                                                  value['data'][0]
                                                      ['foto_servicio'];
                                              global.vlan_soporte =
                                                  value['data'][0]['vlan'];
                                            });
                                            progressDialog.dismiss();
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectInsidencias()));
                                          } else if (value['success'] ==
                                              'ERROR') {
                                            progressDialog.dismiss();
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
                                                  color: _foundSoportes[index]
                                                              .tipoConexion ==
                                                          'FIBRA OPTICA'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _foundSoportes[index]
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
                                    visible: _foundSoportes[index]
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

                                        if (_foundSoportes[index].estado ==
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
                                                            (_foundSoportes[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      setState(() {});
                                                    } else {
                                                      if (_foundSoportes[index]
                                                              .estado ==
                                                          'ASIGNADO') {
                                                        setState(() {
                                                          global.id_pk =
                                                              (_foundSoportes[
                                                                          index]
                                                                      .codigo)
                                                                  .toString();
                                                        });
                                                        IniciarSoporte(
                                                                _foundSoportes[
                                                                        index]
                                                                    .codigo,
                                                                _foundSoportes[
                                                                        index]
                                                                    .id_tecnico,
                                                                double.parse(
                                                                    coorLat
                                                                        .last),
                                                                double.parse(
                                                                    coorLng
                                                                        .last))
                                                            .then((_) {
                                                          iniciarsoporte
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
                                                                      ProcesoEspecificoIncidente
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
                                                          (_foundSoportes[index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    setState(() {});
                                                  } else {
                                                    if (_foundSoportes[index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundSoportes[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarSoporte(
                                                              _foundSoportes[
                                                                      index]
                                                                  .codigo,
                                                              _foundSoportes[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciarsoporte
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
                                                                    ProcesoEspecificoIncidente
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
                                                            (_foundSoportes[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      setState(() {});
                                                    } else {
                                                      if (_foundSoportes[index]
                                                              .estado ==
                                                          'ASIGNADO') {
                                                        setState(() {
                                                          global.id_pk =
                                                              (_foundSoportes[
                                                                          index]
                                                                      .codigo)
                                                                  .toString();
                                                        });
                                                        IniciarSoporte(
                                                                _foundSoportes[
                                                                        index]
                                                                    .codigo,
                                                                _foundSoportes[
                                                                        index]
                                                                    .id_tecnico,
                                                                double.parse(
                                                                    coorLat
                                                                        .last),
                                                                double.parse(
                                                                    coorLng
                                                                        .last))
                                                            .then((_) {
                                                          iniciarsoporte
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
                                                                      ProcesoEspecificoIncidente
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
                                                        'Estoy por aquiii9 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (global
                                                          .tipoRequerimiento ==
                                                      'Instalaciones') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundSoportes[index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    setState(() {});
                                                  } else {
                                                    if (_foundSoportes[index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundSoportes[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarSoporte(
                                                              _foundSoportes[
                                                                      index]
                                                                  .codigo,
                                                              _foundSoportes[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciarsoporte
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
                                                                    ProcesoEspecificoIncidente
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
                                        } else if (_foundSoportes[index]
                                                .estado ==
                                            'INICIADO') {
                                          print(_foundSoportes[index].estado);
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
                                            global.detalleSoluSoporte = '';
                                            global.procedeSoporte = 'SI';
                                            global.isRealizaSoporte = true;
                                            print('por aca');
                                            global.codigo_servicioDetSoporte =
                                                _foundSoportes[index]
                                                    .codigo_servicio;
                                            global.id_pk =
                                                _foundSoportes[index].codigo;
                                            global.id_tecnico =
                                                _foundSoportes[index]
                                                    .id_tecnico;
                                            global.codigo_clienteSoporte =
                                                _foundSoportes[index]
                                                    .id_cliente;
                                            global.clienteDetSoporte =
                                                _foundSoportes[index]
                                                    .nombre_comercial;
                                          });
                                          listadoTecnico('hola').then((_) {
                                            lisTecnico.then((value) async {
                                              print('Prueba API Pedidos');
                                              if (value['success'] == 'OK') {
                                                print(value);
                                                setState(() {
                                                  global.listarTecnicos =
                                                      value['data'];
                                                  global.ischeckedCoord = true;
                                                  global.updateCoords = false;
                                                  global.btnUpdateCoords =
                                                      false;
                                                  global.facturaOficina = false;
                                                  global.tipo_factura_soporte =
                                                      'Seleccionar';
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
                                                await mostrarList();
                                                progressDialog.dismiss();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarSolucion()));
                                              } else if (value['success'] ==
                                                  'ERROR') {
                                                setState(() {
                                                  global.ischeckedCoord = true;
                                                  global.updateCoords = false;
                                                  global.btnUpdateCoords =
                                                      false;
                                                  global.facturaOficina = false;
                                                  global.tipo_factura_soporte =
                                                      'Seleccionar';
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
                                                mostrarError(
                                                    context, value['mensaje']);
                                                progressDialog.dismiss();
                                                print(global
                                                    .codigo_clienteSoporte);

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarSolucion()));
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
                                                  if (_foundSoportes[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundSoportes[index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarSoporte(
                                                            _foundSoportes[
                                                                    index]
                                                                .codigo,
                                                            _foundSoportes[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarsoporte
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
                                                                  ProcesoEspecificoIncidente
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

                                                if (_foundSoportes[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    global.id_pk =
                                                        (_foundSoportes[index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarSoporte(
                                                          _foundSoportes[index]
                                                              .codigo,
                                                          _foundSoportes[index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciarsoporte
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
                                                                ProcesoEspecificoIncidente
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

                                                  if (_foundSoportes[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundSoportes[index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarSoporte(
                                                            _foundSoportes[
                                                                    index]
                                                                .codigo,
                                                            _foundSoportes[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarsoporte
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
                                                                  ProcesoEspecificoIncidente
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
                                                      _foundSoportes[index]
                                                          .nombre_comercial;
                                                  print('aqui');
                                                  print(global.clienteFactura);
                                                });

                                                if (_foundSoportes[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    print('aqui toy' +
                                                        _foundSoportes[index]
                                                            .codigo_servicio);
                                                    global.codigo_servicioDetSoporte =
                                                        _foundSoportes[index]
                                                            .codigo_servicio;
                                                    global.id_pk =
                                                        (_foundSoportes[index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarSoporte(
                                                          _foundSoportes[index]
                                                              .codigo,
                                                          _foundSoportes[index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciarsoporte
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
                                                                ProcesoEspecificoIncidente
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
                                                _foundSoportes[index].estado ==
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
                                        global.celular1_DetSoporte =
                                            _foundSoportes[index]
                                                .celular_cliente_1
                                                .toString();
                                        global.celular2_DetSoporte =
                                            _foundSoportes[index]
                                                .celular_cliente_2
                                                .toString();
                                        global.celular3_DetSoporte =
                                            _foundSoportes[index]
                                                .celular_cliente_3
                                                .toString();
                                        global.celular_DetSoporte =
                                            _foundSoportes[index]
                                                .celular_contactar
                                                .toString();
                                      });
                                      Navigator.of(context)
                                          .pushReplacement(Contactos.route());
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

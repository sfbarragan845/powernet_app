import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powernet/app/api/internas/public/insert/instalation/api_iniciar_instalacion.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_tecnico.dart';
import 'package:powernet/app/api/internas/public/select/process_detail/api_detalleUsuario_Instalacion.dart';
import 'package:powernet/app/models/instalation/Datos_prestacion.dart';
import 'package:powernet/app/models/support/Datos_Soportes.dart';
import 'package:powernet/app/pages/public/procesos/widget/contactosInstalacion.dart';
import 'package:powernet/app/pages/public/soporte/screens/asignar_tecnico.dart';

import '../../../../api/internas/public/select/api_listado_instalaciones.dart';
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
import '../../registrarSolucionInsta/screens/Solucion_Instalacion.dart';
import '../widget/select_instalacion.dart';
import '/app/models/var_global.dart' as global;

class ProcesoEspecificoInstalacion extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ProcesoEspecificoInstalacion(),
    );
  }

  @override
  _ProcesoEspecificoInstalacionState createState() =>
      _ProcesoEspecificoInstalacionState();
}

class _ProcesoEspecificoInstalacionState
    extends State<ProcesoEspecificoInstalacion> {
  //  print(PreferencesProductos.usrProductos);
  // dynamic data;
  var suma = 0;
  int nowAnio = DateTime.now().year;
  int nowMon = DateTime.now().month;
  int nowDay = DateTime.now().day;
  List<Datos_Instalaciones> _foundInstalaciones = [];
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
  int _cant = 0;
  String _tipocondicion = 'Select...';
  String _tipoape = 'Select...';
  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = ColorFondo.BTNUBI;
  String _tipotecnico = 'Seleccionar';
  @override
  void initState() {
    super.initState();
    _init();
    prestacionesInit();
  }

  void _init() {
    listadoInstalaciones('').then((value) {
      setState(() {
        global.ListadoInstalacion.clear();
        _foundInstalaciones.clear();
      });
      // if (mounted) {
      setState(() {
        global.ListadoInstalacion.addAll(value);
        _foundInstalaciones = global.ListadoInstalacion;
      });
      //}
    });
  }

  void prestacionesInit() {
    global.arrayPrestacionInst.clear();
    //final evento = global.data_prestacion['data'][index]['prestaciones'] as List<dynamic>;
    // for(var i =0; i<= evento.length-1;i++){

    print(global.data_prestacion);
    /* print('aqui mi len---- ' + evento.length.toString());
        //print('aqui mi lista press---- ' + pres.toString());
                print(evento);
        for (var eventos in evento) {
          global.arrayPrestacionInst.add(Datos_Prestacion.fromJson(eventos));
          //lista.add(registros.where((tipo_evento) => tipo_evento=='FESTIVAL'));
        } */
    //}
    print(
        'aqui array prestacion' + global.arrayPrestacionInst.length.toString());
    print('aqui array prestacion' + global.arrayPrestacionInst.toString());
  }

  void _filtroInstalacion(String busqueda) {
    List<Datos_Instalaciones> results = [];
    //List<Datos_Instalaciones> subResult = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.ListadoInstalacion;
      } else {
        results = global.ListadoInstalacion.where((inst) {
          Intl.defaultLocale = 'es';
          return DateFormat.yMMMMd()
                  .format(DateTime.parse(inst.fecha_reportado))
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              inst.nombre_comercial
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              inst.codigo_servicio
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              inst.tipoConexion
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              inst.estado
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }

      setState(() {
        this._foundInstalaciones = results;
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
          global.tipoRequerimiento,
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
                              onChanged: (value) => _filtroInstalacion(value),
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
                        'Conexión',
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
                    itemCount: _foundInstalaciones.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: _foundInstalaciones[index].estado ==
                                    'PENDIENTE'
                                ? Color.fromARGB(255, 247, 147, 30)
                                : _foundInstalaciones[index].estado ==
                                        'ASIGNADO'
                                    ? Color.fromARGB(255, 98, 171, 78)
                                    : _foundInstalaciones[index].estado ==
                                            'INICIADO'
                                        ? Color.fromARGB(255, 8, 112, 162)
                                        : _foundInstalaciones[index].estado ==
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
                                      _foundInstalaciones[index].tipoConexion,
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
                                          (_foundInstalaciones[index].codigo)
                                              .toString();
                                    });
                                    try {
                                      DetalleInstalacion(global.id_pk)
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
                                              global.observacion_instalacion =
                                                  value['data'][0]
                                                      ['observacion'];
                                              global.frame_instalacion =
                                                  value['data'][0]['frame'];
                                              global.slot_instalacion =
                                                  value['data'][0]['slot'];
                                              global.puerto_instalacion =
                                                  value['data'][0]['puerto'];
                                              global.service_port_instalacion =
                                                  value['data'][0]
                                                      ['service_port'];
                                              global.vlan_instalacion =
                                                  value['data'][0]['vlan'];
                                              global.gateway_instalacion =
                                                  value['data'][0]['gateway'];
                                              global.vendedor =
                                                  value['data'][0]['vendedor'];
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
                                    } catch (e) {
                                      mostrarError(context, e.toString());
                                    }
                                  },
                                  child: Container(
                                    width: 110,
                                    child: Center(
                                        child: Text(
                                      _foundInstalaciones[index]
                                          .nombre_comercial,
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum2),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      global.id_pk =
                                          (_foundInstalaciones[index].codigo)
                                              .toString();
                                    });

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
                                        _foundInstalaciones[index]
                                                    .usuario_asignado ==
                                                ''
                                            ? 'Seleccionar'
                                            : _foundInstalaciones[index]
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
                                  color: ColorFondo.BTNUBI),
                              child: Row(
                                mainAxisAlignment: _foundInstalaciones[index]
                                            .usuario_asignado ==
                                        ''
                                    ? MainAxisAlignment.center
                                    : MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_foundInstalaciones[index]
                                              .tipoConexion ==
                                          'FIBRA OPTICA') {
                                        ProgressDialog progressDialog =
                                            ProgressDialog(context);
                                        progressDialog.show();
                                        setState(() {
                                          global.listarONTLIBRES.clear();
                                          global.id_pk =
                                              (_foundInstalaciones[index]
                                                      .id_servicio)
                                                  .toString();
                                        });
                                        listadoONTlibre(global.id_pk, '0')
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
                                                          "INSTALATION"));
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
                                    },
                                    child: Container(
                                      width: varWidth / 3.5,
                                      height: varHeight,
                                      //color: Colors.amber,
                                      child: Center(
                                          child: Text('Agregar ONT',
                                              style: TextStyle(
                                                  color: _foundInstalaciones[
                                                                  index]
                                                              .tipoConexion ==
                                                          'FIBRA OPTICA'
                                                      ? Colors.white
                                                      : Colors.grey,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                    ),
                                  ),
                                  Visibility(
                                    visible: _foundInstalaciones[index]
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
                                    visible: _foundInstalaciones[index]
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

                                        if (_foundInstalaciones[index].estado ==
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
                                                          'Estoy por aquiii3 ${coorLat.last}');
                                                      print(
                                                          'Estoy por fueraAAA ${coorLng.last}');
                                                      //_postEnviarUbicacion.call();
                                                    });
                                                    if (_foundInstalaciones[
                                                                index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundInstalaciones[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarInstalacion(
                                                              _foundInstalaciones[
                                                                      index]
                                                                  .codigo,
                                                              _foundInstalaciones[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciarInstalacion
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
                                                                    ProcesoEspecificoInstalacion
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
                                                  if (_foundInstalaciones[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundInstalaciones[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarInstalacion(
                                                            _foundInstalaciones[
                                                                    index]
                                                                .codigo,
                                                            _foundInstalaciones[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarInstalacion
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
                                                                  ProcesoEspecificoInstalacion
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
                                                          'Estoy por aquiii5 ${coorLat.last}');
                                                      print(
                                                          'Estoy por fueraAAA ${coorLng.last}');
                                                      //_postEnviarUbicacion.call();
                                                    });
                                                    if (_foundInstalaciones[
                                                                index]
                                                            .estado ==
                                                        'ASIGNADO') {
                                                      setState(() {
                                                        global.id_pk =
                                                            (_foundInstalaciones[
                                                                        index]
                                                                    .codigo)
                                                                .toString();
                                                      });
                                                      IniciarInstalacion(
                                                              _foundInstalaciones[
                                                                      index]
                                                                  .codigo,
                                                              _foundInstalaciones[
                                                                      index]
                                                                  .id_tecnico,
                                                              double.parse(
                                                                  coorLat.last),
                                                              double.parse(
                                                                  coorLng.last))
                                                          .then((_) {
                                                        iniciarInstalacion
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
                                                                    ProcesoEspecificoInstalacion
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
                                                        'Estoy por aquiii6 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (_foundInstalaciones[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundInstalaciones[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarInstalacion(
                                                            _foundInstalaciones[
                                                                    index]
                                                                .codigo,
                                                            _foundInstalaciones[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarInstalacion
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
                                                                  ProcesoEspecificoInstalacion
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
                                        } else if (_foundInstalaciones[index]
                                                .estado ==
                                            'INICIADO') {
                                          setState(() {
                                            global.items.clear();
                                            global.arrayPrestacionInst.clear();
                                            global.serieProducts.clear();
                                            global.serieProducts.clear();
                                            global.nTickets.clear();
                                            global.nDescuento.clear();
                                            global.nfacturaSiNo.clear();
                                            global.itemsAdcionales.clear();
                                            global.procedeInstalacion = 'SI';
                                            global.isRealizaInstalacion = true;
                                            global.serieProductsAdicional
                                                .clear();
                                            global.serieProductsAdicional
                                                .clear();
                                            global.nTicketsAdicionales.clear();
                                            global.nDescuentoAdicional.clear();
                                            global.nfacturaSiNoAdicional
                                                .clear();
                                            global.detalleSoluInstalacion = '';
                                            print('por aca2');
                                            global.codigo_servicioDetInstalacion =
                                                _foundInstalaciones[index]
                                                    .codigo_servicio;
                                            global.id_pk =
                                                _foundInstalaciones[index]
                                                    .codigo;
                                            global.id_tecnico =
                                                _foundInstalaciones[index]
                                                    .id_tecnico;
                                            global.codigo_clienteInstalacion =
                                                _foundInstalaciones[index]
                                                    .id_cliente;
                                            global.clienteDetInstalacion =
                                                _foundInstalaciones[index]
                                                    .nombre_comercial;
                                            print('por aca 3');
                                            print(global.data_prestacion['data']
                                                [index]['prestaciones']);
                                            final evento =
                                                global.data_prestacion['data']
                                                        [index]['prestaciones']
                                                    as List<dynamic>;
                                            for (var eventos in evento) {
                                              global.arrayPrestacionInst.add(
                                                  Datos_Prestacion.fromJson(
                                                      eventos));
                                              //lista.add(registros.where((tipo_evento) => tipo_evento=='FESTIVAL'));
                                            }
                                            print('por aca 4');
                                          });

                                          if (mounted) {
                                            if (global.items.isEmpty) {
                                              for (var i = 0;
                                                  i <=
                                                      global.arrayPrestacionInst
                                                              .length -
                                                          1;
                                                  i++) {
                                                setState(() {
                                                  global.items
                                                      .add(lista_producto(
                                                    serie: 'NO',
                                                    series: 'SN',
                                                    items: 9999999,
                                                    codigo: global
                                                        .arrayPrestacionInst[i]
                                                        .codigo_prestacion,
                                                    codigoProducto: global
                                                        .arrayPrestacionInst[i]
                                                        .codigo_prestacion,
                                                    nombre: global
                                                        .arrayPrestacionInst[i]
                                                        .nombre_prestacion,
                                                    stock: '1',
                                                    precio: global
                                                        .arrayPrestacionInst[i]
                                                        .precio_prestacion,
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
                                                          garantia_vigente:
                                                              'NO'));
                                                  global.nTickets.add(1);
                                                  global.nfacturaSiNo.add('SI');
                                                  global.nDescuento.add(0);
                                                });
                                              }
                                              print('por aqui variables prestacipones ' +
                                                  global
                                                      .detalleSoluInstalacion);
                                              print('INGRESE');
                                            } else {}
                                          }
                                          print('aqui' +
                                              _foundInstalaciones[index]
                                                  .observacion_servicio);
                                          setState(() {
                                            global.tecnicoAcomp.clear();
                                            global.listarTecnicos.clear();
                                            global.selectAcomp = 'Seleccionar';
                                          });
                                          print(global.detalleSoluInstalacion);
                                          print('aqui array prestaciones----' +
                                              global.arrayPrestacionInst.length
                                                  .toString());
                                          if (3 ==
                                              global
                                                  .arrayPrestacionInst.length) {
                                            print(
                                                'aqui array prestaciones 3----' +
                                                    global
                                                        .arrayPrestacionInst[0]
                                                        .codigo_prestacion +
                                                    '+++' +
                                                    global
                                                        .arrayPrestacionInst[1]
                                                        .codigo_prestacion +
                                                    '---' +
                                                    global
                                                        .arrayPrestacionInst[2]
                                                        .codigo_prestacion);
                                          } else {}
                                          listadoTecnico('hola').then((_) {
                                            lisTecnico.then((value) async {
                                              print('Prueba API Pedidos');
                                              if (value['success'] == 'OK') {
                                                print(value);
                                                setState(() {
                                                  global.listarTecnicos =
                                                      value['data'];
                                                  global.deleteImg = true;
                                                  global.persona_presente = '';
                                                  global.nCuotasAdicionales =
                                                      '1';
                                                  global.visiblecuotasadi =
                                                      false;
                                                });
                                                await mostrarList();
                                                progressDialog.dismiss();

                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarInstalacion()));
                                              } else if (value['success'] ==
                                                  'ERROR') {
                                                setState(() {
                                                  global.deleteImg = true;
                                                  global.persona_presente = '';
                                                  global.nCuotasAdicionales =
                                                      '1';
                                                  global.visiblecuotasadi =
                                                      false;
                                                });
                                                mostrarError(
                                                    context, value['mensaje']);
                                                progressDialog.dismiss();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegistrarInstalacion()));
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
                                                        'Estoy por aquiii7 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (_foundInstalaciones[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundInstalaciones[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarInstalacion(
                                                            _foundInstalaciones[
                                                                    index]
                                                                .codigo,
                                                            _foundInstalaciones[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarInstalacion
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
                                                                  ProcesoEspecificoInstalacion
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
                                                });
                                                if (_foundInstalaciones[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    global.id_pk =
                                                        (_foundInstalaciones[
                                                                    index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarInstalacion(
                                                          _foundInstalaciones[
                                                                  index]
                                                              .codigo,
                                                          _foundInstalaciones[
                                                                  index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciarInstalacion
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
                                                                ProcesoEspecificoInstalacion
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
                                                        'Estoy por aquiii1 ${coorLat.last}');
                                                    print(
                                                        'Estoy por fueraAAA ${coorLng.last}');
                                                    //_postEnviarUbicacion.call();
                                                  });
                                                  if (_foundInstalaciones[index]
                                                          .estado ==
                                                      'ASIGNADO') {
                                                    setState(() {
                                                      global.id_pk =
                                                          (_foundInstalaciones[
                                                                      index]
                                                                  .codigo)
                                                              .toString();
                                                    });
                                                    IniciarInstalacion(
                                                            _foundInstalaciones[
                                                                    index]
                                                                .codigo,
                                                            _foundInstalaciones[
                                                                    index]
                                                                .id_tecnico,
                                                            double.parse(
                                                                coorLat.last),
                                                            double.parse(
                                                                coorLng.last))
                                                        .then((_) {
                                                      iniciarInstalacion
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
                                                                  ProcesoEspecificoInstalacion
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
                                                      'Estoy por aquiii2 ${coorLat.last}');
                                                  print(
                                                      'Estoy por fueraAAA ${coorLng.last}');
                                                  //_postEnviarUbicacion.call();

                                                  global.clienteFactura =
                                                      _foundInstalaciones[index]
                                                          .nombre_comercial;
                                                  print('aqui');
                                                  print(global.clienteFactura);
                                                });
                                                if (_foundInstalaciones[index]
                                                        .estado ==
                                                    'ASIGNADO') {
                                                  setState(() {
                                                    global.id_pk =
                                                        (_foundInstalaciones[
                                                                    index]
                                                                .codigo)
                                                            .toString();
                                                  });
                                                  IniciarInstalacion(
                                                          _foundInstalaciones[
                                                                  index]
                                                              .codigo,
                                                          _foundInstalaciones[
                                                                  index]
                                                              .id_tecnico,
                                                          double.parse(
                                                              coorLat.last),
                                                          double.parse(
                                                              coorLng.last))
                                                      .then((_) {
                                                    iniciarInstalacion
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
                                                                ProcesoEspecificoInstalacion
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
                                                _foundInstalaciones[index]
                                                            .estado ==
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
                                        global.celular1_DetInstalacion =
                                            _foundInstalaciones[index]
                                                .celular_cliente_1
                                                .toString();
                                        global.celular2_DetInstalacion =
                                            _foundInstalaciones[index]
                                                .celular_cliente_2
                                                .toString();
                                        global.celular3_DetInstalacion =
                                            _foundInstalaciones[index]
                                                .celular_cliente_3
                                                .toString();
                                      });
                                      Navigator.of(context).pushReplacement(
                                          ContactosInstalaciones.route());
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

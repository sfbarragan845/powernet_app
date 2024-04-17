import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../clases/cParametros.dart';
import '/app/models/var_global.dart' as global;
import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';

class SelectCortadosImpago extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => SelectCortadosImpago(),
    );
  }

  @override
  _SelectCortadosImpago createState() => _SelectCortadosImpago();
}

class _SelectCortadosImpago extends State<SelectCortadosImpago> {
  @override
  void initState() {
    super.initState();
  }

  void _launchMapUrl(
    String latit_Tec,
    String lng_Tec,
    String latit_Cli,
    String lng_Cli,
  ) async {
    //final url = 'https://www.google.com/maps/search/?api=1&query=$latit,$lng';
    final url =
        'https://www.google.com.ec/maps/dir/$latit_Tec,$lng_Tec/$latit_Cli,$lng_Cli/data=!4m6!4m5!1m0!1m3!2m2!1d-63.1578587!2d-17.7685492?hl=es';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se puedo correr la URL';
    }
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Servicio Seleccionado'),
        backgroundColor: ColorFondo.PRIMARY,
      ),
      //drawer: const MenuPrincipal(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            //color: Color.fromARGB(0, 68, 137, 255),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Identificación:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.identidadcodigoDetSoporte,
                                    style: TextStyle(color: Colors.black)),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
//height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            height: varHeight * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Cliente:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              height: varHeight * 0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      global.cliente_detCortados,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'F. Factura:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.fecha_factura_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                global.estado_servicio_detCortados ==
                                        'CORTADO POR IMPAGO'
                                    ? 'Fecha Corte:'
                                    : 'Fecha de Retiro',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  global.fecha_corte_detCortados,
                                  maxLines: 1,
                                ),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Meses Activo:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.meses_activos_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Saldo Servicio:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.saldo_servicio_detCortados
                                    .toString()),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            height: varHeight * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'IP Radio:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              height: varHeight * 0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      global.ip_radio_detCortados,
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'ID Servicio:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.codigo_servicio_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            height: varHeight * 0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Estado Servicio:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              height: varHeight * 0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        global.estado_servicio_detCortados),
                                  ),
                                ],
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ancho Banda Subida:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(global.ancho_banda_subida_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ancho Banda Bajada:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(global.ancho_banda_bajada_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Comparte:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.comparticion_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            height: varHeight * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Dir. Servicio:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              height: varHeight * 0.2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      global.direccion_detCortados,
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            //color: Color(0xFF94CCF9),
                            border: Border.all(
                              color: Color.fromARGB(255, 161, 161, 161),
                              width: 2,
                            ),
                            //borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: varWidth * 0.45,
                          //height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                var status = await Permission.location.status;
                                if (status.isDenied) {
                                  if (await Permission.location
                                      .request()
                                      .isGranted) {
                                    Position position =
                                        await Geolocator.getCurrentPosition(
                                            desiredAccuracy:
                                                LocationAccuracy.high);
                                    if (global.latitud_detCortados == '0' &&
                                        global.longitud_detCortados == '0') {
                                      AwesomeDialog(
                                              dismissOnTouchOutside: false,
                                              context: context,
                                              dialogType: DialogType.error,
                                              animType: AnimType.topSlide,
                                              headerAnimationLoop: true,
                                              title: 'SIN COORDENADAS',
                                              dialogBackgroundColor:
                                                  Colors.white,
                                              desc:
                                                  'No se han registrado coordenadas en el Sistema.',
                                              btnOkOnPress: () {},
                                              //btnOkIcon: Icons.cancel,
                                              btnOkText: 'Aceptar',
                                              btnOkColor: Colors.green
                                              //  btnOkColor: Colors.red,
                                              )
                                          .show();
                                    } else {
                                      _launchMapUrl(
                                          (position.latitude).toString(),
                                          position.longitude.toString(),
                                          global.latitud_detCortados,
                                          global.longitud_detCortados);
                                    }

                                    /*  setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  UbicacionClienteScreen())));
                                    }); */
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
                                  Position position =
                                      await Geolocator.getCurrentPosition(
                                          desiredAccuracy:
                                              LocationAccuracy.high);
                                  if (global.latitud_detCortados == '0' &&
                                      global.longitud_detCortados == '0') {
                                    AwesomeDialog(
                                            dismissOnTouchOutside: false,
                                            context: context,
                                            dialogType: DialogType.error,
                                            animType: AnimType.topSlide,
                                            headerAnimationLoop: true,
                                            title: 'SIN COORDENADAS',
                                            dialogBackgroundColor: Colors.white,
                                            desc:
                                                'No se han registrado coordenadas en el Sistema.',
                                            btnOkOnPress: () {},
                                            //btnOkIcon: Icons.cancel,
                                            btnOkText: 'Aceptar',
                                            btnOkColor: Colors.green
                                            //  btnOkColor: Colors.red,
                                            )
                                        .show();
                                  } else {
                                    _launchMapUrl(
                                        (position.latitude).toString(),
                                        position.longitude.toString(),
                                        global.latitud_detCortados,
                                        global.longitud_detCortados);
                                  }

                                  /* setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                UbicacionClienteScreen())));
                                  }); */
                                }
                              },
                              child: Container(
                                  //width: varWidth * 0.45,
                                  height: varHeight * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorFondo.BTNUBI),
                                  child: Center(
                                    child: Text(
                                      'Ver Ubicación',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //color: Color(0xFF94CCF9),
                            border: Border.all(
                              color: Color.fromARGB(255, 161, 161, 161),
                              width: 2,
                            ),
                            //borderRadius: BorderRadius.circular(10.0),
                          ),
                          width: varWidth * 0.45,
                          //height: 50,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                print('aqui mis coordenadas ' +
                                    global.latitud_detCortados +
                                    ',' +
                                    global.longitud_detCortados);
                                if (global.latitud_detCortados == '0' &&
                                    global.longitud_detCortados == '0') {
                                  AwesomeDialog(
                                          dismissOnTouchOutside: false,
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.topSlide,
                                          headerAnimationLoop: true,
                                          title: 'SIN COORDENADAS',
                                          dialogBackgroundColor: Colors.white,
                                          desc:
                                              'No se han registrado coordenadas en el Sistema.',
                                          btnOkOnPress: () {},
                                          //btnOkIcon: Icons.cancel,
                                          btnOkText: 'Aceptar',
                                          btnOkColor: Colors.green
                                          //  btnOkColor: Colors.red,
                                          )
                                      .show();
                                } else {
                                  final data = ClipboardData(
                                      text: global.latitud_detCortados +
                                          ',' +
                                          global.longitud_detCortados);
                                  await Clipboard.setData(data);

                                  Fluttertoast.showToast(
                                      msg: "Coordenadas copiadas ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: ColorFondo.BTNUBI,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              },
                              child: Container(
                                  //width: varWidth * 0.45,
                                  height: varHeight * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorFondo.BTNUBI),
                                  child: Center(
                                    child: Text(
                                      'Copiar Ubicación',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      // height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth * 0.45,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ip Navegación:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                //color: Color(0xFF94CCF9),
                                border: Border.all(
                                  color: Color.fromARGB(255, 161, 161, 161),
                                  width: 2,
                                ),
                                //borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: varWidth * 0.45,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(global.ip_servicio_detCortados),
                              ))
                        ],
                      )),
                  Container(
                      color: Color.fromARGB(0, 255, 193, 7),
                      width: varWidth,
                      //height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    '$ROOT3$fotos_servicios${global.foto_servicio_detCortados}'),
                                fit: BoxFit.cover,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: varWidth / 1.1,
                            height: varHeight / 2,
                          ),
                        ],
                      )),
                ],
              ),
            )
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

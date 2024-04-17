import 'package:powernet/app/pages/public/soporte/screens/asignar_tecnico.dart';
import 'package:powernet/app/pages/public/procesos/widget/ubicacion_cliente.dart';
import 'package:powernet/app/pages/public/registrarSolucion/screens/registrar_solucion.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../../../models/share_preferences.dart';
import '../../../components/mostrar_snack.dart';
import '../../home/screens/menu.dart';
import '/app/models/var_global.dart' as global;

class SelectInsidencias extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => SelectInsidencias(),
    );
  }

  @override
  _SelectInsidenciasState createState() => _SelectInsidenciasState();
}

class _SelectInsidenciasState extends State<SelectInsidencias> {
  var suma = 0;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ipcontroller;
  late TextEditingController _apellidoscontroller;
  late TextEditingController _nombreController;
  late TextEditingController _AsignadoController;
  int _cant = 0;
  String _tipocondicion = 'Select...';
  String _tipoape = 'Select...';
  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = Color.fromARGB(255, 139, 139, 139);
  String _tipotecnico = 'Seleccionar';
  @override
  void initState() {
    super.initState();
    _ipcontroller = TextEditingController();
    _apellidoscontroller = TextEditingController();
    _nombreController = TextEditingController();
    _AsignadoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Incidente Seleccionado'),
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
                              child: Text('Identificación:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('1754986555'),
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
                           height: varHeight *0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Cliente:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                           height: varHeight *0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(global.tipotecnico,maxLines: 2,),
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
                              child: Text('F. Visitar:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('01/12/2022 14:33'),
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
                              child: Text('Registrado:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('drivadeneira',maxLines: 1,),
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
                           height: varHeight *0.1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Incidente:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                           height: varHeight *0.1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Verificar el servicio está lento',maxLines: 3,),
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
                              child: Text('ID Servicio:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('1513'),
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
                              child:  Text('Estado Servicio:', style: TextStyle(fontWeight: FontWeight.bold),),
                              
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
                                child: Text('Al día'),
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
                              child: Text('Ancho BS:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('30720'),
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
                              child: Text('Ancho BB:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('30720'),
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
                              child: Text('Comparte:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('3:1'),
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
                           height: varHeight *0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Dir. Servicio:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                              height: varHeight *0.2,
                              child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Av.29 de Mayo e Ibarra, frente a almacenes TIA Edificio 4 pisos, baldosa azul.',maxLines: 5,),
                                  ),
                                ],
                              ))
                        ],
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left:9.0, right: 9.0),
                    child: Container(
                      decoration: BoxDecoration(
                              //color: Color(0xFF94CCF9),
                              border: Border.all(
                                color: Color.fromARGB(255, 161, 161, 161),
                                width: 2,
                              ),
                              //borderRadius: BorderRadius.circular(10.0),
                            ),
                      width: varWidth,
                      //height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            var status = await Permission.location.status;
                        if (status.isDenied) {
                          if (await Permission.location.request().isGranted) {
                            setState(() {
                          
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          UbicacionClienteScreen())));
                            });
                          } else {
                            print('aqui');
                            if (await Permission.speech.isPermanentlyDenied) {
                              print('aqui2');

                              openAppSettings();
                            }else {
                              openAppSettings();
                            }
                            mostrarError(
                                context, 'Se requiere acceso a ubicación');
                          }
                        } else {
                          setState(() {
                            
                    

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        UbicacionClienteScreen())));
                          });
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
                  ),
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
                              child: Text('Ip Radio:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('Fibra Optica'),
                              ))
                        ],
                      )),
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
                              child: Text('Ip Navegación:', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                child: Text('192.168.153.50'),
                              ))
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
    _apellidoscontroller.dispose();
    _ipcontroller.dispose();
  }
}

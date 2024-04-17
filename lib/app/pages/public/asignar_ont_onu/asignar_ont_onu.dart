import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico_Migracion.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico_Traslado.dart';

import '../../../api/internas/public/insert/instalation/api_asignar_ont.dart';
import '../../../clases/cConfig_UI.dart';
import '../../components/mostrar_snack.dart';
import '../procesos/screens/proceso_especifico_Inst.dart';
import '/app/models/var_global.dart' as global;

class AsignarONT extends StatefulWidget {
  final String type;
  const AsignarONT({Key? key, required this.type}) : super(key: key);
  static Route<dynamic> route(String type) {
    return MaterialPageRoute(
      builder: (context) => AsignarONT(type: type),
    );
  }

  @override
  _AsignarONTState createState() => _AsignarONTState();
}

class _AsignarONTState extends State<AsignarONT>
    with SingleTickerProviderStateMixin {
  bool waiting = false;
  bool inter = true;
  var listener;
  @override
  initState() {
    super.initState();
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          if (mounted) {
            setState(() {
              inter = true;
            });
          }
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          if (mounted) {
            setState(() {
              inter = false;
            });
          }
          break;
      }
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text('Asignación Puerto PON',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            leading: IconButton(
                onPressed: () {
                  switch (widget.type) {
                    case 'INSTALATION':
                      Navigator.of(context).pushReplacement(
                          ProcesoEspecificoInstalacion.route());
                      break;
                    case 'MIGRATION':
                      Navigator.of(context)
                          .pushReplacement(ProcesoEspecificoMigracion.route());
                      break;
                    case 'TRANSFER':
                      Navigator.of(context)
                          .pushReplacement(ProcesoEspecificoTraslado.route());
                      break;
                    case 'SUPORT':
                      Navigator.of(context)
                          .pushReplacement(ProcesoEspecificoIncidente.route());
                      break;
                  }
                },
                icon: Icon(Icons.arrow_back, color: Colors.white))),
        body: Container(
          width: varWidth,
          height: varHeight,
          //color:Colors.red,
          child: global.listarONTLIBRES.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'No se encontró ninguna ONT disponible',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  ],
                )
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                color: ColorFondo.BTNUBI,
                              ),
                          itemCount: global.listarONTLIBRES.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (inter == true) {
                                  AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.info,
                                          animType: AnimType.bottomSlide,
                                          //headerAnimationLoop: true,
                                          title:
                                              'Asignar Puerto PON: ${global.listarONTLIBRES[index]['Ont SN']}',
                                          dialogBackgroundColor: Colors.white,
                                          //  desc: 'Por favor, cambie e intente nuevamente.',
                                          btnOkOnPress: () {
                                            setState(() {
                                              waiting = true;
                                            });
                                            List<String> partes = global
                                                .listarONTLIBRES[index]
                                                    ['Ont SN']
                                                .split(' ');

                                            // Tomar la primera parte
                                            String puertopon = partes[0];
                                            int tipoAsignacion = 0;
                                            if (widget.type == 'INSTALATION') {
                                              setState(() {
                                                tipoAsignacion = 0;
                                              });
                                            } else if (widget.type ==
                                                'MIGRATION') {
                                              setState(() {
                                                setState(() {
                                                  tipoAsignacion = 1;
                                                });
                                              });
                                            } else if (widget.type ==
                                                'TRANSFER') {
                                              setState(() {
                                                tipoAsignacion = 2;
                                              });
                                            } else if (widget.type ==
                                                'SUPORT') {
                                              setState(() {
                                                tipoAsignacion = 3;
                                              });
                                            }

                                            asignarONT(global.id_pk, puertopon,
                                                    tipoAsignacion)
                                                .then((value) {
                                              if (value == null) {
                                                setState(() {
                                                  waiting = false;
                                                });
                                                mostrarErrorMSG(context,
                                                    "NO hay conexion con el servidor");
                                                return;
                                              }
                                              //print(value);
                                              if (value['success'] == 'OK') {
                                                setState(() {
                                                  waiting = false;
                                                });
                                                mostrarCorrectoMSG(
                                                    context, value['mensaje']);

                                                switch (widget.type) {
                                                  case 'INSTALATION':
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            ProcesoEspecificoInstalacion
                                                                .route());
                                                    break;
                                                  case 'MIGRATION':
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            ProcesoEspecificoMigracion
                                                                .route());
                                                    break;
                                                  case 'TRANSFER':
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            ProcesoEspecificoTraslado
                                                                .route());
                                                    break;
                                                  case 'SUPORT':
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                            ProcesoEspecificoIncidente
                                                                .route());
                                                    break;
                                                }
                                              } else {
                                                setState(() {
                                                  waiting = false;
                                                });
                                                mostrarErrorMSG(
                                                    context, value['mensaje']);
                                              }
                                            });
                                            /* Navigator.pop(context); */
                                          },
                                          //btnOkIcon: Icons.cancel,
                                          btnCancelOnPress: () {},
                                          btnCancelColor: Colors.red,
                                          btnCancelText: 'Cancelar',
                                          btnOkText: 'Aceptar',
                                          btnOkColor: ColorFondo.BTNUBI
                                          //  btnOkColor: Colors.red,
                                          )
                                      .show();
                                } else {
                                  mostrarCorrectoMSG(
                                      context, 'Sin conexión a internet');
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                                //color: Colors.amber,
                                //height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Puerto PON: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: ColorFondo.BTNUBI)),
                                      Text(
                                          global.listarONTLIBRES[index]
                                              ['Ont SN'],
                                          style: TextStyle(fontSize: 15)),
                                      Row(
                                        children: [
                                          Text('F/S/P: ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          Text(global.listarONTLIBRES[index]
                                              ['F/S/P']),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('VendorID: ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          Text(global.listarONTLIBRES[index]
                                              ['VendorID']),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text('Ont EquipmentID: ',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold)),
                                          Text(global.listarONTLIBRES[index]
                                              ['Ont EquipmentID']),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                    ),
                    Visibility(
                        visible: waiting,
                        child: Container(
                            color: Colors.white,
                            width: varWidth,
                            height: varHeight,
                            child: Center(
                                child: Image.asset(
                                    'assets/images/loading_chart.gif'))))
                  ],
                ),
        ));
  }
}

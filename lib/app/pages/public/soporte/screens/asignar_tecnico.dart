import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:powernet/app/api/internas/public/insert/instalation/api_asignar_instalacion.dart';
import 'package:powernet/app/api/internas/public/insert/migration/api_asignar_migracion.dart';
import 'package:powernet/app/api/internas/public/insert/support/api_asignar_soporte.dart';
import 'package:powernet/app/api/internas/public/insert/transfer/api_asignar_traslado.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico_Inst.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico_Migracion.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../procesos/screens/proceso_especifico.dart';
import '../../procesos/screens/proceso_especifico_Traslado.dart';
import '/app/models/var_global.dart' as global;

class AsignarTecnicos extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => AsignarTecnicos(),
    );
  }

  @override
  _AsignarTecnicosState createState() => _AsignarTecnicosState();
}

class _AsignarTecnicosState extends State<AsignarTecnicos> {
  var suma = 0;
  bool isvisibleTec = false;
  late TextEditingController _ipcontroller;
  late TextEditingController _apellidoscontroller;

  @override
  void initState() {
    super.initState();
    _ipcontroller = TextEditingController();
    _apellidoscontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: isvisibleTec == false
            ? Container(
                width: varWidth,
                height: varHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorFondo.BTNUBI, //light blue
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: varWidth * 1,
                        height: varHeight * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 20),
                              width: varWidth / 1.3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Asignar Técnico',
                                    style: TextStyle(
                                        color: ColorFondo.BLANCO,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: SvgPicture.asset(
                                          'assets/icons/XMARK_white.svg'))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    isvisibleTec = true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(
                                        255, 250, 250, 250), //blue
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  width: varWidth * 0.6,
                                  height: varHeight * 0.08,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        global.tipotecnico,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                          color: Colors.black,
                        ),
                    itemCount: global.listarTecnicos.length,
                    itemBuilder: ((context, index) {
                      print(global.listarTecnicos[index]['codigo']);
                      return GestureDetector(
                        onTap: () {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.question,
                                  animType: AnimType.bottomSlide,
                                  //headerAnimationLoop: true,
                                  title:
                                      'Asignar tarea a ${global.listarTecnicos[index]['tecnicos']}',
                                  dialogBackgroundColor: Colors.white,
                                  //  desc: 'Por favor, cambie e intente nuevamente.',
                                  btnOkOnPress: () {
                                    redirectPage(index);
                                    //Navigator.pop(context);
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
                        },
                        child: Container(
                          //color: Colors.amber,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(global.listarTecnicos[index]['tecnicos']),
                            ],
                          ),
                        ),
                      );
                    })),
              ));
  }

  @override
  void dispose() {
    super.dispose();
    _apellidoscontroller.dispose();
    _ipcontroller.dispose();
  }

  void redirectPage(index) {
    if (global.tipoRequerimiento == 'Instalaciones') {
      setState(() {
        AsignarInstalacion(global.id_pk, global.listarTecnicos[index]['codigo'])
            .then((_) {
          asignarInstalacion.then((value) {
            if (value['success'] == 'OK') {
              mostrarCorrecto(context, value['mensaje']);
              Navigator.of(context)
                  .pushReplacement(ProcesoEspecificoInstalacion.route());
            } else if (value['success'] == 'ERROR') {
              mostrarError(context, value['mensaje']);
            }
          });
          // progressDialog.dismiss();
        });
      });
    } else if (global.tipoRequerimiento == 'Migracion') {
      setState(() {
        AsignarMigracion(global.id_pk, global.listarTecnicos[index]['codigo'])
            .then((_) {
          asignarMigracion.then((value) {
            if (value['success'] == 'OK') {
              mostrarCorrecto(context, value['mensaje']);
              Navigator.of(context)
                  .pushReplacement(ProcesoEspecificoMigracion.route());
            } else if (value['success'] == 'ERROR') {
              mostrarError(context, value['mensaje']);
            }
          });
          // progressDialog.dismiss();
        });
      });
    } else if (global.tipoRequerimiento == 'Incidentes') {
      setState(() {
        AsignarSoporte(global.id_pk, global.listarTecnicos[index]['codigo'])
            .then((_) {
          asignarSoporte.then((value) {
            if (value['success'] == 'OK') {
              mostrarCorrecto(context, value['mensaje']);
              Navigator.of(context)
                  .pushReplacement(ProcesoEspecificoIncidente.route());
            } else if (value['success'] == 'ERROR') {
              mostrarError(context, value['mensaje']);
            }
          });
          // progressDialog.dismiss();
        });
      });
    } else if (global.tipoRequerimiento == 'Traslado') {
      setState(() {
        AsignarTraslado(global.id_pk, global.listarTecnicos[index]['codigo'])
            .then((_) {
          asignarTraslado.then((value) {
            if (value['success'] == 'OK') {
              mostrarCorrecto(context, value['mensaje']);
              Navigator.of(context)
                  .pushReplacement(ProcesoEspecificoTraslado.route());
            } else if (value['success'] == 'ERROR') {
              mostrarError(context, value['mensaje']);
            }
          });
          // progressDialog.dismiss();
        });
      });
    }
  }
}

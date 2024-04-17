import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:powernet/app/pages/public/recursos/recursos.dart';

import '../../../../api/internas/public/insert/withdrawal/api_finalizar_retiro.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../actionScreens/action_screens.dart';
import '/app/models/var_global.dart' as global;

class RegistrarSolucionRetiro extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => RegistrarSolucionRetiro(),
    );
  }

  @override
  _RegistrarSolucionRetiroState createState() =>
      _RegistrarSolucionRetiroState();
}

class _RegistrarSolucionRetiroState extends State<RegistrarSolucionRetiro> {
  //TEXT CONTROLLERS
  final motivoController = TextEditingController();
  bool chbEJecutado = false;
  bool chbEJecutado_ischecked = true;
  bool chbEquipos = false;
  bool chbEquipos_ischecked = true;
  bool btnProductos = false;

  final detEquiposController = TextEditingController();
  final observacionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool buttonEnabled = true;

  String? latitude = '';
  String? longitude = '';

  Color _btnFactura = Color.fromARGB(255, 214, 214, 214);

  @override
  void initState() {
    super.initState();
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
        automaticallyImplyLeading: true,
        title: Text('Registrar Solución'),
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
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Motivo:'),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            //color: Color.fromARGB(255, 233, 229, 229),
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              global.detalleSoluSoporte = value.toString();
                            },
                            controller: motivoController,
                            maxLines: 5,
                            decoration: InputDecoration.collapsed(
                                hintText: "Escriba aquí el motivo"),
                          ),
                        )))
                      ],
                    ),
                    CheckboxListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Acepto que he ejecutado el retiro',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: chbEJecutado,
                      onChanged: chbEJecutado_ischecked
                          ? (newValue) {
                              if (chbEJecutado == false) {
                                btnProductos = true;
                              } else {
                                btnProductos = false;
                                chbEquipos = false;
                                detEquiposController.clear();
                              }

                              setState(() {
                                chbEJecutado = newValue!;
                              });
                            }
                          : null,
                      activeColor: ColorFondo.PRIMARY,
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    Visibility(
                      visible: btnProductos,
                      child: Column(
                        children: <Widget>[
                          CheckboxListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text:
                                              'Acepto que he retirado los equipos y debo entregarlos en oficina',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            value: chbEquipos,
                            onChanged: chbEquipos_ischecked
                                ? (newValue) {
                                    if (chbEquipos == false) {
                                      //btnProductos = true;
                                      AwesomeDialog(
                                              context: context,
                                              dialogType:
                                                  DialogType.infoReverse,
                                              animType: AnimType.bottomSlide,
                                              //headerAnimationLoop: true,
                                              title:
                                                  'Recuerda que debes detallar los equipos que has retirado',
                                              dialogBackgroundColor:
                                                  Colors.white,
                                              //  desc: 'Por favor, cambie e intente nuevamente.',
                                              btnOkOnPress: () {
                                                //Navigator.pop(context);
                                              },
                                              btnOkText: 'Aceptar',
                                              btnOkColor: ColorFondo.BTNUBI)
                                          .show();
                                    }

                                    setState(() {
                                      chbEquipos = newValue!;
                                    });
                                  }
                                : null,
                            activeColor: ColorFondo.PRIMARY,
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('Detalle de Equipos:'),
                              ),
                            ],
                          ),
                          sombra(Card(
                              //color: Color.fromARGB(255, 233, 229, 229),
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              onChanged: (value) {
                                //global.detalleSoluSoporte = value.toString();
                              },
                              controller: detEquiposController,
                              maxLines: 11,
                              decoration: InputDecoration.collapsed(
                                  hintText:
                                      "Detalle aquí los productos que ha retirado o porque no retiro los equipos"),
                            ),
                          )))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Observación:'),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            //color: Color.fromARGB(255, 233, 229, 229),
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              global.detalleSoluSoporte = value.toString();
                            },
                            controller: observacionController,
                            maxLines: 8,
                            decoration: InputDecoration.collapsed(
                                hintText: "Escriba aquí la solución"),
                          ),
                        )))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
                            ),
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: buttonEnabled
                                  ? () async {
                                      print('Pos aca');
                                      global.items.forEach(print);

                                      ProgressDialog progressDialog =
                                          ProgressDialog(context);
                                      progressDialog.show();

                                      if (motivoController.text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Detalle un motivo para continuar');
                                      } else if (observacionController
                                          .text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Detalle una observacion para continuar');
                                      } else if (chbEJecutado == true &&
                                          detEquiposController.text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Detalle los equipos retirados o porque no se retiraron');
                                      } else {
                                        setState(() {
                                          buttonEnabled = false;
                                        });

                                        await FinalizarRetiro(
                                                global.id_pk,
                                                global.id_cliente,
                                                chbEJecutado == true
                                                    ? 'SI'
                                                    : 'NO',
                                                chbEquipos == true
                                                    ? 'SI'
                                                    : 'NO',
                                                detEquiposController.text,
                                                observacionController.text,
                                                motivoController.text,
                                                chbEJecutado == true
                                                    ? 'SUSPENCION'
                                                    : 'GESTION')
                                            .then((_) {
                                          finalizarRetiro.then((value) {
                                            print(value.toString());
                                            if (value['success'] == 'OK') {
                                              setState(() {
                                                global.id_pk = '';
                                                global.id_cliente = '';
                                                motivoController.text = '';
                                                chbEJecutado = false;
                                                chbEquipos = false;
                                                detEquiposController.text = '';
                                                observacionController.text = '';
                                              });

                                              print(value);

                                              progressDialog.dismiss();

                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActionScreens(
                                                                  message: value[
                                                                      'mensaje'],
                                                                  type:
                                                                      'SUCCESS')),
                                                      (Route<dynamic> route) =>
                                                          false);
                                            } else if (value['success'] ==
                                                'ERROR') {
                                              progressDialog.dismiss();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActionScreens(
                                                            message: value[
                                                                'mensaje'],
                                                            type: 'ERROR',
                                                          )));
                                              /* Navigator.of(
                                                      context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActionScreens(
                                                                  message: value[
                                                                      'mensaje'],
                                                                  type:
                                                                      'ERROR')),
                                                      (Route<dynamic> route) =>
                                                          false); */
                                            }
                                          });
                                        });
                                        progressDialog.dismiss();
                                      }
                                    }
                                  : null,
                              child: Container(
                                  width: varWidth * 0.6,
                                  height: varHeight * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorFondo.BTNUBI),
                                  child: Center(
                                    child: Text(
                                      'Registrar solución'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

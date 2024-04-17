import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:powernet/app/pages/public/recursos/recursos.dart';
import 'package:flutter/material.dart';

import '../../../../api/internas/public/insert/withdrawal/api_finalizar_retiro.dart';
import '../../actionScreens/action_screens.dart';
import '/app/models/var_global.dart' as global;
import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../home/screens/home.dart';

class RegistrarSolucionActividad extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => RegistrarSolucionActividad(),
    );
  }

  @override
  _RegistrarSolucionActividadState createState() =>
      _RegistrarSolucionActividadState();
}

class _RegistrarSolucionActividadState
    extends State<RegistrarSolucionActividad> {
  //TEXT CONTROLLERS

  final observacionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool buttonEnabled = true;

  String? latitude = '';
  String? longitude = '';

  List<String> list_options = <String>[
    'Deposito',
    'Auxiliar Técnico',
    'Compras',
    'Mensajeria',
    'Otro'
  ];

  String dropdownValue = '';

  @override
  void initState() {
    super.initState();
    dropdownValue = list_options.first;
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
        title: Text('Registrar Actividad'),
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
                                child: SizedBox(
                                  width: varWidth,
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    elevation: 16,
                                    style: const TextStyle(
                                        color: Color.fromARGB(195, 56, 56, 56),
                                        fontSize: 14),
                                    underline: Container(
                                      height: 0,
                                    ),
                                    onChanged: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                    items: list_options
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Text(value),
                                            SizedBox(
                                                width: varWidth /
                                                    2), // Espacio entre el icono y el texto
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ))))
                      ],
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

                                      if (dropdownValue.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Detalle un motivo para continuar');
                                      } else if (observacionController
                                          .text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Detalle una observacion para continuar');
                                      } else {
                                        setState(() {
                                          buttonEnabled = false;
                                        });
                                        await FinalizarRetiro(
                                                '0',
                                                '0',
                                                'NO',
                                                'NO',
                                                '',
                                                observacionController.text,
                                                dropdownValue.toString(),
                                                'ACTIVIDAD')
                                            .then((_) {
                                          finalizarRetiro.then((value) {
                                            print(value.toString());
                                            if (value['success'] == 'OK') {
                                              setState(() {
                                                global.id_pk = '';
                                                global.id_cliente = '';
                                                dropdownValue =
                                                    list_options.first;
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
                                              Navigator.of(
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
                                                          false);
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
                                      'Registrar Actividad'.toUpperCase(),
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

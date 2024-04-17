import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:powernet/app/models/charges/Datos_Documentos.dart';
import 'package:powernet/app/pages/public/recursos/recursos.dart';
import 'package:powernet/app/pages/public/report_pdf/screens/pdf_screenCobro.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../../../api/internas/public/insert/charges/api_finalizar_cobro.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../models/pdf/producto_Pdf.dart';
import '../../../../models/share_preferences.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../actionScreens/action_screens.dart';
import '/app/models/var_global.dart' as global;

class RegistrarCobro extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => RegistrarCobro(),
    );
  }

  @override
  _RegistrarCobroState createState() => _RegistrarCobroState();
}

class _RegistrarCobroState extends State<RegistrarCobro> {
  //TEXT CONTROLLERS
  final valor = TextEditingController();
  final observacionController = TextEditingController();
  final fecha_cheque = TextEditingController();
  final numero_cheque = TextEditingController();
  bool buttonEnabled = true;
  final _formKey = GlobalKey<FormState>();
  String? latitude = '';
  String? longitude = '';

  String bancosValue = '';
  String documentoValue = '';
  String estadoServicio = '';
  int id_cliente = 0;
  int id_servicio = 0;

  bool is_cortado_impago = false;
  bool is_cheque = false;
  bool is_proporcional = false;
  DateTime fecha = DateTime.now();

  DateTime fechaActual = DateTime.now();
  DateTime fechaIngresada = DateTime.now();
  List<String> list_options = <String>[
    'EFECTIVO',
    'CHEQUE',
  ];

  List<String> list_options_factura = <String>[
    'SELECCIONAR',
    'COMPLETA',
    'PROPORCIONAL',
    'AGENDAR RECONEXION',
  ];

  String tipo_pago = '';
  String generar_factura = '';
  String valorPdf = '';
  @override
  void initState() {
    super.initState();

    tipo_pago = list_options.first;
    generar_factura = list_options_factura.first;
    fechaActual =
        DateTime(fechaActual.year, fechaActual.month, fechaActual.day, 0, 0, 0);
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
        title: Text('Registrar Cobro'),
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
                      child: Text('Tipo de Pago:'),
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
                                    value: tipo_pago,
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
                                        tipo_pago = value!;
                                        if (value == 'CHEQUE') {
                                          is_cheque = true;
                                        } else {
                                          is_cheque = false;
                                        }
                                      });
                                    },
                                    items: list_options
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Text(value),
                                              width: varWidth * 0.7,
                                            ),
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
                      child: Text('Factura:'),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            //color: Color.fromARGB(255, 233, 229, 229),
                            child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: SizedBox(
                                    width: varWidth,
                                    child: SearchableDropdown<int>(
                                      hintText: const Text('Lista de Facturas'),
                                      margin: const EdgeInsets.all(15),
                                      items: List.generate(
                                          global.listaDocumentos.length,
                                          (i) => SearchableDropdownMenuItem(
                                              value: int.parse(global
                                                  .listaDocumentos[i].codigo),
                                              label: global.listaDocumentos[i]
                                                      .numero_documento +
                                                  ' ' +
                                                  global.listaDocumentos[i]
                                                      .nombre_cliente +
                                                  ' ' +
                                                  global.listaDocumentos[i]
                                                      .estado_servicio +
                                                  ' Cod. ' +
                                                  global.listaDocumentos[i]
                                                      .codigo_servicio +
                                                  ' Valor: \$' +
                                                  global.listaDocumentos[i]
                                                      .saldo_documento
                                                      .toString() +
                                                  ' Fecha: ' +
                                                  '${global.listaDocumentos[i].fecha_documento}',
                                              child: Container(
                                                width: varWidth * 0.7,
                                                child: Text(global
                                                        .listaDocumentos[i]
                                                        .numero_documento +
                                                    ' ' +
                                                    global.listaDocumentos[i]
                                                        .nombre_cliente +
                                                    ' ' +
                                                    global.listaDocumentos[i]
                                                        .estado_servicio +
                                                    ' Cod. ' +
                                                    global.listaDocumentos[i]
                                                        .codigo_servicio +
                                                    ' Valor: \$' +
                                                    global.listaDocumentos[i]
                                                        .saldo_documento
                                                        .toString() +
                                                    ' Fecha: ' +
                                                    '${global.listaDocumentos[i].fecha_documento}'),
                                              ))),
                                      onChanged: (int? value) {
                                        debugPrint('$value');
                                        setState(() {
                                          documentoValue = value.toString();
                                          List<DatosDocumentos> datos = global
                                              .listaDocumentos
                                              .where((documento) =>
                                                  documento.codigo ==
                                                  value.toString())
                                              .toList();

                                          print(datos);
                                          estadoServicio =
                                              datos[0].estado_servicio;
                                          id_cliente = datos[0].id_cliente;
                                          id_servicio = datos[0].id_servicio;
                                          valor.text = datos[0]
                                              .saldo_documento
                                              .toString();
                                          valorPdf = datos[0]
                                              .saldo_documento
                                              .toString();

                                          if (datos[0].estado_servicio ==
                                              'CORTADO POR IMPAGO') {
                                            setState(() {
                                              is_cortado_impago = true;
                                            });
                                          } else {
                                            setState(() {
                                              is_cortado_impago = false;
                                            });
                                          }
                                        });
                                      },
                                    )))))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                        visible: is_cortado_impago,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Generar Factura:'),
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
                                            value: generar_factura,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    195, 56, 56, 56),
                                                fontSize: 14),
                                            underline: Container(
                                              height: 0,
                                            ),
                                            onChanged: (String? value) {
                                              // This is called when the user selects an item.
                                              setState(() {
                                                generar_factura = value!;
                                              });
                                            },
                                            items: list_options_factura
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      child: Text(value),
                                                      width: varWidth * 0.7,
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ))))
                              ],
                            ),
                          ],
                        )),
                    Visibility(
                        visible: is_cheque,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Banco:'),
                            ),
                            Column(
                              children: <Widget>[
                                sombra(Card(
                                    //color: Color.fromARGB(255, 233, 229, 229),
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            width: varWidth,
                                            child: SearchableDropdown<int>(
                                              hintText:
                                                  const Text('Lista de Bancos'),
                                              margin: const EdgeInsets.all(15),
                                              items: List.generate(
                                                  global.listaBancos.length,
                                                  (i) =>
                                                      SearchableDropdownMenuItem(
                                                          value: int.parse(
                                                              global
                                                                  .listaBancos[
                                                                      i]
                                                                  .codigo),
                                                          label: global
                                                                  .listaBancos[
                                                                      i]
                                                                  .nombre +
                                                              ' ' +
                                                              global
                                                                  .listaBancos[
                                                                      i]
                                                                  .numero_cuenta,
                                                          child: Container(
                                                            width:
                                                                varWidth * 0.7,
                                                            child: Text(global
                                                                    .listaBancos[
                                                                        i]
                                                                    .nombre +
                                                                ' - ' +
                                                                global
                                                                    .listaBancos[
                                                                        i]
                                                                    .numero_cuenta),
                                                          ))),
                                              onChanged: (int? value) {
                                                debugPrint('$value');
                                                setState(() {
                                                  bancosValue =
                                                      value.toString();
                                                });
                                              },
                                            )))))
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Fecha Cheque:'),
                            ),
                            Column(
                              children: <Widget>[
                                sombra(Card(
                                    //color: Color.fromARGB(255, 233, 229, 229),
                                    child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            width: varWidth,
                                            child: TextField(
                                                controller:
                                                    fecha_cheque, //editing controller of this TextField
                                                decoration:
                                                    const InputDecoration(
                                                        icon: Icon(Icons
                                                            .calendar_today), //icon of text field
                                                        labelText:
                                                            "Fecha" //label text of field
                                                        ),
                                                readOnly:
                                                    true, // when true user cannot edit text
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                      await showDatePicker(
                                                          context: context,
                                                          initialDate: DateTime
                                                              .now(), //get today's date
                                                          firstDate: DateTime(
                                                              2000), //DateTime.now() - not to allow to choose before today.
                                                          lastDate:
                                                              DateTime(2101));
                                                  if (pickedDate != null) {
                                                    print(
                                                        pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(
                                                                pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                                    print(
                                                        formattedDate); //formatted date output using intl package =>  2022-07-04
                                                    //You can format date as per your need

                                                    setState(() {
                                                      fecha_cheque.text =
                                                          formattedDate; //set foratted date to TextField value.
                                                    });
                                                  }
                                                }))))),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Número Cheque:'),
                            ),
                            Column(
                              children: <Widget>[
                                sombra(Card(
                                    child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: TextField(
                                    maxLength: 9,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      global.detalleSoluSoporte =
                                          value.toString();
                                    },
                                    controller: numero_cheque,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "# 0000"),
                                  ),
                                )))
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Valor Cobrado:'),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            child: Padding(
                          padding: EdgeInsets.all(20),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              global.detalleSoluSoporte = value.toString();
                            },
                            controller: valor,
                            decoration:
                                InputDecoration.collapsed(hintText: "\$ 0.00"),
                          ),
                        )))
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
                                      ProgressDialog progressDialog =
                                          ProgressDialog(context);
                                      progressDialog.show();

                                      print(fecha_cheque.text);
                                      print('Pos aca2');
                                      print(fechaActual.toString());
                                      if (fecha_cheque.text.isNotEmpty) {
                                        fechaIngresada =
                                            DateTime.parse(fecha_cheque.text);
                                      }

                                      if (documentoValue == '') {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Seleccione la Factura a Cobrar');
                                      } else if (is_cortado_impago == true &&
                                          generar_factura == 'SELECCIONAR') {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Seleccionar el tipo de factura a generar');
                                      } else if (is_cheque == true &&
                                          bancosValue == '') {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Seleccionar el banco al que se depositara el cheque');
                                      } else if (is_cheque == true &&
                                          (fecha_cheque.text == '' ||
                                              fechaIngresada
                                                  .isBefore(fechaActual))) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Ingrese una fecha de cheque valida');
                                      } else if (is_cheque == true &&
                                          numero_cheque.text == '') {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Ingrese un número de cheque valido');
                                      } else if (valor.text == '' ||
                                          double.parse(valor.text) <= 0) {
                                        progressDialog.dismiss();
                                        mostrarError(
                                            context, 'Ingrese un valor valido');
                                      } else if (observacionController.text ==
                                          '') {
                                        progressDialog.dismiss();
                                        mostrarError(
                                            context, 'Ingrese una observación');
                                      } else {
                                        setState(() {
                                          buttonEnabled = false;
                                        });
                                        await FinalizarCobro(
                                                Preferences.usrID,
                                                estadoServicio,
                                                generar_factura,
                                                fechaActual.toString(),
                                                id_cliente,
                                                id_servicio,
                                                int.parse(documentoValue),
                                                tipo_pago,
                                                double.parse(valor.text),
                                                observacionController.text,
                                                fechaActual.toString(),
                                                numero_cheque.text,
                                                bancosValue)
                                            .then((_) {
                                          finalizarCobro.then((value) {
                                            print(value.toString());
                                            if (value['success'] == 'OK') {
                                              setState(() {
                                                global.itemsPDF.add(
                                                    Productos_PDF(
                                                        nombre: generar_factura,
                                                        cant: 1,
                                                        desc: 0,
                                                        precio: double.parse(
                                                                valorPdf)
                                                            .toStringAsFixed(
                                                                2)));
                                                global.valorCobrado =
                                                    double.parse(valor.text);
                                                global.listaBancos.clear();
                                                global.listaDocumentos.clear();
                                                bancosValue = '';
                                                documentoValue = '';
                                                estadoServicio = '';
                                                generar_factura = '';
                                                id_cliente = 0;
                                                id_servicio = 0;
                                                documentoValue = '';
                                                tipo_pago = '';
                                                valor.text = '';
                                                fecha_cheque.text = '';
                                                numero_cheque.text = '';

                                                observacionController.text = '';
                                              });

                                              print(value);

                                              progressDialog.dismiss();
                                              Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const PDFScreenCobro()),
                                                      (Route<dynamic> route) =>
                                                          false);

                                              /* Navigator.of(context)
                                                  .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ActionScreens(
                                                                  message: value[
                                                                      'mensaje'],
                                                                  type:
                                                                      'SUCCESS')),
                                                      (Route<dynamic> route) =>
                                                          false); */
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
                                              /*  Navigator.of(
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
                                  height: varHeight * 0.08,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorFondo.BTNUBI),
                                  child: Center(
                                    child: Text(
                                      'Registrar Cobro'.toUpperCase(),
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

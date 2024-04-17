import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:powernet/app/models/crm/CRM_Products.dart';
import 'package:powernet/app/pages/public/recursos/recursos.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import '../../../../api/internas/public/insert/crm/api_registrar_prospecto.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../actionScreens/action_screens.dart';
import '/app/models/var_global.dart' as global;

class RegistrarProspecto extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => RegistrarProspecto(),
    );
  }

  @override
  _RegistrarProspectoState createState() => _RegistrarProspectoState();
}

class _RegistrarProspectoState extends State<RegistrarProspecto> {
  //TEXT CONTROLLERS
  final client_name = TextEditingController();
  final client_phone = TextEditingController();
  final oportunity_name = TextEditingController();
  final oportunity_description = TextEditingController();

  bool buttonEnabled = true;
  final _formKey = GlobalKey<FormState>();

  int product_id = 0;
  String product_price = '0.0';
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
        title: Text('Registrar Prospecto',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          // tooltip: 'Regresar',
        ),
        backgroundColor: ColorFondo.PRIMARY,
      ),
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
                      child: Text('Nombre de la Oportunidad:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: oportunity_name,
                            maxLength: 60,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Ingrese el nombre de la oportunidad',
                            ),
                          ),
                        )))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Nombre del Cliente:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            controller: client_name,
                            maxLength: 60,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Ingrese el nombre del cliente',
                            ),
                          ),
                        )))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Teléfono del Cliente:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            controller: client_phone,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: 'Ingrese el número de teléfono',
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        )))
                      ],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Producto:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                          Column(
                            children: <Widget>[
                              sombra(Card(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          width: varWidth,
                                          child: SearchableDropdown<int>(
                                            hintText: const Text(
                                                'Lista de Productos'),
                                            margin: const EdgeInsets.all(15),
                                            items: List.generate(
                                                global.crmProductsList.length,
                                                (i) =>
                                                    SearchableDropdownMenuItem(
                                                        value: int.parse(global
                                                            .crmProductsList[i]
                                                            .code),
                                                        label: global
                                                                .crmProductsList[
                                                                    i]
                                                                .name +
                                                            ' - \$ ' +
                                                            global
                                                                .crmProductsList[
                                                                    i]
                                                                .price,
                                                        child: Container(
                                                          width: varWidth * 0.7,
                                                          child: Text(global
                                                                  .crmProductsList[
                                                                      i]
                                                                  .name +
                                                              ' - \$ ' +
                                                              global
                                                                  .crmProductsList[
                                                                      i]
                                                                  .price),
                                                        ))),
                                            onChanged: (int? value) {
                                              debugPrint('$value');
                                              setState(() {
                                                product_id = value!;

                                                List<CRMProducts> datos = global
                                                    .crmProductsList
                                                    .where((products) =>
                                                        products.code ==
                                                        value.toString())
                                                    .toList();

                                                print(datos);
                                                product_price = datos[0].price;
                                              });
                                            },
                                          )))))
                            ],
                          ),
                        ]),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Descripción:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: TextField(
                            maxLines: 8,
                            keyboardType: TextInputType.text,
                            controller: oportunity_description,
                            maxLength: 200,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText:
                                  'Ingrese la descripción de la oportunidad',
                            ),
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
                                      ProgressDialog progressDialog =
                                          ProgressDialog(context);
                                      progressDialog.show();
                                      if (oportunity_name.text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Campo Nombre de la Oportunidad Vacio');
                                      } else if (client_name.text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Campo Nombre del Cliente Vacio');
                                      } else if (client_phone.text.length <
                                              10 ||
                                          client_phone.text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Coloque un numero de teléfono valido');
                                      } else if (product_id == 0 ||
                                          product_price == '') {
                                        progressDialog.dismiss();
                                        mostrarError(
                                            context, 'Seleccione un producto');
                                      } else if (oportunity_description
                                          .text.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(context,
                                            'Ingrese la descripción de la oportunidad');
                                      } else {
                                        setState(() {
                                          buttonEnabled = false;
                                        });
                                        await RegisterProspect(
                                          oportunity_name.text,
                                          client_name.text,
                                          client_phone.text.toString(),
                                          product_id.toString(),
                                          product_price.toString(),
                                          oportunity_description.text,
                                        ).then((_) {
                                          registerProspect.then((value) {
                                            print(value.toString());
                                            if (value['success'] == 'OK') {
                                              setState(() {
                                                global.crmProductsList.clear();
                                                oportunity_name.text = '';
                                                client_name.text = '';
                                                client_phone.text = '';
                                                product_id = 0;
                                                product_price = '';
                                                oportunity_description.text =
                                                    '';
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
                                  height: varHeight * 0.08,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: ColorFondo.BTNUBI),
                                  child: Center(
                                    child: Text(
                                      'Registrar Prospecto'.toUpperCase(),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:powernet/app/clases/cConfig_UI.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico_Traslado.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../recursos/recursos.dart';
import '/app/models/var_global.dart' as global;

class ContactosTraslados extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ContactosTraslados(),
    );
  }

  @override
  _ContactosTrasladosState createState() => _ContactosTrasladosState();
}

class _ContactosTrasladosState extends State<ContactosTraslados> {
  var suma = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: varWidth,
        height: varHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: sombra(
                Container(
                  decoration: BoxDecoration(
                    color: ColorFondo.BTNUBI,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: varWidth * 2,
                  //height: varHeight * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ContactosTraslados',
                              style: TextStyle(
                                  color: ColorFondo.BLANCO,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      ProcesoEspecificoTraslado.route());
                                },
                                child: SvgPicture.asset(
                                    'assets/icons/XMARK_white.svg'))
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorFondo.BLANCO,
                                      width: 2,
                                    ),
                                  ),
                                  width: varWidth / 2.5,
                                  height: varHeight * 0.07,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text(
                                              global.celular1_DetTraslados,
                                              style: TextStyle(
                                                  color: ColorFondo.BLANCO,
                                                  fontSize: 16))),
                                    ],
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorFondo.BLANCO,
                                        width: 2,
                                      ),
                                    ),
                                    width: varWidth / 2.5,
                                    height: varHeight * 0.07,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              launch(
                                                  'tel://${global.celular1_DetTraslados}');
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/tel_white.svg',
                                              width: 25,
                                            )),
                                        GestureDetector(
                                            onTap: () async {
                                              await launch(
                                                  "https://wa.me/${global.celular1_DetTraslados}?text=Hola");
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/whatsApp_white.svg',
                                              width: 30,
                                            ))
                                      ],
                                    )),
                              ],
                            ),
                            Visibility(
                              visible: global.celular2_DetTraslados == ''||global.celular2_DetTraslados == '+593'
                                  ? false
                                  : true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorFondo.BLANCO,
                                        width: 2,
                                      ),
                                    ),
                                    width: varWidth / 2.5,
                                    height: varHeight * 0.07,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Text(
                                                global.celular2_DetTraslados,
                                                style: TextStyle(
                                                    color: ColorFondo.BLANCO,
                                                    fontSize: 16))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorFondo.BLANCO,
                                          width: 2,
                                        ),
                                      ),
                                      width: varWidth / 2.5,
                                      height: varHeight * 0.07,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                launch(
                                                    'tel://${global.celular2_DetTraslados}');
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/tel_white.svg',
                                                width: 25,
                                              )),
                                          GestureDetector(
                                              onTap: () async {
                                                await launch(
                                                    "https://wa.me/${global.celular2_DetTraslados}?text=Hola");
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/whatsApp_white.svg',
                                                width: 30,
                                              ))
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: global.celular3_DetTraslados == ''||global.celular3_DetTraslados == '+593'
                                  ? false
                                  : true,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorFondo.BLANCO,
                                        width: 2,
                                      ),
                                    ),
                                    width: varWidth / 2.5,
                                    height: varHeight * 0.07,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Text(
                                                global.celular3_DetTraslados,
                                                style: TextStyle(
                                                    color: ColorFondo.BLANCO,
                                                    fontSize: 16))),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: ColorFondo.BLANCO,
                                          width: 2,
                                        ),
                                      ),
                                      width: varWidth / 2.5,
                                      height: varHeight * 0.07,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                launch(
                                                    'tel://${global.celular3_DetTraslados}');
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/tel_white.svg',
                                                width: 25,
                                              )),
                                          GestureDetector(
                                              onTap: () async {
                                                await launch(
                                                    "https://wa.me/${global.celular3_DetTraslados}?text=Hola");
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/whatsApp_white.svg',
                                                width: 30,
                                              ))
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: global.celular_DetTraslados == ''
                                  ? false
                                  : true,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Contacto Adicional',
                                        style: TextStyle(
                                            color: ColorFondo.BLANCO,
                                            fontSize: 16)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: ColorFondo.BLANCO,
                                            width: 2,
                                          ),
                                        ),
                                        width: varWidth / 2.5,
                                        height: varHeight * 0.07,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                                child: Text(
                                                    global.celular_DetTraslados,
                                                    style: TextStyle(
                                                        color:
                                                            ColorFondo.BLANCO,
                                                        fontSize: 16))),
                                          ],
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ColorFondo.BLANCO,
                                              width: 2,
                                            ),
                                          ),
                                          width: varWidth / 2.5,
                                          height: varHeight * 0.07,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    launch(
                                                        'tel://${global.celular_DetTraslados}');
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/tel_white.svg',
                                                    width: 25,
                                                  )),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await launch(
                                                        "https://wa.me/${global.celular_DetTraslados}?text=Hola");
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/whatsApp_white.svg',
                                                    width: 30,
                                                  ))
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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

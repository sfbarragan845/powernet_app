import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../recursos/recursos.dart';
import '../screens/proceso_especifico.dart';
import '/app/models/var_global.dart' as global;

class Contactos extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => Contactos(),
    );
  }

  @override
  _ContactosState createState() => _ContactosState();
}

class _ContactosState extends State<Contactos> {
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
                              'Contactos',
                              style: TextStyle(
                                  color: ColorFondo.BLANCO,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      ProcesoEspecificoIncidente.route());
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
                                        global.celular1_DetSoporte,
                                        style: TextStyle(
                                            color: ColorFondo.BLANCO,
                                            fontSize: 16),
                                      )),
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
                                              launchUrl((Uri.parse(
                                                  'tel://${global.celular1_DetSoporte}')));
                                            },
                                            child: SvgPicture.asset(
                                              'assets/images/tel_white.svg',
                                              width: 25,
                                            )),
                                        GestureDetector(
                                            onTap: () async {
                                              await launch(
                                                  "https://wa.me/${global.celular1_DetSoporte}?text=Hola");
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
                              visible: global.celular2_DetSoporte == '' ||
                                      global.celular2_DetSoporte == '+593'
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
                                                global.celular2_DetSoporte,
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
                                                launchUrl((Uri.parse(
                                                    'tel://${global.celular2_DetSoporte}')));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/tel_white.svg',
                                                width: 25,
                                              )),
                                          GestureDetector(
                                              onTap: () async {
                                                await launch(
                                                    "https://wa.me/${global.celular2_DetSoporte}?text=Hola");
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
                              visible: global.celular3_DetSoporte == '' ||
                                      global.celular3_DetSoporte == '+593'
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
                                                global.celular3_DetSoporte,
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
                                                launchUrl((Uri.parse(
                                                    'tel://${global.celular3_DetSoporte}')));
                                              },
                                              child: SvgPicture.asset(
                                                'assets/images/tel_white.svg',
                                                width: 25,
                                              )),
                                          GestureDetector(
                                              onTap: () async {
                                                await launch(
                                                    "https://wa.me/${global.celular3_DetSoporte}?text=Hola");
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
                              visible: global.celular_DetSoporte == ''
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
                                                    global.celular_DetSoporte,
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
                                                    launchUrl((Uri.parse(
                                                        'tel://${global.celular_DetSoporte}')));
                                                  },
                                                  child: SvgPicture.asset(
                                                    'assets/images/tel_white.svg',
                                                    width: 25,
                                                  )),
                                              GestureDetector(
                                                  onTap: () async {
                                                    await launch(
                                                        "https://wa.me/${global.celular_DetSoporte}?text=Hola");
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

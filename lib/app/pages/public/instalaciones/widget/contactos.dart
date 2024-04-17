import 'package:powernet/app/pages/public/registrarSolucion/screens/registrar_solucion.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '../screens/instalaciones.dart';
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

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      /* appBar: AppBar(
        title: Text('Contactos'),
        backgroundColor: ColorFondo.PRIMARY,
      ), */
      //drawer: const MenuPrincipal(),
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
                    //color: Color.fromARGB(221, 226, 226, 226), //light blue
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: varWidth * 2,
                  height: varHeight * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Contactos',
                              style: TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacement(Instalaciones.route());
                                },
                                child:
                                    SvgPicture.asset('assets/icons/XMARK.svg'))
                          ],
                        ),
                        SizedBox(height: 15,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
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
                                  width: varWidth / 2.5,
                                  height: varHeight * 0.07,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Text('099999999')),
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
                                  width: varWidth / 2.5,
                                  height: varHeight * 0.07,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          launch('tel://+593999999999');
                                        },
                                        child: SvgPicture.asset('assets/images/tel.svg',width: 25,)
                                        ),
                                      GestureDetector(
                                        onTap: () async {
                                          await launch("https://wa.me/+593999999999?text=Hola");
                                        },
                                        child: SvgPicture.asset('assets/images/whatsApp.svg',width: 30,)
                                        )
                                    ],
                                  )
                                ),
                              ],
                            ),
                            Row(
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
                              width: varWidth / 2.5,
                              height: varHeight * 0.07,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(child: Text('022222222')),
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
                              width: varWidth / 2.5,
                              height: varHeight * 0.07,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      launch('tel://+593999999999');
                                    },
                                    child: SvgPicture.asset('assets/images/convencional.svg',width: 25,)
                                    ),
                                  
                                ],
                              )
                            ),
                          ],
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

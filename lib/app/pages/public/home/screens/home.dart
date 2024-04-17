import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_instalaciones.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_migraciones.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_soportes.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_traslados.dart';
import 'package:powernet/app/pages/public/procesos/screens/proceso_especifico_Inst.dart';

import '../../../../api/internas/public/api_version_app.dart';
import '../../../../api/internas/public/select/api_listado_bancos.dart';
import '../../../../api/internas/public/select/api_listado_documentos.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cParametros.dart';
import '../../../../clases/cResponsive2.dart';
import '../../../../models/share_preferences.dart';
import '../../../../models/support/Datos_Soportes.dart';
import '../../../../models/var_global.dart' as globals;
import '../../../../pages/public/recursos/recursos.dart';
import '../../procesos/screens/proceso_especifico.dart';
import '../../procesos/screens/proceso_especifico_Migracion.dart';
import '../../procesos/screens/proceso_especifico_Ret.dart';
import '../../procesos/screens/proceso_especifico_Traslado.dart';
import '../../profile/screens/cerrarSesion.dart';
import '../../registrarCobro/screens/registrar_cobro.dart';
import '../../registrarSolucionActividad/screens/registrar_solucion_actividad.dart';
import '../../versionapp/version_app.dart';
import 'menu.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const HomeApp(),
    );
  }

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> with SingleTickerProviderStateMixin {
  /* late AnimationController controller;
  late Animation<double> animation; */
  late Future<dynamic> datosPuntos;
  List<Datos_Soportes> resolverHoy = [];
  List<Datos_Soportes> pendiente = [];
  bool selected = false;
  DateTime FechaActual = DateTime.now();

  bool _perfilTecnico = true;
  bool _administrador = true;

  @override
  initState() {
    super.initState();
    _init();
    Again();
  }

  Future<void> _init() async {
    if (mounted) {
      setState(() {
        if (Preferences.usrPerfil == 'RECAUDADOR/RETIROS') {
          _perfilTecnico = false;
        } else {
          _perfilTecnico = true;
        }

        if (Preferences.usrPerfil == "ADMINISTRADOR POWERNET") {
          _administrador = true;
        } else {
          _administrador = false;
        }
      });
    }

    //Este codigo se ejecuta cada 5 segundos
    await postVersion('Hola').then((_) {
      versionAPP.then((value) {
        if (value['success'] == 'OK') {
          print('aqui');

          print(globals.versionAPP);
        } else if (value['success'] == 'ERROR') {}
      });
    });
    if (globals.versionAPP == versionapp) {
      print(FechaActual.toString().substring(0, 10));

      if (mounted) {
        setState(() {
          selected = true;
        });
      }

      await listadoInstalaciones('').then((value) {
        if (mounted) {
          setState(() {
            globals.ListadoHomeInstalacion.clear();
            globals.ListadoHomeInstalacion.addAll(value);
          });
        }
      });
      await listadoSoportes('').then((value) {
        if (mounted) {
          setState(() {
            globals.ListadoHomeSoportes.clear();
            globals.ListadoHomeSoportes.addAll(value);
          });
        }
      });
      await listadoMigraciones('').then((value) {
        if (mounted) {
          setState(() {
            globals.ListadoHomeMigraciones.clear();
            globals.ListadoHomeMigraciones.addAll(value);
          });
        }
      });
      await listadoTraslados('').then((value) {
        if (mounted) {
          setState(() {
            globals.ListadoHomeTraslados.clear();
            globals.ListadoHomeTraslados.addAll(value);
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          Preferences.logout();

          Preferences.usrNombre = '';
          Preferences.logueado = false;
          Preferences.TipoOuthSesion = '';
        });
      }
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const VersionApp()),
          (Route<dynamic> route) => false);
    }
  }

  Future<void> initListas() async {
    await listadoBancos('').then((value) {
      setState(() {
        globals.listaBancos.clear();
      });
      setState(() {
        globals.listaBancos.addAll(value);
      });
    });

    await listadoDocumentos().then((value) {
      setState(() {
        globals.listaDocumentos.clear();
      });
      setState(() {
        globals.listaDocumentos.addAll(value);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RegistrarCobro()));
      });
    });
    print('aqui mis listas');
    print(globals.listaBancos.toList());
    print(globals.listaDocumentos.toList());
    print(globals.listaDocumentos.length);
  }

  void Again() {
    int i = 0;
    globals.miTimer /* Timer miTimer  */ =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      print('aqui vueltas ' + (i++).toString());
      //Este codigo se ejecuta cada 5 segundos
      await postVersion('Hola').then((_) {
        versionAPP.then((value) {
          if (value['success'] == 'OK') {
            print('aqui');

            print(globals.versionAPP);
          } else if (value['success'] == 'ERROR') {}
        });
      });
      if (globals.versionAPP == versionapp) {
        print(FechaActual.toString().substring(0, 10));

        //Future.delayed(const Duration(seconds: 2), () async {
        if (mounted) {
          setState(() {
            selected = true;
          });
        }
        //});

        await listadoInstalaciones('').then((value) {
          if (mounted) {
            setState(() {
              globals.ListadoHomeInstalacion.clear();
              globals.ListadoHomeInstalacion.addAll(value);
              //globals.cantInstalacion = globals.ListadoHomeInstalacion.length;
            });
          }
        });
        await listadoSoportes('').then((value) {
          if (mounted) {
            setState(() {
              globals.ListadoHomeSoportes.clear();
              globals.ListadoHomeSoportes.addAll(value);
              //globals.cantSoporte = globals.ListadoHomeSoportes.length;
            });
          }
        });
        await listadoMigraciones('').then((value) {
          if (mounted) {
            setState(() {
              globals.ListadoHomeMigraciones.clear();
              globals.ListadoHomeMigraciones.addAll(value);
            });
          }
        });
        await listadoTraslados('').then((value) {
          if (mounted) {
            setState(() {
              globals.ListadoHomeTraslados.clear();
              globals.ListadoHomeTraslados.addAll(value);
            });
          }
        });
      } else {
        if (mounted) {
          setState(() {
            Preferences.logout();

            Preferences.usrNombre = '';
            Preferences.logueado = false;
            Preferences.TipoOuthSesion = '';
          });
        }
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const VersionApp()),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  dispose() {
    // Es importante SIEMPRE realizar el dispose del controller.
    //controller.dispose();
    globals.miTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: ColorFondo.PRIMARY,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: const Text('Inicio', style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold),),
        backgroundColor: ColorFondo.PRIMARY,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      drawer: const MenuPrincipal(),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icons/home.png"),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Color.fromARGB(255, 207, 19, 19),
          ),
          width: vwidth,
          height: vheight * 0.9,
          child: Column(
            children: [
              Container(
                height: vheight * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hola,  ',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(Preferences.usrnickName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),

                width: vwidth,
                height: vheight * 0.7,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 30,
                    ),
                    Visibility(
                      visible: _perfilTecnico,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  globals.miTimer?.cancel();
                                  globals.ListadoSoportes.clear();
                                  setState(() {
                                    globals.tipoRequerimiento = 'Incidentes';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProcesoEspecificoIncidente()));
                                  });
                                },
                                child: sombra(Container(
                                  width: vwidth * 0.4,
                                  height: vheight * 0.2,
                                  decoration: BoxDecoration(
                                    //color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                      //topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Total de soporte'),
                                      SvgPicture.asset(
                                          'assets/images/totalsoporte.svg'),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorFondo.BTNUBI,
                                          //color: Colors.amber,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        width: vwidth,
                                        height: vheight * 0.05,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              globals.ListadoHomeSoportes.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //color: Colors.amber,
                                )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  globals.miTimer?.cancel();
                                  globals.ListadoInstalacion.clear();

                                  setState(() {
                                    globals.tipoRequerimiento = 'Instalaciones';

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProcesoEspecificoInstalacion()));
                                  });
                                },
                                child: sombra(Container(
                                  width: vwidth * 0.4,
                                  height: vheight * 0.2,
                                  decoration: BoxDecoration(
                                    //color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                      //topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Instalaciones'),
                                      SvgPicture.asset(
                                          'assets/images/instalaciones.svg'),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorFondo.BTNUBI,
                                          //color: Colors.amber,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        width: vwidth,
                                        height: vheight * 0.05,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              globals
                                                  .ListadoHomeInstalacion.length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //color: Colors.amber,
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  globals.miTimer?.cancel();
                                  globals.ListadoMigraciones.clear();
                                  setState(() {
                                    globals.tipoRequerimiento = 'Traslado';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProcesoEspecificoTraslado()));
                                  });
                                },
                                child: sombra(Container(
                                  width: vwidth * 0.4,
                                  height: vheight * 0.2,
                                  decoration: BoxDecoration(
                                    //color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                      //topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Traslados'),
                                      SvgPicture.asset(
                                          'assets/images/traslados.svg'),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorFondo.BTNUBI,
                                          //color: Colors.amber,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        width: vwidth,
                                        height: vheight * 0.05,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${globals.ListadoHomeTraslados.length}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //color: Colors.amber,
                                )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  globals.miTimer?.cancel();
                                  globals.ListadoMigraciones.clear();
                                  setState(() {
                                    globals.tipoRequerimiento = 'Migracion';
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProcesoEspecificoMigracion()));
                                  });
                                },
                                child: sombra(Container(
                                  width: vwidth * 0.4,
                                  height: vheight * 0.2,
                                  decoration: BoxDecoration(
                                    //color: Colors.amber,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                      //topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Migración'),
                                      SvgPicture.asset(
                                          'assets/images/migracion.svg'),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: ColorFondo.BTNUBI,
                                          //color: Colors.amber,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                        width: vwidth,
                                        height: vheight * 0.05,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${globals.ListadoHomeMigraciones.length}',
                                              //globals.cantInstalacion.toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  //color: Colors.amber,
                                )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                        visible: !_perfilTecnico,
                        child: Column(
                          children: [
                            //AQUI EMPECE
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    globals.miTimer?.cancel();
                                    globals.ListadoSoportes.clear();
                                    setState(() {
                                      globals.tipoRequerimiento = 'Retiros';
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProcesoEspecificoRetiros()));
                                    });
                                  },
                                  child: sombra(Container(
                                    width: vwidth * 0.4,
                                    height: vheight * 0.2,
                                    decoration: BoxDecoration(
                                      //color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                        //topRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Retiros'),
                                        SvgPicture.asset(
                                            'assets/images/totalsoporte.svg'),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ColorFondo.BTNUBI,
                                            //color: Colors.amber,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          width: vwidth,
                                          height: vheight * 0.05,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // Text(
                                              //   globals.cantSoporte.toString(),
                                              //   style: TextStyle(
                                              //       fontSize: 20, color: Colors.white),
                                              // )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    //color: Colors.amber,
                                  )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    globals.miTimer?.cancel();
                                    globals.ListadoInstalacion.clear();
                                    setState(() {
                                      globals.tipoRequerimiento =
                                          'Actidades Varias';
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegistrarSolucionActividad()));
                                    });
                                  },
                                  child: sombra(Container(
                                    width: vwidth * 0.4,
                                    height: vheight * 0.2,
                                    decoration: BoxDecoration(
                                      //color: Colors.amber,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                        //topRight: Radius.circular(50),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Actividades Varias'),
                                        SvgPicture.asset(
                                            'assets/images/instalaciones.svg'),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: ColorFondo.BTNUBI,
                                            //color: Colors.amber,
                                            borderRadius: BorderRadius.only(
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                            ),
                                          ),
                                          width: vwidth,
                                          height: vheight * 0.05,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [],
                                          ),
                                        )
                                      ],
                                    ),
                                    //color: Colors.amber,
                                  )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      globals.miTimer?.cancel();
                                      globals.ListadoInstalacion.clear();
                                      setState(() {
                                        globals.tipoRequerimiento = 'Cobros';

                                        initListas();
                                      });
                                    },
                                    child: sombra(Container(
                                      width: vwidth * 0.4,
                                      height: vheight * 0.2,
                                      decoration: BoxDecoration(
                                        //color: Colors.amber,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                          //topRight: Radius.circular(50),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Cobros'),
                                          SvgPicture.asset(
                                              'assets/images/pendiente.svg'),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: ColorFondo.BTNUBI,
                                              //color: Colors.amber,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            width: vwidth,
                                            height: vheight * 0.05,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [],
                                            ),
                                          )
                                        ],
                                      ),
                                      //color: Colors.amber,
                                    )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      globals.miTimer?.cancel();
                                      globals.ListadoInstalacion.clear();
                                      setState(() {
                                        globals.tipoRequerimiento =
                                            'Actidades Varias';
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    CerrarSesion()));
                                      });
                                    },
                                    child: sombra(Container(
                                      width: vwidth * 0.4,
                                      height: vheight * 0.2,
                                      decoration: BoxDecoration(
                                        //color: Colors.amber,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                          //topRight: Radius.circular(50),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Cerrar Sesión'),
                                          SvgPicture.asset(
                                              'assets/images/salidalab.svg'),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: ColorFondo.BTNUBI,
                                              //color: Colors.amber,
                                              borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                              ),
                                            ),
                                            width: vwidth,
                                            height: vheight * 0.05,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [],
                                            ),
                                          )
                                        ],
                                      ),
                                      //color: Colors.amber,
                                    )),
                                  ),
                                ]),
                          ],
                        )),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Lottie.asset(
                            'assets/animation/poweranimate.json',
                            width: 180,
                            height: 100),
                      ),
                    ]),
                  ]),
                ),
                // color: Colors.blueAccent,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget ventanaFlotante(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Visibility(
      visible: globals.ventana,
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
              top: Responsive.isMobile_pequenio(context)
                  ? vheight / 5.4
                  : Responsive.isMobile_mediano(context)
                      ? vheight / 13
                      : Responsive.isMobile_grande(context)
                          ? 0
                          : Responsive.isMobile_extragrande(context)
                              ? 0
                              : Responsive.isMobile_extragrande2(context)
                                  ? 0
                                  : Responsive.isMobile_extragrande3(context)
                                      ? 0
                                      : Responsive.isTablet_pequenio(context)
                                          ? 0
                                          : Responsive.isTablet_mediano(context)
                                              ? 0
                                              : Responsive.isTablet_grande(
                                                      context)
                                                  ? 0
                                                  : Responsive.isDesktop(
                                                          context)
                                                      ? 0
                                                      : 0,
              bottom: 0,
              left: Responsive.isMobile_pequenio(context)
                  ? 0
                  : Responsive.isMobile_mediano(context)
                      ? 0
                      : Responsive.isMobile_grande(context)
                          ? MediaQuery.of(context).size.width / 8
                          : Responsive.isMobile_extragrande(context)
                              ? MediaQuery.of(context).size.width / 8
                              : Responsive.isMobile_extragrande2(context)
                                  ? MediaQuery.of(context).size.width / 8
                                  : Responsive.isMobile_extragrande3(context)
                                      ? MediaQuery.of(context).size.width / 8
                                      : Responsive.isTablet_pequenio(context)
                                          ? MediaQuery.of(context).size.width /
                                              8
                                          : Responsive.isTablet_mediano(context)
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8
                                              : Responsive.isTablet_grande(
                                                      context)
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      8
                                                  : Responsive.isDesktop(
                                                          context)
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          8
                                                      : MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          8,
              right: Responsive.isMobile_pequenio(context)
                  ? 60
                  : Responsive.isMobile_mediano(context)
                      ? 60
                      : Responsive.isMobile_grande(context)
                          ? 40
                          : Responsive.isMobile_extragrande(context)
                              ? 40
                              : Responsive.isMobile_extragrande2(context)
                                  ? 40
                                  : Responsive.isMobile_extragrande3(context)
                                      ? 40
                                      : Responsive.isTablet_pequenio(context)
                                          ? 40
                                          : Responsive.isTablet_mediano(context)
                                              ? 40
                                              : Responsive.isTablet_grande(
                                                      context)
                                                  ? 40
                                                  : Responsive.isDesktop(
                                                          context)
                                                      ? 40
                                                      : 40),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color.fromARGB(113, 80, 80, 80)),
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            duration: Duration(seconds: 1),
            curve: Curves.linearToEaseOut,
            margin: selected
                ? EdgeInsets.only(left: 0)
                : EdgeInsets.only(left: 160),
            width: selected ? 220.0 : 0,
            child: Column(
              children: [
                Row(
                  children: [
                    TextButton(
                      child: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      ),
                      style:
                          ElevatedButton.styleFrom(alignment: Alignment.center),
                      onPressed: () {
                        setState(() {
                          globals.ventana = false;
                        });
                      },
                    ),
                    Text('¿Te podemos ayudar?')
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

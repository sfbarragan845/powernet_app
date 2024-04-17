// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:powernet/app/pages/public/asistencia/screens/ingreso_km.dart';
import 'package:powernet/app/pages/public/home/screens/home.dart';
import 'package:powernet/app/pages/public/productos/screens/listado_productos.dart';
import 'package:powernet/app/pages/public/registrarProspecto/screens/registrar_prospecto.dart';
import 'package:powernet/app/pages/public/speedtest/screens/speedtest.dart';

import '../../../../api/internas/public/api_marcadores.dart';
import '../../../../api/internas/public/select/api_listado_crm_productos.dart';
import '../../../../api/internas/public/select/api_listado_tecnico.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cParametros.dart';
import '../../../../models/share_preferences.dart';
import '../../../../models/statistic/tecnico_model.dart';
import '../../../../models/var_global.dart' as global;
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../estadistica/screens/estadistica_screens.dart';
import '../../profile/screens/cerrarSesion.dart';
import '../widgets/map_markerts.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({Key? key}) : super(key: key);

  @override
  State<MenuPrincipal> createState() => _MenuPrincipal();
}

class _MenuPrincipal extends State<MenuPrincipal>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Future<dynamic> datosPuntos;
  String texto = "Your text to display below image";
  bool _perfilTecnico = true;
  bool _administrador = false;

  @override
  void initState() {
    super.initState();
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
  }

  Future<void> initCRMProducts() async {
    await ProductsCRMList().then((value) {
      setState(() {
        global.crmProductsList.clear();
      });
      setState(() {
        global.crmProductsList.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _drawerHeader(),
          _drawerItemIcon(
            icon: Icons.home,
            text: 'Inicio',
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomeApp()));
            },
          ),
          Visibility(
            visible: _perfilTecnico ? true : false,
            child: _drawerItem2(
              icon: 'assets/images/bodega.svg',
              text: 'Mi bodega',
              onTap: () {
                Navigator.of(context).push(ListadoProduct.route());
              },
            ),
          ),
          Visibility(
            visible: _perfilTecnico ? true : false,
            child: _drawerItem2(
              icon: 'assets/images/ingresoLab.svg',
              text: 'Ingreso/Salida Laboral',
              onTap: () async {
                var status = await Permission.location.status;
                if (status.isDenied) {
                  if (await Permission.location.request().isGranted) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => IngresoKm()));
                  } else {
                    if (await Permission.speech.isPermanentlyDenied) {
                      openAppSettings();
                    }
                    mostrarError(context, 'No hay acceso a la ubicación.');
                  }
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => IngresoKm()));
                }
              },
            ),
          ),
          Visibility(
            visible: _perfilTecnico ? true : false,
            child: _drawerItemIcon(
              icon: Icons.location_history,
              text: 'Mapa de rutas',
              onTap: () {
                ProgressDialog progressDialog = ProgressDialog(context);
                progressDialog.show();
                global.latitudMap.clear();
                global.longitudMap.clear();
                global.iteMap.clear();
                global.titleMap.clear();
                postMarkUbi().then((_) {
                  datosMarkUbi.then((value) async {
                    if (value['success'] == "OK") {
                      if (value.containsKey('data')) {
                        final valores = value['data'] as List<dynamic>;

                        print('aqui valores' + valores.toString());

                        for (var i = 0; i < valores.length; i++) {
                          global.latitudMap.add(valores[i]['latitud']);
                          global.longitudMap.add(valores[i]['longitud']);
                          global.iteMap.add(valores[i]['item'].toString());
                          global.titleMap.add(valores[i]['tipo']);
                          global.prioridadMap.add(valores[i]['prioridad']);

                          print('mis ubicacionessssss lat :' +
                              valores[i]['latitud']);
                          print('mis ubicacionessssss long :' +
                              valores[i]['longitud']);
                        }
                        var status = await Permission.location.status;
                        if (status.isDenied) {
                          if (await Permission.location.request().isGranted) {
                            progressDialog.dismiss();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MapPage()),
                            );
                          } else {
                            if (await Permission.speech.isPermanentlyDenied) {
                              openAppSettings();
                            }
                            progressDialog.dismiss();
                            mostrarError(
                                context, 'No hay acceso a la ubicación.');
                          }
                        } else {
                          progressDialog.dismiss();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapPage()),
                          );
                        }
                      } else {
                        progressDialog.dismiss();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapPage()),
                        );
                      }
                    } else {
                      progressDialog.dismiss();
                      mostrarError(
                          context, 'No Se Han Encontrado Procesos Asignados.');
                    }
                  });
                });
              },
            ),
          ),
          _drawerItemIcon(
              icon: Icons.people,
              text: 'Crear Prospecto',
              onTap: () async {
                await initCRMProducts();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrarProspecto()),
                );
              }),
          _drawerItem2(
              icon: 'assets/images/speedtest.svg',
              text: 'SpeedTest',
              onTap: () {
                Navigator.of(context).push(SpeedTest.route());
              },
            ),
          Visibility(
            visible: _administrador ? true : false,
            child: _drawerItemIcon(
              icon: Icons.bar_chart,
              text: 'Estadística',
              onTap: () async {
                ProgressDialog progressDialog = ProgressDialog(context);
                progressDialog.show();
                await listadoTecnico('').then((value) {
                  setState(() {
                    global.listTecnicos.clear();
                    TecnicoModel _tecnico = new TecnicoModel(
                        item: 0, codigo: '0', tecnicos: 'TODOS');
                    global.listTecnicos.add(_tecnico);

                    global.listTecnicos.addAll((value['data'] as List<dynamic>)
                        .map<TecnicoModel>(
                            (tec) => TecnicoModel.fromJson(tec)));
                  });
                });

                progressDialog.dismiss();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EstadisticaScreens()),
                );
              },
            ),
          ),
          _drawerItemIcon(
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CerrarSesion()));
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.white),
      arrowColor: ColorFondo.PRIMARY,
      accountName: Text(Preferences.usrNombre,
          style: TextStyle(color: Color.fromARGB(255, 133, 133, 133))),
      accountEmail: Text(Preferences.usrCorreo,
          style: TextStyle(color: Color.fromARGB(255, 133, 133, 133))),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: CircleAvatar(
          backgroundImage:
              NetworkImage('$ROOT$fotos_user${Preferences.usrFoto}'),
          radius: 45,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  List<String> items = [
    'Trivia',
    'Puntos Obtenidos',
    'Puntos Canjeados',
    'Canjear Puntos'
  ];

  Widget _drawerItem1(
      {required IconData icon, required GestureTapCallback onTap}) {
    String? selectedItem = 'Trivia';
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: SizedBox(
              width: 180,
              height: 65,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            width: 3, color: Colors.transparent))),
                value: selectedItem,
                items: items
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 16),
                        )))
                    .toList(),
                onChanged: (item) => setState(() => selectedItem = item),
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _drawerItem2(
      {required String icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: const TextStyle(
                  color: ColorLetra.SECONDARY,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _drawerItemIcon(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: const TextStyle(
                  color: ColorLetra.SECONDARY,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _drawerSubItem(
      {required String text, required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 65.0),
            child: Text(
              text,
              style: const TextStyle(color: ColorLetra.SECONDARY, fontSize: 16),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

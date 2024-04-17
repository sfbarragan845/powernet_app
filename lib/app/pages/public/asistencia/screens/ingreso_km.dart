import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:powernet/app/api/internas/public/api_salida_km.dart';

import '../../../../api/internas/public/insert/work entry-exit/api_ingreso_km.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../core/cInternet.dart';
import '../../../../models/share_kyc.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';

class IngresoKm extends StatefulWidget {
  const IngresoKm({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const IngresoKm(),
    );
  }

  @override
  _IngresoKmState createState() => _IngresoKmState();
}

class _IngresoKmState extends State<IngresoKm>
    with SingleTickerProviderStateMixin {
  //const RecuperarContrasena({Key? key}) : super(key: key);
  late AnimationController controller;
  late Animation<double> animation;
  late IngresoKm requestModel;
  final GlobalKey<FormState> _key = GlobalKey();
  // final ImagePicker _picker = ImagePicker();
  final cedulaTxt = TextEditingController();

  //late Future<dynamic> kycdata;
  @override
  initState() {
    super.initState();
/*
    if (Preferences.kycFotoAnverso.isNotEmpty) {
      setState(() {
        imagenAnverso = XFile(Preferences.kycFotoAnverso);
      });
    }
*/
    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  dispose() {
    // Es importante SIEMPRE realizar el dispose del controller.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ingreso / Salida Laboral',
              style: TextStyle(color: ColorFondo.BLANCO, fontWeight: FontWeight.bold)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color:Colors.white),
            onPressed: () => Navigator.pop(context),
            // tooltip: 'Regresar',
          ),
        ),
        body: registroForm());
  }

  Widget registroForm() {
    double varHeight = MediaQuery.of(context).size.height;
    return Form(
      key: _key,
      child: Column(
        children: <Widget>[
          Container(
            height: varHeight / 2,
            child: Image.asset('assets/images/ingreso_salida.jpeg'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              children: [
                // const SizedBox(height: 20), _docAnverso(),
                const SizedBox(height: 20),
                //_kilometraje(),
                const SizedBox(height: 20), _registrarEntrada(),

                const SizedBox(height: 20),
                //_kilometraje(),
                const SizedBox(height: 20), _registrarSalida()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _registrarEntrada() {
    return ElevatedButton(
      onPressed: () async {
        InternetServices internet = InternetServices();
        if (await internet.verificarConexion()) {
          if (validateAndSave()) {
            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.show();
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            print('AQUI POSITION');
            print(position);
            print(position.latitude);
            print(position.longitude);

            postRegistroEntrada(
                    position.latitude.toString(), position.longitude.toString())
                .then((_) {
              progressDialog.dismiss();
              registroEntrada.then((value) {
                print('Prueba API Pedidos');
                print(value);
                if (value['success'] == 'OK') {
                  AwesomeDialog(
                          dismissOnTouchOutside: false,
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          headerAnimationLoop: true,
                          title: value['mensaje'],
                          dialogBackgroundColor: Colors.white,
                          //desc: 'Debe finalizar la orden anterior, antes de iniciar una nueva',
                          // body: Container(),
                          btnOkOnPress: () {
                            setState(() {
                              PreferencesKYC.kycFotoAnverso = '';
                            });
                          },
                          //btnOkIcon: Icons.cancel,
                          btnOkText: 'Aceptar',
                          btnOkColor: ColorFondo.BTNUBI
                          //  btnOkColor: Colors.red,
                          )
                      .show();
                } else if (value['success'] == 'ERROR') {
                  AwesomeDialog(
                          dismissOnTouchOutside: false,
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          headerAnimationLoop: true,
                          title: value['mensaje'],
                          dialogBackgroundColor: Colors.white,
                          btnOkOnPress: () {},
                          btnOkText: 'Aceptar',
                          btnOkColor: ColorFondo.BTNUBI)
                      .show();
                }
              });
            });
          }
        } else {
          mostrarError(context, 'No hay conexión a internet');
        }
      },
      child: const Text('Registrar ida al almuerzo'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: ColorFondo.BTNUBI, // Color del texto del botón
        padding: EdgeInsets.symmetric(
            horizontal: 40, vertical: 20), // Espaciado interno del botón
        textStyle: TextStyle(fontSize: 18), // Estilo del texto del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Borde redondeado del botón
        ),
      ),
    );
  }

  Widget _registrarSalida() {
    return ElevatedButton(
      onPressed: () async {
        InternetServices internet = InternetServices();
        if (await internet.verificarConexion()) {
          if (validateAndSave()) {
            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.show();
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            print('AQUI POSITION');
            print(position);
            print(position.latitude);
            print(position.longitude);

            postRegistroSalida(
                    position.latitude.toString(), position.longitude.toString())
                .then((_) {
              progressDialog.dismiss();
              registroSalida.then((value) {
                print('Prueba API Pedidos');
                print(value);
                if (value['success'] == 'OK') {
                  AwesomeDialog(
                          dismissOnTouchOutside: false,
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.topSlide,
                          headerAnimationLoop: true,
                          title: value['mensaje'],
                          dialogBackgroundColor: Colors.white,
                          btnOkOnPress: () {
                            setState(() {
                              PreferencesKYC.kycFotoAnverso = '';
                            });
                          },
                          btnOkText: 'Aceptar',
                          btnOkColor: ColorFondo.BTNUBI)
                      .show();
                } else if (value['success'] == 'ERROR') {
                  AwesomeDialog(
                          dismissOnTouchOutside: false,
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.topSlide,
                          headerAnimationLoop: true,
                          title: value['mensaje'],
                          dialogBackgroundColor: Colors.white,
                          btnOkOnPress: () {},
                          btnOkText: 'Aceptar',
                          btnOkColor: ColorFondo.BTNUBI)
                      .show();
                }
              });
            });
          }
        } else {
          mostrarError(context, 'No hay conexión a internet');
        }
      },
      child: const Text('Registrar regreso del almuerzo'),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: ColorFondo.BTNUBI,
        padding: EdgeInsets.symmetric(
            horizontal: 40, vertical: 20), // Espaciado interno del botón
        textStyle: TextStyle(fontSize: 18), // Estilo del texto del botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Borde redondeado del botón
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _key.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

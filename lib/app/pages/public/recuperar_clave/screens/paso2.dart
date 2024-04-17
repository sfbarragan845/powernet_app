// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../api/internas/public/api_rc2.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cResponsive2.dart';
import '../../../../core/cInternet.dart';
import '../../../../pages/components/mostrar_snack.dart';
import '../../../../pages/components/progress.dart';
import '../../../../pages/public/recuperar_clave/screens/paso3.dart';

class RecuperarClave2 extends StatefulWidget {
  const RecuperarClave2({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const RecuperarClave2(),
    );
  }

  @override
  _RecuperarClave2State createState() => _RecuperarClave2State();
}

class _RecuperarClave2State extends State<RecuperarClave2> with SingleTickerProviderStateMixin {
  //const RecuperarContrasena({Key? key}) : super(key: key);
  late AnimationController controller;
  late Animation<double> animation;
  late RecuperarClave2 requestModel;
  final GlobalKey<FormState> _key = GlobalKey();

  final codigoTxt = TextEditingController();
  @override
  initState() {
    super.initState();
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
          title: const Text('Recuperar contraseña'),
          leading: IconButton(
            tooltip: 'Regresar',
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: recuperarClaveForm());
  }

  Widget recuperarClaveForm() {
    return Form(
      key: _key,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              padding:  EdgeInsets.symmetric(horizontal: Responsive.isMobile_pequenio(context)
                      ? 10
                      : Responsive.isMobile_mediano(context)
                          ? 50
                          : Responsive.isMobile_grande(context)
                              ? 50
                              : Responsive.isMobile_extragrande(context)
                                  ? 50
                                  : Responsive.isMobile_extragrande2(context)
                                      ? 50
                                      : Responsive.isMobile_extragrande3(
                                              context)
                                          ? 50
                                          : Responsive.isTablet_pequenio(
                                                  context)
                                              ? 50
                                              : Responsive.isTablet_mediano(
                                                      context)
                                                  ? 50
                                                  : Responsive.isTablet_grande(
                                                          context)
                                                      ? 50
                                                      : Responsive.isDesktop(
                                                              context)
                                                          ? 50
                                                          : 50),
              children: [
                Padding(padding: const EdgeInsets.all(4), child: SvgPicture.asset('assets/images/oring.svg', height: 250,)),
                const Center(
                  child: Text(
                    'Paso 2',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(children: [
                  Expanded(flex: 2, child: Divider(thickness: 0.0001, color: Theme.of(context).primaryColor)),
                  Expanded(flex: 7, child: Divider(thickness: 1, color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.0001, color: Theme.of(context).primaryColor)),
                ]),
                Center(
                  child: Text('Verificar código de seguridad',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: 210,
                      child: TextFormField(
                        controller: codigoTxt,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo es requerido";
                          }
                          return null;
                        },
                        // keyboardType: TextInputType.emailAddress,
                        maxLength: 6,
                        // autofocus: true,
                        // textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: 'Código de Seguridad',
                          // helperText: 'Ingrese un correo',
                          counterText: '',
                          //errorText: 'Ingrese un correo.',
                          /* icon: Icon(
                            Icons.email,
                            size: 32.0,
                            color: ColorFondo.PRIMARY,
                          ),*/
                          labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: ColorFondo.PRIMARY,
                            width: 1.0,
                          )),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: ColorFondo.PRIMARY,
                            width: 2.0,
                          )),
                        ),
                        // onSaved: (input) => requestModel.usuario = input!,
                        // onSaved: (val) => _correo = val,
                      ),
                    ),
                    Center(
                        child: IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: "El código de seguridad fue enviado a su correo registrado, se recomienda revisar la carpeta de spam.",
                            gravity: ToastGravity.CENTER,
                            backgroundColor: ColorFondo.BTNUBI,
                            toastLength: Toast.LENGTH_LONG,
                            textColor: Colors.black);
                      },
                      icon: Icon(Icons.info),
                      color: ColorFondo.PRIMARY,
                    ))
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      /*onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                      },*/
                      child: const Text("Volver", style: const TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        fixedSize: const Size(110, 40),
                        //shape: StadiumBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        InternetServices internet = InternetServices();
                        if (await internet.verificarConexion()) {
                          if (validateAndSave()) {
                            ProgressDialog progressDialog = ProgressDialog(context);
                            progressDialog.show();
                            setState(
                              () {
                                postRecuperarClaveP2(codigoTxt.text.toString()).then((_) {
                                  recuperarClavePaso2.then((value) {
                                    if (value['success'] == 'OK') {
                                      mostrarCorrecto(context, value['mensaje']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const RecuperarClave3()),
                                      );
                                    } else if (value['success'] == 'ERROR') {
                                      mostrarError(context, value['mensaje']);
                                    }
                                  });
                                  progressDialog.dismiss();
                                });
                              },
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Validar",
                        style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorFondo.PRIMARY,
                        fixedSize: const Size(110, 40),
                        //shape: StadiumBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ],
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

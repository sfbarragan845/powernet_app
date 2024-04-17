// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../api/internas/public/api_rc3.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../core/cInternet.dart';
import '../../../../core/cValidacion.dart';
import '../../../../pages/components/mostrar_snack.dart';
import '../../../../pages/components/progress.dart';
import '../../../public/login/screens/loginScreen.dart';

class RecuperarClave3 extends StatefulWidget {
  const RecuperarClave3({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const RecuperarClave3(),
    );
  }

  @override
  _RecuperarClave3State createState() => _RecuperarClave3State();
}

class _RecuperarClave3State extends State<RecuperarClave3> with SingleTickerProviderStateMixin {
  //const RecuperarContrasena({Key? key}) : super(key: key);
  late AnimationController controller;
  late Animation<double> animation;
  late RecuperarClave3 requestModel;
  final GlobalKey<FormState> _key = GlobalKey();

  bool _showPassword1 = false;
  bool _showPassword2 = false;

  TextEditingController claveanterior = TextEditingController();
  TextEditingController clavenueva = TextEditingController();

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

  void mostrarLogin() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
  }

  Widget recuperarClaveForm() {
    return Form(
      key: _key,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              children: [
                Padding(padding: const EdgeInsets.all(4), child: SvgPicture.asset('assets/images/oring.svg')),
                Center(
                  child: Text(
                    'Paso final',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(children: [
                  Expanded(flex: 2, child: Divider(thickness: 0.0001, color: Theme.of(context).primaryColor)),
                  Expanded(flex: 4, child: Divider(thickness: 1, color: Theme.of(context).primaryColor)),
                  Expanded(flex: 2, child: Divider(thickness: 0.0001, color: Theme.of(context).primaryColor)),
                ]),
                Center(
                  child: Text('Ingrese su nueva clave',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      )),
                ),
                SizedBox(
                  height: 10,
                ),

                // Contraseña nueva
                Row(
                  children: [
                    Container(
                      width: 270,
                      child: TextFormField(
                        controller: clavenueva,
                        style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo contraseña es requerido";
                          } else if (value.length < 5) {
                            return "Contraseña de 5 caracteres";
                          } else if (claveanterior.text == value) {
                            return "La nueva contraseña no debe ser la misma";
                          } else if (!validator.password(value)) {
                            return "El formato para contraseña no es correcto";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        // textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '∙∙∙∙∙∙∙∙∙∙',
                          labelText: 'Nueva Contraseña',
                          // errorText: 'Ingrese la contraseña',
                          counterText: '',
                          icon: Icon(
                            Icons.lock,
                            size: 32.0,
                            color: ColorFondo.PRIMARY,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword1 ? Icons.visibility : Icons.visibility_off,
                              color: _showPassword1 ? ColorFondo.BTNUBI : ColorFondo.BTNUBI.withOpacity(0.4),
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword1 = !_showPassword1;
                              });
                            },
                          ),

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
                        obscureText: !_showPassword1,
                      ),
                    ),
                    Center(
                        child: IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: "La constraseña debe contener por lo menos una letra mayúscula, un número y un carácter especial.",
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
                // Repetir clave nueva
                // Contraseña
                Row(
                  children: [
                    Container(
                      width: 270,
                      child: TextFormField(
                        style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo contraseña es requerido";
                          } else if (value.length < 5) {
                            return "Contraseña de 5 caracteres";
                          } else if (clavenueva.text != value) {
                            return "Las claves no coinciden";
                          } else if (!validator.password(value)) {
                            return "El formato para contraseña no es correcto";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        maxLength: 20,
                        // textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '∙∙∙∙∙∙∙∙∙∙',
                          labelText: 'Repetir nueva contraseña',
                          // errorText: 'Ingrese la contraseña',
                          counterText: '',
                          icon: Icon(
                            Icons.lock,
                            size: 32.0,
                            color: ColorFondo.PRIMARY,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword2 ? Icons.visibility : Icons.visibility_off,
                              color: _showPassword2 ? ColorFondo.BTNUBI : ColorFondo.BTNUBI.withOpacity(0.4),
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword2 = !_showPassword2;
                              });
                            },
                          ),

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
                        obscureText: !_showPassword2,
                      ),
                    ),
                    Center(
                        child: IconButton(
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: "La constraseña debe contener por lo menos una letra mayúscula, un número y un carácter especial.",
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

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => mostrarLogin(),
                      /*onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (Route<dynamic> route) => false);
                      },*/
                      child: Text("Cancelar", style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        fixedSize: Size(130, 40),
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
                                postRecuperarClaveP3(clavenueva.text.toString(), context).then((_) {
                                  recuperarClavePaso3.then((value) {
                                    if (value['success'] == 'OK') {
                                      AwesomeDialog(
                                              dismissOnTouchOutside: false,
                                              context: context,
                                              dialogType: DialogType.SUCCES,
                                              animType: AnimType.TOPSLIDE,
                                              headerAnimationLoop: true,
                                              title: value['mensaje'],
                                              dialogBackgroundColor: Colors.white,
                                              //  desc: 'Por favor, cambie e intente nuevamente.',
                                              btnOkOnPress: () {
                                                mostrarLogin();
                                              },
                                              //btnOkIcon: Icons.cancel,
                                              btnOkText: 'Aceptar',
                                              btnOkColor: Colors.green
                                              //  btnOkColor: Colors.red,
                                              )
                                          .show();
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
                      child: Text(
                        "Validar",
                        style: TextStyle(fontSize: 15, letterSpacing: 2.2, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorFondo.PRIMARY,
                        fixedSize: Size(130, 40),
                        //shape: StadiumBorder(),
                      ),
                    )
                  ],
                ),
                SizedBox(
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

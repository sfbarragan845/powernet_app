// ignore_for_file: unnecessary_this, prefer_const_constructors, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../api/internas/public/update/api_cambiarclave_final.dart';
import '../../../../clases/bloc/connection_status_cubit.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cResponsive2.dart';
import '../../../../core/cInternet.dart';
import '../../../../core/cValidacion.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../internet/widget/widget_sin_conexion.dart';

class CambiarClave extends StatefulWidget {
  const CambiarClave({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const CambiarClave(),
    );
  }

  @override
  _CambiarClaveState createState() => _CambiarClaveState();
}

class _CambiarClaveState extends State<CambiarClave>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final GlobalKey<FormState> _key = GlobalKey();

  bool _showPassword = false;
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
    return BlocProvider(
      create: (_) => ConnectionStatusCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cambiar contraseña'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: () => Navigator.pop(context),
            // tooltip: 'Regresar',
          ),
        ),
        body: BlocBuilder<ConnectionStatusCubit, ConnectionStatus>(
          builder: (_, state) {
            if (state == ConnectionStatus.online) {
              return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/icons/MarcaAgua.png"),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  child: cambiarclaveForm());
            } else {
              return widget_sinConexion();
            }
          },
        ),
      ),
    );
  }

  Widget cambiarclaveForm() {
    return Form(
      key: _key,
      child: Column(
        children: [
          //AppBar(title: 'Recuperar contraseña',),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isMobile_pequenio(context)
                      ? 10
                      : Responsive.isMobile_mediano(context)
                          ? 20
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
                Padding(
                    padding: const EdgeInsets.all(30),
                    child: SvgPicture.asset(
                      'assets/images/oring.svg',
                      height: 200,
                    )),
                TextFormField(
                  controller: claveanterior,
                  style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo contraseña es requerido";
                    } else if (value.length < 5) {
                      return "Contraseña de 5 caracteres";
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
                    labelText: 'Contraseña anterior',
                    counterText: '',
                    icon: const Icon(
                      Icons.lock_reset_outlined,
                      size: 42.0,
                      color: ColorFondo.BTNUBI,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: this._showPassword
                            ? ColorFondo.BTNUBI
                            : ColorFondo.BTNUBI.withOpacity(0.4),
                      ),
                      onPressed: () {
                        setState(() {
                          this._showPassword = !this._showPassword;
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
                  obscureText: !this._showPassword,
                ),
                // Contraseña nueva
                TextFormField(
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
                      Icons.lock_reset_outlined,
                      size: 42.0,
                      color: ColorFondo.BTNUBI,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        this._showPassword1
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: this._showPassword1
                            ? ColorFondo.BTNUBI
                            : ColorFondo.BTNUBI.withOpacity(0.4),
                      ),
                      onPressed: () {
                        setState(() {
                          this._showPassword1 = !this._showPassword1;
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
                  obscureText: !this._showPassword1,
                ),
                // Repetir clave nueva
                // Contraseña
                TextFormField(
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
                      Icons.lock_reset_outlined,
                      size: 42.0,
                      color: ColorFondo.BTNUBI,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: _showPassword2
                            ? ColorFondo.BTNUBI
                            : ColorFondo.BTNUBI.withOpacity(0.4),
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

                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    InternetServices internet = InternetServices();
                    if (await internet.verificarConexion()) {
                      if (validateAndSave()) {
                        ProgressDialog progressDialog = ProgressDialog(context);
                        progressDialog.show();
                        setState(() {
                          postCambiarClave(claveanterior.text.toString(),
                                  clavenueva.text.toString())
                              .then((_) {
                            cambiarClave.then((value) {
                              if (value['success'] == 'OK') {
                                mostrarCorrecto(context, value['mensaje']);
                              } else if (value['success'] == 'ERROR') {
                                mostrarError(context, value['mensaje']);
                              }
                            });
                            progressDialog.dismiss();
                          });
                        });
                      }
                    } else {
                      mostrarError(context, 'No hay conexión a internet.');
                    }
                  },
                  child: Text(
                    'Cambiar Clave',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorFondo.BTNUBI,
                    fixedSize: Size(190, 40),
                    shape: StadiumBorder(),
                  ),
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

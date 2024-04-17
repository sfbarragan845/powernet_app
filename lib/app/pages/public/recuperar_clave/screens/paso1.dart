// ignore_for_file: unnecessary_const

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../api/internas/public/api_rc1.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cResponsive2.dart';
import '../../../../core/cInternet.dart';
import '../../../../models/share_preferences.dart';
import '../../../../pages/components/mostrar_snack.dart';
import '../../../../pages/components/progress.dart';
import '../../../../pages/public/recuperar_clave/screens/paso2.dart';

class RecuperarClave1 extends StatefulWidget {
  const RecuperarClave1({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const RecuperarClave1(),
    );
  }

  @override
  _RecuperarClave1State createState() => _RecuperarClave1State();
}

class _RecuperarClave1State extends State<RecuperarClave1>
    with SingleTickerProviderStateMixin {
  //const RecuperarContrasena({Key? key}) : super(key: key);
  late AnimationController controller;
  late Animation<double> animation;
  late RecuperarClave1 requestModel;
  final GlobalKey<FormState> _key = GlobalKey();

  final cedulaTxt = TextEditingController();

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
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //AppBar(title: 'Recuperar contraseña',),
          // ignore: prefer_const_constructors
         
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
                    padding: EdgeInsets.only(
                        top: 0,
                        bottom: 0,
                        left: Responsive.isMobile_pequenio(context)
                            ? 40
                            : Responsive.isMobile_mediano(context)
                                ? 30
                                : Responsive.isMobile_grande(context)
                                    ? 50
                                    : Responsive.isMobile_extragrande(context)
                                        ? 50
                                        : Responsive.isMobile_extragrande2(
                                                context)
                                            ? 50
                                            : Responsive.isMobile_extragrande3(
                                                    context)
                                                ? 50
                                                : Responsive.isTablet_pequenio(
                                                        context)
                                                    ? 50
                                                    : Responsive
                                                            .isTablet_mediano(
                                                                context)
                                                        ? 50
                                                        : Responsive
                                                                .isTablet_grande(
                                                                    context)
                                                            ? 50
                                                            : Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 50
                                                                : 50,
                        right: Responsive.isMobile_pequenio(context)
                            ? 40
                            : Responsive.isMobile_mediano(context)
                                ? 50
                                : Responsive.isMobile_grande(context)
                                    ? 50
                                    : Responsive.isMobile_extragrande(context)
                                        ? 50
                                        : Responsive.isMobile_extragrande2(
                                                context)
                                            ? 50
                                            : Responsive.isMobile_extragrande3(
                                                    context)
                                                ? 50
                                                : Responsive.isTablet_pequenio(
                                                        context)
                                                    ? 50
                                                    : Responsive
                                                            .isTablet_mediano(
                                                                context)
                                                        ? 50
                                                        : Responsive
                                                                .isTablet_grande(
                                                                    context)
                                                            ? 50
                                                            : Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 50
                                                                : 50),
                    child: SvgPicture.asset('assets/images/LOGONET.svg', height: Responsive.isMobile_pequenio(context)
                            ? 150
                            : Responsive.isMobile_mediano(context)
                                ? 200
                                : Responsive.isMobile_grande(context)
                                    ? 200
                                    : Responsive.isMobile_extragrande(context)
                                        ? 200
                                        : Responsive.isMobile_extragrande2(
                                                context)
                                            ? 200
                                            : Responsive.isMobile_extragrande3(
                                                    context)
                                                ? 200
                                                : Responsive.isTablet_pequenio(
                                                        context)
                                                    ? 200
                                                    : Responsive
                                                            .isTablet_mediano(
                                                                context)
                                                        ? 200
                                                        : Responsive
                                                                .isTablet_grande(
                                                                    context)
                                                            ? 200
                                                            : Responsive
                                                                    .isDesktop(
                                                                        context)
                                                                ? 200
                                                                : 200,)),
                const Center(
                  child: Text(
                    'Paso 1',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(children: [
                  Expanded(
                      flex: 2,
                      child: Divider(
                          thickness: 0.0001,
                          color: Theme.of(context).primaryColor)),
                  Expanded(
                      flex: 6,
                      child: Divider(
                          thickness: 1, color: Theme.of(context).primaryColor)),
                  Expanded(
                      flex: 2,
                      child: Divider(
                          thickness: 0.0001,
                          color: Theme.of(context).primaryColor)),
                ]),
                Center(
                  child: Text('Enviar código de seguridad',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 14,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: cedulaTxt,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es requerido";
                    } else if (value.length < 10) {
                      return "Debe completar al menos 10 caracteres";
                    }
                    return null;
                  },
                  // keyboardType: TextInputType.emailAddress,
                  maxLength: 13,

                  decoration: const InputDecoration(
                    hintText: 'Cédula o RUC',
                    //counterText: '',
                    labelStyle:
                        TextStyle(color: const Color.fromRGBO(0, 0, 0, 1.0)),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("Cancelar",
                          style: TextStyle(
                              fontSize: Responsive.isMobile_pequenio(context)
                                  ? 14
                                  : Responsive.isMobile_mediano(context)
                                      ? 15
                                      : Responsive.isMobile_grande(context)
                                          ? 15
                                          : Responsive.isMobile_extragrande(
                                                  context)
                                              ? 15
                                              : Responsive
                                                      .isMobile_extragrande2(
                                                          context)
                                                  ? 15
                                                  : Responsive
                                                          .isMobile_extragrande3(
                                                              context)
                                                      ? 15
                                                      : Responsive
                                                              .isTablet_pequenio(
                                                                  context)
                                                          ? 15
                                                          : Responsive
                                                                  .isTablet_mediano(
                                                                      context)
                                                              ? 15
                                                              : Responsive
                                                                      .isTablet_grande(
                                                                          context)
                                                                  ? 15
                                                                  : Responsive.isDesktop(
                                                                          context)
                                                                      ? 15
                                                                      : 15,
                              letterSpacing: 2.2,
                              color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        fixedSize: Size(
                            Responsive.isMobile_pequenio(context)
                                ? 110
                                : Responsive.isMobile_mediano(context)
                                    ? 120
                                    : Responsive.isMobile_grande(context)
                                        ? 120
                                        : Responsive.isMobile_extragrande(
                                                context)
                                            ? 120
                                            : Responsive.isMobile_extragrande2(
                                                    context)
                                                ? 120
                                                : Responsive
                                                        .isMobile_extragrande3(
                                                            context)
                                                    ? 120
                                                    : Responsive
                                                            .isTablet_pequenio(
                                                                context)
                                                        ? 120
                                                        : Responsive
                                                                .isTablet_mediano(
                                                                    context)
                                                            ? 120
                                                            : Responsive
                                                                    .isTablet_grande(
                                                                        context)
                                                                ? 120
                                                                : Responsive.isDesktop(
                                                                        context)
                                                                    ? 120
                                                                    : 120,
                            40),
                        //shape: StadiumBorder(),
                      ),
                    ),
                    // Enviar
                    ElevatedButton(
                      onPressed: () async {
                        InternetServices internet = InternetServices();
                        if (await internet.verificarConexion()) {
                          if (validateAndSave()) {
                            ProgressDialog progressDialog =
                                ProgressDialog(context);
                            progressDialog.show();
                            setState(
                              () {
                                postRecuperarClaveP1(cedulaTxt.text.toString())
                                    .then((_) {
                                  recuperarClavePaso1.then((value) {
                                    if (value['success'] == 'OK') {
                                      Preferences.usrIDRecuperar = int.parse(
                                          value['data_cliente']['user_id']);
                                      AwesomeDialog(
                                              dismissOnTouchOutside: false,
                                              context: context,
                                              dialogType: DialogType.INFO,
                                              animType: AnimType.TOPSLIDE,
                                              headerAnimationLoop: true,
                                              title: value['mensaje'],
                                              dialogBackgroundColor:
                                                  Colors.white,
                                              //  desc: 'Por favor, cambie e intente nuevamente.',
                                              btnOkOnPress: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const RecuperarClave2()),
                                                );
                                              },
                                              //btnOkIcon: Icons.cancel,
                                              btnOkText: 'Continuar',
                                              btnOkColor: ColorFondo.PRIMARY
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
                        "Enviar",
                        style: TextStyle(
                            fontSize: Responsive.isMobile_pequenio(context)
                                ? 14
                                : Responsive.isMobile_mediano(context)
                                    ? 15
                                    : Responsive.isMobile_grande(context)
                                        ? 15
                                        : Responsive.isMobile_extragrande(
                                                context)
                                            ? 15
                                            : Responsive.isMobile_extragrande2(
                                                    context)
                                                ? 15
                                                : Responsive
                                                        .isMobile_extragrande3(
                                                            context)
                                                    ? 15
                                                    : Responsive
                                                            .isTablet_pequenio(
                                                                context)
                                                        ? 15
                                                        : Responsive
                                                                .isTablet_mediano(
                                                                    context)
                                                            ? 15
                                                            : Responsive
                                                                    .isTablet_grande(
                                                                        context)
                                                                ? 15
                                                                : Responsive.isDesktop(
                                                                        context)
                                                                    ? 15
                                                                    : 15,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorFondo.PRIMARY,
                        fixedSize: Size(
                            Responsive.isMobile_pequenio(context)
                                ? 100
                                : Responsive.isMobile_mediano(context)
                                    ? 120
                                    : Responsive.isMobile_grande(context)
                                        ? 120
                                        : Responsive.isMobile_extragrande(
                                                context)
                                            ? 120
                                            : Responsive.isMobile_extragrande2(
                                                    context)
                                                ? 120
                                                : Responsive
                                                        .isMobile_extragrande3(
                                                            context)
                                                    ? 120
                                                    : Responsive
                                                            .isTablet_pequenio(
                                                                context)
                                                        ? 120
                                                        : Responsive
                                                                .isTablet_mediano(
                                                                    context)
                                                            ? 120
                                                            : Responsive
                                                                    .isTablet_grande(
                                                                        context)
                                                                ? 120
                                                                : Responsive.isDesktop(
                                                                        context)
                                                                    ? 120
                                                                    : 120,
                            40),
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

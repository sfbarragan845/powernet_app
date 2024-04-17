import 'package:powernet/app/pages/public/home/screens/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../clases/cResponsive2.dart';
import '/app/models/share_preferences.dart';
import '../../../../api/internas/public/login/api_login_final.dart';
import '../../../../api/internas/public/api_registro.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../core/cInternet.dart';
import '../../../../core/cValidacion.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../recursos/recursos.dart';

//import 'package:country_code_picker/country_code.dart';

class Registro12 extends StatefulWidget {
  const Registro12({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const Registro12(),
    );
  }

  @override
  _Registro1State createState() => _Registro1State();
}

class _Registro1State extends State<Registro12>
    with SingleTickerProviderStateMixin {
  //const RecuperarContrasena({Key? key}) : super(key: key);
  late AnimationController controller;
  late Animation<double> animation;
  late Registro12 requestModel;
  final GlobalKey<FormState> _key = GlobalKey();
  final nombresTxt = TextEditingController();
  //final apellidosTxt = TextEditingController();
  final cedulaTxt = TextEditingController();
  final telefonoTxt = TextEditingController();
  final correoTxt = TextEditingController();
  final correo1Txt = TextEditingController();
  final claveTxt = TextEditingController();
  final confclaveTxt = TextEditingController();
  final direccionTxt = TextEditingController();

  final cedulaFocus = FocusNode();
  final nombresFocus = FocusNode();
  //final apellidosFocus = FocusNode();
  final telefonoFocus = FocusNode();
  final correoFocus = FocusNode();
  final correo1Focus = FocusNode();
  final claveFocus = FocusNode();
  final confclaveFocus = FocusNode();
  final direccionFocus = FocusNode();

  String _countryDialCode = "+593";
  bool _showPassword = false;
  bool _showPassword1 = false;
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
    //Preferences.limpiar();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Proceso de Registro'),
          leading: IconButton(
            tooltip: 'Regresar',
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: registroForm());
  }

  Widget registroForm() {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Form(
        key: _key,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      //width: vwidth * 0.1,
                      height: Responsive.isMobile_pequenio(context)
                          ? vheight * 1.802
                          : Responsive.isMobile_mediano(context)
                              ? vheight * 1.352
                              : Responsive.isMobile_grande(context)
                                  ? vheight * 1.302
                                  : Responsive.isMobile_extragrande(context)
                                      ? vheight * 1.202
                                      : Responsive.isMobile_extragrande2(
                                              context)
                                          ? vheight * 1.202
                                          : Responsive.isMobile_extragrande3(
                                                  context)
                                              ? vheight * 0.902
                                              : Responsive.isTablet_pequenio(
                                                      context)
                                                  ? vheight * 0.902
                                                  : Responsive.isTablet_mediano(
                                                          context)
                                                      ? vheight * 0.902
                                                      : Responsive
                                                              .isTablet_grande(
                                                                  context)
                                                          ? vheight * 0.902
                                                          : Responsive
                                                                  .isDesktop(
                                                                      context)
                                                              ? vheight * 0.902
                                                              : vheight * 0.902,
                      child: Stack(
                        children: [
                          Container(
                            width: 375,
                            height: 812,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  top: 45.37,
                                  child: Opacity(
                                    opacity: 0.10,
                                    child: Container(
                                      width: 92.80,
                                      //height: 96.32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/plastic.svg'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 300,
                                  top: 468.95,
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Container(
                                      width: 85.15,
                                      // height: 123.64,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/plastic.svg'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0.40,
                                  top: 571.86,
                                  child: Opacity(
                                    opacity: 0.10,
                                    child: Container(
                                      width: 89.10,
                                      // height: 92.46,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/plastic.svg'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 129.56,
                                  top: 686.35,
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Container(
                                      width: 101.82,
                                      // height: 105.65,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/plastic.svg'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 301.78,
                                  top: 0,
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Container(
                                      width: 103.55,
                                      //height: 107.45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/plastic.svg'),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 230.36,
                                  child: Opacity(
                                    opacity: 0.15,
                                    child: Container(
                                      width: 128.99,
                                      //height: 133.86,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: SvgPicture.asset(
                                          'assets/images/plastic.svg'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: Responsive.isMobile_pequenio(context)
                                ? vheight / 17
                                : Responsive.isMobile_mediano(context)
                                    ? vheight / 17
                                    : Responsive.isMobile_grande(context)
                                        ? vheight / 9.8
                                        : Responsive.isMobile_extragrande(
                                                context)
                                            ? vheight / 10
                                            : Responsive.isMobile_extragrande2(
                                                    context)
                                                ? vheight / 10
                                                : Responsive
                                                        .isMobile_extragrande3(
                                                            context)
                                                    ? vheight / 17
                                                    : Responsive
                                                            .isTablet_pequenio(
                                                                context)
                                                        ? vheight / 17
                                                        : Responsive
                                                                .isTablet_mediano(
                                                                    context)
                                                            ? vheight / 17
                                                            : Responsive
                                                                    .isTablet_grande(
                                                                        context)
                                                                ? vheight / 17
                                                                : Responsive.isDesktop(
                                                                        context)
                                                                    ? vheight /
                                                                        17
                                                                    : vheight /
                                                                        17,
                            left: Responsive.isMobile_pequenio(context)
                                ? vwidth / 28
                                : Responsive.isMobile_mediano(context)
                                    ? vwidth / 14
                                    : Responsive.isMobile_grande(context)
                                        ? vwidth / 14
                                        : Responsive.isMobile_extragrande(
                                                context)
                                            ? vwidth / 14
                                            : Responsive.isMobile_extragrande2(
                                                    context)
                                                ? vwidth / 14
                                                : Responsive
                                                        .isMobile_extragrande3(
                                                            context)
                                                    ? vwidth / 14
                                                    : Responsive
                                                            .isTablet_pequenio(
                                                                context)
                                                        ? vwidth / 14
                                                        : Responsive
                                                                .isTablet_mediano(
                                                                    context)
                                                            ? vwidth / 14
                                                            : Responsive
                                                                    .isTablet_grande(
                                                                        context)
                                                                ? vwidth / 14
                                                                : Responsive.isDesktop(
                                                                        context)
                                                                    ? vwidth /
                                                                        14
                                                                    : vwidth /
                                                                        14,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: Responsive.isMobile_pequenio(context)
                                    ? vwidth * 0.95
                                    : Responsive.isMobile_mediano(context)
                                        ? vwidth * 0.85
                                        : Responsive.isMobile_grande(context)
                                            ? vwidth * 0.85
                                            : Responsive.isMobile_extragrande(
                                                    context)
                                                ? vwidth * 0.85
                                                : Responsive
                                                        .isMobile_extragrande2(
                                                            context)
                                                    ? vwidth * 0.85
                                                    : Responsive
                                                            .isMobile_extragrande3(
                                                                context)
                                                        ? vwidth * 0.85
                                                        : Responsive
                                                                .isTablet_pequenio(
                                                                    context)
                                                            ? vwidth * 0.85
                                                            : Responsive
                                                                    .isTablet_mediano(
                                                                        context)
                                                                ? vwidth * 0.85
                                                                : Responsive.isTablet_grande(
                                                                        context)
                                                                    ? vwidth *
                                                                        0.85
                                                                    : Responsive.isDesktop(
                                                                            context)
                                                                        ? vwidth *
                                                                            0.85
                                                                        : vwidth *
                                                                            0.85,
                                height: Responsive.isMobile_pequenio(context)
                                    ? vheight / 0.6401
                                    : Responsive.isMobile_mediano(context)
                                        ? vheight / 0.801
                                        : Responsive.isMobile_grande(context)
                                            ? vheight / 0.701
                                            : Responsive.isMobile_extragrande(
                                                    context)
                                                ? vheight / 1.01
                                                : Responsive
                                                        .isMobile_extragrande2(
                                                            context)
                                                    ? vheight / 1.001
                                                    : Responsive
                                                            .isMobile_extragrande3(
                                                                context)
                                                        ? vheight / 1.201
                                                        : Responsive
                                                                .isTablet_pequenio(
                                                                    context)
                                                            ? vheight / 1.201
                                                            : Responsive
                                                                    .isTablet_mediano(
                                                                        context)
                                                                ? vheight /
                                                                    1.201
                                                                : Responsive.isTablet_grande(
                                                                        context)
                                                                    ? vheight /
                                                                        1.201
                                                                    : Responsive.isDesktop(
                                                                            context)
                                                                        ? vheight /
                                                                            1.201
                                                                        : vheight /
                                                                            1.201,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: ColorFondo.BTNUBI,
                                ),
                                padding: EdgeInsets.only(
                                  left: vwidth / 15,
                                  right: 23,
                                  top: Responsive.isMobile_pequenio(context)
                                      ? vheight / 6
                                      : Responsive.isMobile_mediano(context)
                                          ? vheight / 6
                                          : Responsive.isMobile_grande(context)
                                              ? vheight / 18
                                              : Responsive.isMobile_extragrande(
                                                      context)
                                                  ? vheight / 18
                                                  : Responsive
                                                          .isMobile_extragrande2(
                                                              context)
                                                      ? vheight / 18
                                                      : Responsive
                                                              .isMobile_extragrande3(
                                                                  context)
                                                          ? vheight / 18
                                                          : Responsive
                                                                  .isTablet_pequenio(
                                                                      context)
                                                              ? vheight / 18
                                                              : Responsive
                                                                      .isTablet_mediano(
                                                                          context)
                                                                  ? vheight / 18
                                                                  : Responsive.isTablet_grande(
                                                                          context)
                                                                      ? vheight /
                                                                          18
                                                                      : Responsive.isDesktop(
                                                                              context)
                                                                          ? vheight /
                                                                              18
                                                                          : vheight /
                                                                              18,
                                  bottom: 34,
                                ),
                                child: Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'Datos generales',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    sombra(_nombres()),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    sombra(_cedula()),
                                    const SizedBox(height: 10),
                                    sombra(_telefono()),
                                    const SizedBox(height: 10),
                                    sombra(_direccion()),
                                    const SizedBox(height: 10),
                                    sombra(_correo()),
                                    const SizedBox(height: 10),
                                    sombra(_clave()),
                                    const SizedBox(height: 10),
                                    sombra(_claveConf()),
                                    const SizedBox(height: 12),
                                    _btnSubir()
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: vheight / 80,
                            left: vwidth / 2.6,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                width: 90,
                                height: 90,
                                child: ClipOval(
                                    child: Image.asset(
                                        'assets/images/redondo.png')),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _nombres() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: nombresTxt,
      focusNode: nombresFocus,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[a-z,A-Z,ñ,Ñ, ]')),
      ],
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
      //textAlign: TextAlign.center,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es requerido";
        } else if (value.length < 4) {
          return "Mínimo 4 caracteres";
        }
        return null;
      },
      // keyboardType: TextInputType.emailAddress,
      maxLength: 40,
      decoration: const InputDecoration(
        labelText: 'Nombres y Apellidos',
        //hintText: 'Nombres',
        counterText: '',
      ),
    );
  }

  Widget _cedula() {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: cedulaTxt,
      focusNode: cedulaFocus,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(telefonoFocus);
      },
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
        labelText: 'Cédula o RUC',
        hintText: 'Documento de identidad',
        counterText: '',
      ),
      // onSaved: (input) => requestModel.usuario = input!,
      // onSaved: (val) => _correo = val,
    );
  }

  Widget _direccion() {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: direccionTxt,
      focusNode: direccionFocus,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es requerido";
        } else if (value.length < 2) {
          return "Debe completar al menos 5 caracteres";
        }
        return null;
      },
      // keyboardType: TextInputType.emailAddress,
      maxLength: 300,

      decoration: const InputDecoration(
        labelText: 'Dirección',
        hintText: 'Dirección',
        counterText: '',
      ),
      // onSaved: (input) => requestModel.usuario = input!,
      // onSaved: (val) => _correo = val,
    );
  }

  Widget _telefono() {
    return Row(
      children: [
        CountryCodePicker(
          onChanged: (CountryCode countryCode) {
            _countryDialCode = countryCode.dialCode!;
          },
          initialSelection: _countryDialCode,
          favorite: [_countryDialCode],
          //alignLeft: false,
          showFlagMain: true,
          showDropDownButton: true,
          padding: EdgeInsets.zero,
        ),
        Expanded(
          child: TextFormField(
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            controller: telefonoTxt,
            focusNode: telefonoFocus,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
            onFieldSubmitted: (v) {
              FocusScope.of(context).requestFocus(correoFocus);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Este campo es requerido";
              } else if (value.length < 10) {
                return "Debe completar al menos 10 caracteres";
              }
              return null;
            },
            // keyboardType: TextInputType.emailAddress,
            maxLength: 10,

            decoration: const InputDecoration(
              labelText: 'Teléfono',
              hintText: '0999999999',
              counterText: '',
            ),
            // onSaved: (input) => requestModel.usuario = input!,
            // onSaved: (val) => _correo = val,
          ),
        )
      ],
    );
  }

  Widget _correo() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: correoTxt,
      textInputAction: TextInputAction.next,
      focusNode: correoFocus,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
      //textAlign: TextAlign.center,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo es requerido";
        } else if (!validator.email(value)) {
          return "El formato para correo no es correcto";
        }
        return null;
      },
      maxLength: 60,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(correo1Focus);
      },
      decoration: const InputDecoration(
        hintText: 'ejemplo@email.com',
        labelText: 'Correo electrónico',
        counterText: '',
      ),
      // onSaved: (input) => requestModel.usuario = input!,
      // onSaved: (val) => _correo = val,
    );
  }

  Widget _clave() {
    return TextFormField(
      controller: claveTxt,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo contraseña es requerido";
        } else if (confclaveTxt.text != value) {
          return "Las credenciales no coinciden";
        } else if (value.length < 3) {
          return "Contraseña de 3 caracteres";
        }
        return null;
      },
      keyboardType: TextInputType.text,
      maxLength: 50,
      decoration: InputDecoration(
        hintText: '∙∙∙∙∙∙∙∙∙∙',
        labelText: 'Contraseña',
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: _showPassword
                ? ColorFondo.PRIMARY
                : ColorFondo.PRIMARY.withOpacity(0.4),
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
      obscureText: !_showPassword,
    );
  }

  Widget _claveConf() {
    return TextFormField(
      controller: confclaveTxt,
      style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Este campo contraseña es requerido";
        } else if (claveTxt.text != value) {
          return "Las credenciales no coinciden";
        } else if (value.length < 3) {
          return "Contraseña de 3 caracteres";
        }
        return null;
      },
      keyboardType: TextInputType.text,
      maxLength: 50,
      decoration: InputDecoration(
        hintText: '∙∙∙∙∙∙∙∙∙∙',
        labelText: 'Confirmar Contraseña',
        counterText: '',
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword1 ? Icons.visibility : Icons.visibility_off,
            color: _showPassword1
                ? ColorFondo.PRIMARY
                : ColorFondo.PRIMARY.withOpacity(0.4),
          ),
          onPressed: () {
            setState(() {
              _showPassword1 = !_showPassword1;
            });
          },
        ),
      ),
      obscureText: !_showPassword1,
    );
  }

  Widget _btnSubir() {
    return ElevatedButton(
      onPressed: () async {
        InternetServices internet = InternetServices();
        if (await internet.verificarConexion()) {
          if (validateAndSave()) {
            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.show();
            setState(
              () {
                postRegistro(
                        nombresTxt.text.toString(),
                        cedulaTxt.text.toString(),
                        telefonoTxt.text.toString(),
                        direccionTxt.text.toString(),
                        correoTxt.text.toString(),
                        claveTxt.text.toString())
                    .then((_) {
                  recuperarClavePaso1.then((value) {
                    if (value['success'] == 'OK') {
                      AwesomeDialog(
                              dismissOnTouchOutside: false,
                              context: context,
                              dialogType: DialogType.INFO,
                              animType: AnimType.TOPSLIDE,
                              headerAnimationLoop: true,
                              title: 'Gracias por Descargar ORIGIN RECYCLE',
                              dialogBackgroundColor: Colors.white,
                              desc:
                                  'Valoramos tu interes por el medio Ambiente. Has ganado 10 PUNTOS ORIGIN',
                              btnOkOnPress: () async {
                                InternetServices internet = InternetServices();

                                if (await internet.verificarConexion()) {
                                  if (validateAndSave()) {
                                    ProgressDialog progressDialog =
                                        ProgressDialog(context);
                                    progressDialog.show();
                                    setState(() {
                                      dologin(
                                              correoTxt.text.toString(),
                                              claveTxt.text
                                                  .toString()
                                                  .toString())
                                          .then((_) {
                                        user.then((value) {
                                          if (value['success'] == 'OK') {
                                            Preferences.logueado = true;
                                            setState(() {
                                              Preferences.logueado = true;
                                            });
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const HomeApp()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } else if (value['success'] ==
                                              'ERROR') {
                                            mostrarError(
                                                context, value['mensaje']);
                                            Preferences.logueado = false;
                                          }
                                        });
                                        progressDialog.dismiss();
                                      });
                                    });
                                  }
                                } else {
                                  mostrarError(
                                      context, 'No hay conexión a internet.');
                                }
                              },
                              //btnOkIcon: Icons.cancel,
                              btnOkText: 'OK',
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
      child: const Text(
        "Registrarme",
        style: TextStyle(fontSize: 17, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorFondo.PRIMARY,
        fixedSize: const Size(170, 40),

        //shape: StadiumBorder(),
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

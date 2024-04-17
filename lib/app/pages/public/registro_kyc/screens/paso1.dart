import 'package:powernet/app/pages/public/home/screens/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class Registro1 extends StatefulWidget {
  const Registro1({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const Registro1(),
    );
  }

  @override
  _Registro1State createState() => _Registro1State();
}

class _Registro1State extends State<Registro1>
    with SingleTickerProviderStateMixin {
  //const RecuperarContrasena({Key? key}) : super(key: key);
  late AnimationController controller;
  late Animation<double> animation;
  late Registro1 requestModel;
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
          title: const Text('Registro de usuario'),
          leading: IconButton(
            tooltip: 'Regresar',
            icon: const Icon(Icons.arrow_back_ios_outlined),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: registroForm());
  }

  Widget registroForm() {
    return Center(
      //key: _key,
      child: Column(
        children: [
          //AppBar(title: 'Recuperar contraseña',),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              children: [
                /* Padding(
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/logos/Logo.png', height: 60),
                ),*/

                const SizedBox(
                  height: 35,
                ),
                const Center(
                  child: Text(
                    'Proceso de Registro',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const LinearProgressIndicator(
                  value: 0.5,
                  color: ColorFondo.PRIMARY,
                  backgroundColor: ColorFondo.SECONDARY,
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text('Datos generales',
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 16,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: sombra(_nombres())),
                    const SizedBox(width: 10),
                    // Expanded(child: sombra(_apellidos())),
                  ],
                ),
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
                const SizedBox(height: 40),
                _btnSubir()
              ],
            ),
          ),
        ],
      ),
    );
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
        labelText: 'Nombres',
        //hintText: 'Nombres',
        counterText: '',
      ),
      // onSaved: (input) => requestModel.usuario = input!,
      // onSaved: (val) => _correo = val,
    );
  }
  /* Widget _nombres() {
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
        labelText: 'Nombres',
        border: InputBorder.none,
        //hintText: 'Nombres',
        counterText: '',
      ),
      // onSaved: (input) => requestModel.usuario = input!,
      // onSaved: (val) => _correo = val,
    );
  }*/

  /* Widget _apellidos() {
    return TextFormField(
      keyboardType: TextInputType.name,
      controller: apellidosTxt,
      textCapitalization: TextCapitalization.words,
      focusNode: apellidosFocus,
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
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(cedulaFocus);
      },
      decoration: const InputDecoration(
        labelText: 'Apellidos',
        // hintText: 'Apellidos',
        counterText: '',
      ),
      // onSaved: (input) => requestModel.usuario = input!,
      // onSaved: (val) => _correo = val,
    );
  }*/

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
          return "Debe completar al menos 2 caracteres";
        }
        return null;
      },
      // keyboardType: TextInputType.emailAddress,
      maxLength: 13,

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
                              title: value['mensaje'],
                              dialogBackgroundColor: Colors.white,
                              //  desc: 'Por favor, cambie e intente nuevamente.',
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
        style: TextStyle(fontSize: 17, letterSpacing: 2.2, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorFondo.PRIMARY,
        fixedSize: const Size(110, 40),
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

// ignore_for_file: file_names, avoid_print

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../../api/internas/public/update/api_editarperfil.dart';
import '../../../../api/internas/public/update/api_cambiarfoto.dart' as foto;

import '/app/models/share_preferences.dart';

import '../../../../clases/bloc/connection_status_cubit.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cParametros.dart';
import '../../../../core/cInternet.dart';
import '../../../../core/cValidacion.dart';
import '../../../../pages/components/mostrar_snack.dart';
import '../../../../pages/components/progress.dart';
import '../../internet/widget/widget_sin_conexion.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const EditarPerfil(),
    );
  }

  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  final GlobalKey<FormState> _key = GlobalKey();
  final correoTxt = TextEditingController(text: Preferences.usrCorreo);
  final celularTxt = TextEditingController(text: Preferences.usrCelular);

  final ImagePicker _picker = ImagePicker();
  late Future<dynamic> user;
  void _postEnviarfoto() async {
    var uri =
        Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_cambiar_foto_v1.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['token'] = foto.tokenizer
      ..fields['id_usuario'] = Preferences.usrID.toString()
      ..fields['digitador'] = Preferences.usrNombre
      ..files.add(await http.MultipartFile.fromPath(
        'archivo1',
        imagenAnverso!.path.toString(),
      ));

    var response = await request.send();
    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final data = jsonDecode(responseString);
      user = Future.value(data);
      if (data['success'] == 'OK') {
        print(data);
        setState(() {
          Preferences.usrFoto = data['name_foto'];
        });
        successfully(context, '', data['mensaje'], 1);
        /*AwesomeDialog(
                // Opcion 2
                dismissOnTouchOutside: false,
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.TOPSLIDE,
                headerAnimationLoop: true,
                title: data['mensaje'],
                dialogBackgroundColor: Colors.white,
                //  desc: 'Por favor, cambie e intente nuevamente.',
                btnOkOnPress: () {
                  // Navigator.of(context).pop();
                },
                //btnOkIcon: Icons.cancel,
                btnOkText: 'Aceptar',
                btnOkColor: Colors.green
                //  btnOkColor: Colors.red,
                )
            .show();*/
      }
      if (data['success'] == 'ERROR') {
        mostrarError(context, data['mensaje']);
      }
    } else {
      //print('Something went wrong!');
    }
  }

  void successfully(context, String title, String Descrip, int num) {
    showCupertinoModalPopup(
        context: context,
        builder: ((context) => Scaffold(
            backgroundColor: Color.fromARGB(197, 71, 69, 69),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Color.fromARGB(0, 255, 214, 64),
                    width: 350,
                    height: 350,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: 344,
                              height: 300,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 344,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                    padding: const EdgeInsets.only(
                                      top: 96,
                                      bottom: 32,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 29),
                                        Text(
                                          title,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        SizedBox(
                                          width: 254,
                                          child: Text(
                                            Descrip,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                            onPressed: () {
                                              if (num == 1) {
                                                Navigator.pop(context);
                                              } else {
                                                setState(() {
                                                  Preferences.usrCorreo =
                                                      correoTxt.text;
                                                  Preferences.usrCelular =
                                                      celularTxt.text;
                                                });

                                                Navigator.of(context).pop();
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              }
                                            },
                                            child: Text('OK'),
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(190, 20),
                                              backgroundColor: Colors.green,
                                              shape: const StadiumBorder(),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              width: 350,
                              height: 350,
                              padding: const EdgeInsets.only(
                                left: 102,
                                right: 101,
                                top: 15,
                                bottom: 186,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 147,
                                    height: 149,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/petuko.png"),
                                        fit: BoxFit.contain,
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ))));
  }

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
        create: (_) => ConnectionStatusCubit(), child: editarPerfilForm());
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("¿Cómo desea subir la imagen?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: const Icon(
                              Icons.camera_alt,
                              color: ColorFondo.PRIMARY,
                            ),
                            title: const Text('Cámara'),
                            onTap: () => _openCamera(context),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: const Icon(
                              Icons.drive_folder_upload,
                              color: ColorFondo.PRIMARY,
                            ),
                            title: const Text('Galería'),
                            onTap: () => _openGallery(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  XFile? imagenAnverso;
  int numImagen = 0;

  void _openGallery(BuildContext context) async {
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    if (picture != null) {
      setState(() {
        switch (numImagen) {
          case 1:
            imagenAnverso = picture;
            break;
        }
      });
    }
    Navigator.of(context).pop();
    if (imagenAnverso != null) {
      _postEnviarfoto.call();
    }
  }

  void _openCamera(BuildContext context) async {
    var picture = await _picker.pickImage(source: ImageSource.camera);
    if (picture != null) {
      setState(() {
        switch (numImagen) {
          case 1:
            imagenAnverso = picture;
            break;
        }
      });
    }
    Navigator.of(context).pop();
    if (imagenAnverso != null) {
      _postEnviarfoto.call();
    }
  }

  Widget editarPerfilForm() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        leading: IconButton(
          tooltip: 'Regresar',
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Scaffold(
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
              child: Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _key,
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      numImagen = 1;
                                      _showSelectionDialog(context);
                                    });
                                  },
                                  child: Container(
                                    //radius: 45,
                                    child: ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "$ROOT$fotos_user${Preferences.usrFoto}",
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                          color: ColorFondo.PRIMARY,
                                        ),
                                      ),
                                    ),
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 10))
                                      ],
                                      shape: BoxShape.circle,
                                      //image: Image.network(''),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: ColorFondo.PRIMARY,
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          // RUC
                          TextFormField(
                            enabled: false,
                            initialValue: Preferences.usrCedula,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1.0)),

                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            // textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              // errorText: 'Ingrese la contraseña',
                              counterText: '',
                              icon: Icon(
                                FontAwesomeIcons.addressCard,
                                size: 32.0,
                                color: ColorFondo.BTNUBI,
                              ),

                              /*labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: ColorFondo.PRIMARY,
                                width: 1.0,
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: ColorFondo.PRIMARY,
                                width: 2.0,
                              )),*/
                            ),
                          ),
                          // Nombre del Usuario
                          TextFormField(
                            enabled: false,
                            initialValue: Preferences.usrNombre,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1.0)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Este campo es requerido";
                              } else if (value.length < 4) {
                                return "Nombre de al menos 4 caracteres";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            maxLength: 20,
                            // textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              // errorText: 'Ingrese la contraseña',
                              counterText: '',
                              icon: Icon(
                                Icons.person,
                                size: 32.0,
                                color: ColorFondo.BTNUBI,
                              ),

                              /* labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: ColorFondo.PRIMARY,
                                width: 1.0,
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: ColorFondo.PRIMARY,
                                width: 2.0,
                              )),*/
                            ),
                          ),
                          // Correo
                          TextFormField(
                            controller: correoTxt,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1.0)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Este campo correo es requerido";
                              } else if (!validator.email(value)) {
                                return "El formato para correo no es correcto";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 80,
                            // textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              // errorText: 'Ingrese la contraseña',
                              counterText: '',
                              icon: Icon(
                                Icons.email,
                                size: 32.0,
                                color: ColorFondo.BTNUBI,
                              ),

                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1.0)),
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
                          ),
                          // Celular
                          TextFormField(
                            controller: celularTxt,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp('[0-9]')),
                            ],
                            maxLength: 10,
                            style: const TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1.0)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Este campo es requerido";
                              } else if (value.length < 7) {
                                return "Número de al menos 7 caracteres.";
                              }
                              return null;
                            },
                            // textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              // errorText: 'Ingrese la contraseña',
                              counterText: '',
                              icon: Icon(
                                Icons.phone_android,
                                size: 32.0,
                                color: ColorFondo.BTNUBI,
                              ),

                              labelStyle: TextStyle(
                                  color: Color.fromRGBO(0, 0, 0, 1.0)),
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
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("Cancelar",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorFondo.BTNUBI,
                                  // fixedSize: const Size(190, 40),
                                  //  shape: const StadiumBorder(),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (celularTxt.text ==
                                          Preferences.usrCelular &&
                                      correoTxt.text == Preferences.usrCorreo) {
                                    AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.ERROR,
                                            animType: AnimType.TOPSLIDE,
                                            headerAnimationLoop: true,
                                            title:
                                                'No se han registrado cambios',
                                            dialogBackgroundColor: Colors.white,
                                            //  desc: 'Por favor, cambie e intente nuevamente.',
                                            btnOkOnPress: () {
                                              //Navigator.pop(context);
                                            },
                                            //btnOkIcon: Icons.cancel,
                                            btnOkText: 'Aceptar',
                                            btnOkColor: Colors.red
                                            //  btnOkColor: Colors.red,
                                            )
                                        .show();
                                  } else {
                                    InternetServices internet =
                                        InternetServices();
                                    if (await internet.verificarConexion()) {
                                      if (validateAndSave()) {
                                        ProgressDialog progressDialog =
                                            ProgressDialog(context);
                                        progressDialog.show();
                                        setState(() {
                                          postEditarPerfil(
                                                  correoTxt.text.toString(),
                                                  celularTxt.text.toString())
                                              .then((_) {
                                            editarPerfil.then((value) {
                                              progressDialog
                                                  .dismiss(); // Si se crashea el dismis va aqui
                                              if (value['success'] == 'OK') {
                                                // mostrarCorrecto( context, value['mensaje']); // Opcion 1
                                                successfully(context, '',
                                                    value['mensaje'], 2);
                                                /*AwesomeDialog(
                                                        // Opcion 2
                                                        dismissOnTouchOutside:
                                                            false,
                                                        context: context,
                                                        dialogType:
                                                            DialogType.SUCCES,
                                                        animType:
                                                            AnimType.TOPSLIDE,
                                                        headerAnimationLoop:
                                                            true,
                                                        title: value['mensaje'],
                                                        dialogBackgroundColor:
                                                            Colors.white,
                                                        //  desc: 'Por favor, cambie e intente nuevamente.',
                                                        btnOkOnPress: () {
                                                          Preferences
                                                                  .usrCorreo =
                                                              correoTxt.text;
                                                          Preferences
                                                                  .usrCelular =
                                                              celularTxt.text;
                                                          Navigator.of(context)
                                                              .pop();
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  FocusNode());
                                                        },
                                                        //btnOkIcon: Icons.cancel,
                                                        btnOkText: 'Aceptar',
                                                        btnOkColor: Colors.green
                                                        //  btnOkColor: Colors.red,
                                                        )
                                                    .show();*/
                                              } else if (value['success'] ==
                                                  'ERROR') {
                                                mostrarError(
                                                    context, value['mensaje']);
                                              }
                                            });
                                          });
                                          // progressDialog.dismiss();
                                        });
                                      }
                                    } else {
                                      mostrarError(context,
                                          'No hay conexión a internet');
                                    }
                                  }
                                },
                                child: const Text(
                                  "Guardar",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorFondo.PRIMARY,
                                  // fixedSize: const Size(190, 40),
                                  //  shape: const StadiumBorder(),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return widget_sinConexion();
          }
        }),
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

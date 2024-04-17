// ignore_for_file: unnecessary_string_interpolations, file_names

import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import '/app/models/share_preferences.dart';
import '/app/pages/components/mostrar_snack.dart';
import '/app/pages/public/profile/screens/cerrarSesion.dart';
import '../../../../api/internas/public/update/api_cambiarfoto.dart' as fotos;
import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cParametros.dart';
import '../../profile/screens/sobreNosotrosScreen.dart';
import '../../providers/auth_provider.dart';
import '../../terminos/screens/terminosCondicionesScreen.dart';
import 'cambiarclaveScreen.dart';
import 'editarperfilScreen.dart';

String? foto;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  late AuthProvider authProvider;
  late String currentUserId;
  // late Timer _timer;

  //@override
  // void initState() {
  //   super.initState();
  //   _timer = Timer(const Duration(seconds: 5), _onShowLogin);
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account;
      });
    });
  }

  void successfully(context, String title) {
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
                                        /*Text(
                                          "Generar Pedido",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                          ),
                                        ),*/
                                        SizedBox(height: 15),
                                        SizedBox(
                                          width: 254,
                                          child: Text(
                                            title,
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
                                              Navigator.pop(context);
                                            },
                                            child: Text('Aceptar'),
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

  final ImagePicker _picker = ImagePicker();
  late Future<dynamic> user;
  void _postEnviarfoto() async {
    var uri =
        Uri.parse('$ROOT/app/$FOLDER/$IDENTYAPP/login/api_cambiar_foto_v1.php');
    var request = http.MultipartRequest('POST', uri)
      ..fields['token'] = fotos.tokenizer
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
        //print(data);
        setState(() {
          Preferences.usrFoto = data['name_foto'];
        });
        successfully(context, data['mensaje']);
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
                  //Navigator.pop();
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
      // print('Something went wrong!');
    }
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

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? users = _currentUser;
    return ListView(children: <Widget>[
      AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Perfil'),
        backgroundColor: ColorFondo.PRIMARY,
      ),

      DrawerHeader(
        padding: const EdgeInsets.all(10.0),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        numImagen = 1;
                        _showSelectionDialog(context);
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "$ROOT$fotos_user${Preferences.usrFoto}",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.person),
                            ),
                          ),
                          width: 89,
                          height: 89,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            //image: Image.network(''),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.60,
              //  color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      Preferences.usrNombre,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: ColorLetra.SECONDARY,
                      ),
                    ),
                  ),
                  Text(
                    Preferences.usrCorreo,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: ColorLetra.SECONDARY,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ListTile(
          leading: Icon(Icons.edit, size: 32.0, color: ColorFondo.BTNUBI),
          title: const Text('Editar Perfil'),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const EditarPerfil()),
            );
          }),
      const Divider(),
      ListTile(
          leading: Icon(Icons.lock_reset_outlined,
              size: 32.0, color: ColorFondo.BTNUBI),
          title: const Text('Cambiar Contraseña'),
          onTap: () {
            if (Preferences.TipoOuthSesion == 'GOOGLE' ||
                Preferences.TipoOuthSesion == 'FACEBOOK') {
              mostrarError(context,
                  'Esta opción no esta disponible para usuario logeados mediante Redes Sociales.');
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CambiarClave()),
              );
            }
          }),
      const Divider(),
      ListTile(
          leading:
              Icon(Icons.info_outline, size: 32.0, color: ColorFondo.BTNUBI),
          title: const Text('Sobre Nosotros'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SobreNosotros()),
            );
          }),
      const Divider(),
      ListTile(
          leading:
              Icon(Icons.privacy_tip, size: 32.0, color: ColorFondo.BTNUBI),
          title: const Text('Privacidad'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TerminosCondiciones()),
            );
          }),
      const Divider(),
      ListTile(
          leading:
              Icon(Icons.share_outlined, size: 32.0, color: ColorFondo.BTNUBI),
          title: const Text('Compartir Aplicación'),
          onTap: () {
            // Navigator.pushNamed(context, '/');
            Share.share(
                'Descarga mi aplicación $nombre_corto desde: $web_oficial',
                subject: 'Descarga $nombre_largo');
          }),
      // const Divider(),
      // ListTile(
      //     leading: Icon(Icons.star_half_rounded,
      //         size: 32.0, color: Theme.of(context).primaryColor),
      //     title: const Text('Calificar Aplicación'),
      //     //subtitle: const Text('The airplane is only in Act II.'),
      //     onTap: () {
      //       StoreRedirect.redirect(
      //           androidAppId: "$play_store", iOSAppId: "$app_store");
      //     }),
      const Divider(),
      /*ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const CerrarSesion()), (Route<dynamic> route) => false);
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.red,
          ),
          label: const Text(
            'Cerrar Sesión',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.red),
          ),
          style: ElevatedButton.styleFrom(fixedSize: const Size(230, 40), primary: Colors.white, alignment: Alignment.center))*/
      /*
      SwitchListTile.adaptive(
          value: Preferences.isDarkmode,
          title: const Text('Darkmode'),
          onChanged: (value) {
            Preferences.isDarkmode = value;
            final themeProvider =
                Provider.of<ThemeProvider>(context, listen: false);

            value ? themeProvider.setDarkmode() : themeProvider.setLightMode();

            setState(() {});
          }),
          */
      ListTile(
        onTap: () => {
          //googleSignOut(),
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CerrarSesion())),
        },
        leading:
            Icon(Icons.logout_outlined, size: 32.0, color: ColorFondo.BTNUBI),
        title: const Text('Cerrar Sesión'),

        /* AwesomeDialog(
              dismissOnTouchOutside: false,
              context: context,
              dialogType: DialogType.QUESTION,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Cerrar sesión',
              desc: '¿Realmente desea cerrar sesión?',
              btnCancelOnPress: () {},
              btnOkOnPress: () async {
                Preferences.logout();
                //_googleSignIn.disconnect();
                setState(() {
                  Preferences.logueado = false;

                 
                });
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginScreen()), (Route<dynamic> route) => false);
              },
              btnOkText: 'Sí',
              btnCancelText: 'Cancelar',
            ).show();*/
      ),
    ]);
  }
}

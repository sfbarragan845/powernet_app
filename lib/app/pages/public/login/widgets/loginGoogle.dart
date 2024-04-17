import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../../../../api/internas/public/login/api_login_oauth.dart';
import '../../../../api/internas/public/login/api_oauth.dart';
import '../../../../models/share_preferences.dart';
import '../../../components/mostrar_snack.dart';
//import '../../allConstants/firestore_constants.dart';
import '../../providers/auth_provider.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

class BtnGoogle extends StatefulWidget {
  const BtnGoogle({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const BtnGoogle(),
    );
  }

  @override
  _BtnGoogle createState() => _BtnGoogle();
}

class _BtnGoogle extends State<BtnGoogle> with SingleTickerProviderStateMixin {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      if (mounted) {
        setState(() {
          _currentUser = account;
        });
      }
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Widget loginFacebook(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ElevatedButton.icon(
        onPressed: () async {
          bool isSuccess = await authProvider.handleGoogleSignIn();
          if (isSuccess) {
            print('id: ${authProvider.getFirebaseUserId()}');
            print('nombre: ${authProvider.getFirebaseDisplayName()}');
            print(
                'correo: usrCorreo ${Preferences.usrCorreo}:u  ${authProvider.getFirebaseCorreo()}');
            Preferences.usrNombre = authProvider.getFirebaseDisplayName()!;
            Preferences.usrCorreo = authProvider.getFirebaseCorreo()!;
            // Preferences.usrID = int.parse(authProvider.getFirebaseUserId()!);
            postRegistroOauth(Preferences.usrNombre.toString(),
                    Preferences.usrCorreo.toString(), "GOOGLE")
                .then((_) {
              registroOauth.then((value) {
                if (value['success'] == 'OK') {
                  mostrarCorrecto(context, value['mensaje']);
                  setState(() {
                    print('INGRESE AL LOGIN');
                    dologinOauth(Preferences.usrCorreo.toString(), "GOOGLE")
                        .then((_) {
                      users.then((data) {
                        if (data['success'] == 'OK') {
                          Preferences.logueado = true;
                          setState(() {
                            Preferences.logueado = true;
                            Preferences.usrOauth = "SI";
                            // Guardo datos del usuario
                            Preferences.logueado = true;
                            Preferences.num_page = 2;
                            // Preferences.isDarkmode = false;
                            Preferences.TipoOuthSesion = "GOOGLE";
                            Preferences.usrID = data['data_cliente']['user_id'];
                            Preferences.usrNombre =
                                data['data_cliente']['user_name'];
                            Preferences.usrCorreo =
                                data['data_cliente']['user_mail'];
                            Preferences.usrCelular =
                                data['data_cliente']['user_celu'];
                            Preferences.usrCedula =
                                data['data_cliente']['user_cedu'];
                            if (data['data_cliente']['user_foto'] == "" ||
                                data['data_cliente']['user_foto'] == null) {
                              Preferences.usrFoto = 'avatar-men.png';
                            } else {
                              Preferences.usrFoto =
                                  data['data_cliente']['user_foto'];
                            }
                          });
                          // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
                        } else if (value['success'] == 'ERROR') {
                          mostrarError(context, value['mensaje']);
                          Preferences.logueado = false;
                        }
                      });
                    });
                  });
                } else if (value['success'] == 'ERROR') {
                  mostrarError(context, value['mensaje']);
                }
              });
            });

            //  Preferences.usrNombre = ;
            //Preferences.usrCorreo = ;
          } else {
            return;
          }
        },
        icon: SvgPicture.asset(
          'assets/images/google.svg',
          width: 18,
        ),
        label: const Text(
          'Continuar con Google',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(230, 40),
            backgroundColor: Colors.white,
            shape: const StadiumBorder(),
            alignment: Alignment.centerLeft));
  }

  log() {
    if (_currentUser != null) {
      signOut();
    } else {
      signInF();
    }
  }

  signOut() async {
    _currentUser = await _googleSignIn.disconnect();
  }

  signInF() async {
    try {
      _currentUser = await _googleSignIn.signIn();
    } catch (e) {
      print('Error signing in $e');
    }
  }
}

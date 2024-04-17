// ignore_for_file: file_names, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../clases/cResponsive2.dart';
import '/app/clases/cConfig_UI.dart';
import '../../../../models/share_preferences.dart';
import '../../login/screens/loginScreen.dart';
import '../../providers/auth_provider.dart';

class CerrarSesion extends StatefulWidget {
  const CerrarSesion({Key? key}) : super(key: key);

  @override
  _CerrarSesionState createState() => _CerrarSesionState();
}

class _CerrarSesionState extends State<CerrarSesion> {
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  //GoogleSignInAccount? _currentUser;
  AuthProvider? authProvider;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
  }

  Widget _btncerrar(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          if (Preferences.TipoOuthSesion == "FACEBOOK") {
            setState(() {
              Preferences.logout();
              FacebookAuth.i.logOut();
              // authProvider.googleSignOut();
              Preferences.usrNombre = '';
              Preferences.logueado = false;
              Preferences.TipoOuthSesion = '';
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false);
          } else if (Preferences.TipoOuthSesion == "GOOGLE") {
            setState(() {
              Preferences.logout();
              //FacebookAuth.i.logOut();
              googleSignOut();
              Preferences.usrNombre = '';
              Preferences.logueado = false;
              Preferences.TipoOuthSesion = '';
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false);
          } else {
            setState(() {
              Preferences.logout();
              //FacebookAuth.i.logOut();
              //authProvider.googleSignOut();
              Preferences.usrNombre = '';
              Preferences.logueado = false;
              Preferences.TipoOuthSesion = '';
            });
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (Route<dynamic> route) => false);
          }
        },
        child: const Text(
          'Cerrar Sesión',
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(230, 40),
            backgroundColor: ColorFondo.BTNUBI,
            alignment: Alignment.center));
  }

  Future<void> googleSignOut() async {
    authProvider?.googleSignOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Responsive.isMobile_pequenio(context)
                ? 20
                : Responsive.isMobile_mediano(context)
                    ? 20
                    : Responsive.isMobile_grande(context)
                        ? 20
                        : Responsive.isMobile_extragrande(context)
                            ? 20
                            : Responsive.isMobile_extragrande2(context)
                                ? 20
                                : Responsive.isMobile_extragrande3(context)
                                    ? 20
                                    : Responsive.isTablet_pequenio(context)
                                        ? 20
                                        : Responsive.isTablet_mediano(context)
                                            ? 20
                                            : Responsive.isTablet_grande(
                                                    context)
                                                ? 20
                                                : Responsive.isDesktop(context)
                                                    ? 20
                                                    : 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(
                  CupertinoIcons.clear_circled,
                  size: 70,
                  color: Color.fromARGB(255, 43, 87, 124),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: vwidth / 12)
            ],
          ),
          SizedBox(
              height: Responsive.isMobile_pequenio(context)
                  ? 1
                  : Responsive.isMobile_mediano(context)
                      ? 1
                      : Responsive.isMobile_grande(context)
                          ? vheight / 10
                          : Responsive.isMobile_extragrande(context)
                              ? vheight / 10
                              : Responsive.isMobile_extragrande2(context)
                                  ? vheight / 10
                                  : Responsive.isMobile_extragrande3(context)
                                      ? vheight / 10
                                      : Responsive.isTablet_pequenio(context)
                                          ? vheight / 10
                                          : Responsive.isTablet_mediano(context)
                                              ? vheight / 10
                                              : Responsive.isTablet_grande(
                                                      context)
                                                  ? vheight / 10
                                                  : Responsive.isDesktop(
                                                          context)
                                                      ? vheight / 10
                                                      : vheight / 10),
          Center(
            child: Container(
              width: vwidth * 0.6,
              height: Responsive.isMobile_pequenio(context)
                  ? vheight * 0.4
                  : Responsive.isMobile_mediano(context)
                      ? vheight * 0.4
                      : Responsive.isMobile_grande(context)
                          ? vheight * 0.4
                          : Responsive.isMobile_extragrande(context)
                              ? vheight * 0.4
                              : Responsive.isMobile_extragrande2(context)
                                  ? vheight * 0.4
                                  : Responsive.isMobile_extragrande3(context)
                                      ? vheight * 0.4
                                      : Responsive.isTablet_pequenio(context)
                                          ? vheight * 0.4
                                          : Responsive.isTablet_mediano(context)
                                              ? vheight * 0.4
                                              : Responsive.isTablet_grande(
                                                      context)
                                                  ? vheight * 0.4
                                                  : Responsive.isDesktop(
                                                          context)
                                                      ? vheight * 0.4
                                                      : vheight * 0.4,
              child: Image.asset('assets/logos/logo_PowerNet.png'),
            ),
            widthFactor: 1,
          ),

          SizedBox(
            height: Responsive.isMobile_pequenio(context)
                ? 1
                : Responsive.isMobile_mediano(context)
                    ? 1
                    : Responsive.isMobile_grande(context)
                        ? vheight / 20
                        : Responsive.isMobile_extragrande(context)
                            ? vheight / 20
                            : Responsive.isMobile_extragrande2(context)
                                ? vheight / 20
                                : Responsive.isMobile_extragrande3(context)
                                    ? vheight / 20
                                    : Responsive.isTablet_pequenio(context)
                                        ? vheight / 20
                                        : Responsive.isTablet_mediano(context)
                                            ? vheight / 20
                                            : Responsive.isTablet_grande(
                                                    context)
                                                ? vheight / 20
                                                : Responsive.isDesktop(context)
                                                    ? vheight / 20
                                                    : vheight / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                CupertinoIcons.info_circle,
                size: 45,
                color: Color.fromARGB(255, 43, 87, 124),
              ),
              Text(
                'Cerrando Sesión',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            ],
          ),
          SizedBox(
            height: Responsive.isMobile_pequenio(context)
                ? 20
                : Responsive.isMobile_mediano(context)
                    ? 20
                    : Responsive.isMobile_grande(context)
                        ? 20
                        : Responsive.isMobile_extragrande(context)
                            ? 20
                            : Responsive.isMobile_extragrande2(context)
                                ? 20
                                : Responsive.isMobile_extragrande3(context)
                                    ? 20
                                    : Responsive.isTablet_pequenio(context)
                                        ? 20
                                        : Responsive.isTablet_mediano(context)
                                            ? 20
                                            : Responsive.isTablet_grande(
                                                    context)
                                                ? 20
                                                : Responsive.isDesktop(context)
                                                    ? 20
                                                    : 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                width: 265,
                child: Center(
                  child: Text(
                    "¿Estás seguro de que deseas salir de tu sesión PowerNet?",
                    style: TextStyle(
                        color: Color.fromARGB(255, 108, 104, 104),
                        fontSize: 17),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: vheight / 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _btncerrar(context),
            ],
          )
          //_quienesSomos(context),
        ],
      ),
    );
  }
}

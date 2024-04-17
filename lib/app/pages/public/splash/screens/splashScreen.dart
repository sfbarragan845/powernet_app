// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/cInternet.dart';
import '../../../../pages/public/login/screens/loginScreen.dart';

import '../../../../api/internas/public/api_version_app.dart';
import '../../../../clases/cParametros.dart';
import '../../home/screens/home.dart';
import '../../versionapp/version_app.dart';
import '/app/models/share_preferences.dart';
import '/app/models/var_global.dart' as global;

bool? logueado = false;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    postVersion('Hola').then((_) {
      versionAPP.then((value) {
        if (value['success'] == 'OK') {
          print('aqui');

          print(global.versionAPP);
        } else if (value['success'] == 'ERROR') {}
      });
    });
    _timer = Timer(const Duration(seconds: 5), _onShowLogin);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _onShowLogin() async {
    InternetServices internet = InternetServices();

    if (await internet.verificarConexion()) {
      if (global.versionAPP == versionapp) {
        if (Preferences.logueado == true) {
          if (Preferences.usrID == 0) {
            Navigator.of(context).pushReplacement(LoginScreen.route());
          } else {
            setState(() {
              Preferences.num_page = 2;
              Navigator.of(context).pushReplacement(HomeApp.route());
            });
          }
        } else {
          Navigator.of(context).pushReplacement(LoginScreen.route());
        }
      } else {
        Navigator.of(context).pushReplacement(VersionApp.route());
      }
    } else {
      if (Preferences.logueado == true) {
        if (Preferences.usrID == 0) {
          Navigator.of(context).pushReplacement(LoginScreen.route());
        } else {
          setState(() {
            Preferences.num_page = 2;
            Navigator.of(context).pushReplacement(HomeApp.route());
          });
        }
      } else {
        Navigator.of(context).pushReplacement(LoginScreen.route());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Falta hacer responsive;
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;

    return Container(
      width: 375,
      height: 812,
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: vwidth,
                height: vheight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/splash_powernet.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: (vwidth * 0.40),
                      bottom: (vheight * 0.01),
                      child: Center(
                        child: Container(
                          width: vwidth * 0.6,
                          height: vheight * 1.1,
                          child: Center(
                              child: Image.asset(
                                  'assets/logos/logo_PowerNet.png')),
                        ),
                        widthFactor: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

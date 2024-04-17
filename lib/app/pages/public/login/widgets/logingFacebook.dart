import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BtnFacebook extends StatefulWidget {
  const BtnFacebook({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const BtnFacebook(),
    );
  }

  @override
  _BtnFacebookState createState() => _BtnFacebookState();
}

class _BtnFacebookState extends State<BtnFacebook> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // Widget loginFacebook(BuildContext context) {
    Map? _userData;
    return ElevatedButton.icon(
        onPressed: () async {
          Fluttertoast.showToast(
              msg: "COMING SOON",
              gravity: ToastGravity.CENTER,
              backgroundColor: Color.fromARGB(248, 81, 233, 200),
              toastLength: Toast.LENGTH_LONG,
              textColor: Colors.black,
              fontSize: 25);
          /*InternetServices internet = InternetServices();
          if (await internet.verificarConexion()) {
            //CODIGO FACE
            final result = await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.show();

            if (result.status == LoginStatus.success) {
              final requestData = await FacebookAuth.i.getUserData(fields: "email,name");
              setState(() {
                _userData = requestData;
                // Preferences.logueado = true;
                Preferences.usrNombre = _userData!['name'];
                Preferences.usrCorreo = _userData!['email'];
                postRegistroOauth(Preferences.usrNombre.toString(), Preferences.usrCorreo.toString(), "FACEBOOK").then((_) {
                  registroOauth.then((value) {
                    if (value['success'] == 'OK') {
                      mostrarCorrecto(context, value['mensaje']);
                      setState(() {
                        dologinOauth(Preferences.usrCorreo.toString(), "FACEBOOK").then((_) {
                          users.then((value) {
                            if (value['success'] == 'OK') {
                              Preferences.logueado = true;
                              setState(() {
                                Preferences.logueado = true;
                                Preferences.usrOauth = "SI";
                                Preferences.TipoOuthSesion = "FACEBOOK";
                                Preferences.num_page = 2;
                                //Guardo datos del usuario
                                Preferences.usrID = value['data_cliente']['user_id'];
                                Preferences.usrNombre = value['data_cliente']['user_name'];
                                Preferences.usrCorreo = value['data_cliente']['user_mail'];
                                Preferences.usrCelular = value['data_cliente']['user_celu'];
                                Preferences.usrCedula = value['data_cliente']['user_cedu'];
                                if (value['data_cliente']['user_foto'] == "" || value['data_cliente']['user_foto'] == null) {
                                  Preferences.usrFoto = 'avatar-men.png';
                                } else {
                                  Preferences.usrFoto = value['data_cliente']['user_foto'];
                                }
                              });
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (Route<dynamic> route) => false);
                            } else if (value['success'] == 'ERROR') {
                              mostrarError(context, value['mensaje']);
                              Preferences.logueado = false;
                            }
                          });
                          progressDialog.dismiss();
                        });
                      });
                    } else if (value['success'] == 'ERROR') {
                      mostrarError(context, value['mensaje']);
                    }
                  });
                  progressDialog.dismiss();
                });
              });
            }
            //FIN CODIGO 
          } else {
            mostrarError(context, 'No hay conexión a internet.');
          }
          */
          //FACEBOOK
        },
        icon: const Icon(
          Icons.facebook_outlined,
          color: Colors.blue,
        ),
        label: const Text(
          'Continuar con Facebook',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        style: ElevatedButton.styleFrom(fixedSize: const Size(230, 40), backgroundColor: Colors.white, shape: const StadiumBorder(), alignment: Alignment.centerLeft));
  }
}

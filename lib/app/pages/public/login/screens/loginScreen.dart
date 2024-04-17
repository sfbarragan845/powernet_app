// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../../clases/responsive.dart';

import '../../../../clases/cParametros.dart';
import '../../../../clases/cResponsive2.dart';
import '../../home/screens/home.dart';
import '/app/controllers/google_loging_controller.dart';
import '/app/models/share_preferences.dart';
// Desde API's al resto
import '../../../../api/internas/public/login/api_login_final.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../core/cInternet.dart';
import '../../../../core/cValidacion.dart';
import '../../../../pages/components/progress.dart';
import '../../../components/mostrar_snack.dart';
import '../widgets/crear_cuenta.dart';
// Widgets ==> Construyen parte Visual
import '../widgets/olvido_clave.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  bool isApiCallProgress = false;
  final GlobalKey<FormState> _key = GlobalKey();
  String mensaje = '';
  bool _showPassword = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  bool? logueado = false;
  GoogleSignInAccount? _currentUser;

  @override
  initState() {
    super.initState();

    if (mounted) {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
        if (mounted) {
          setState(() {
            _currentUser = account;
          });
        }
      });
      _googleSignIn.signInSilently();
    }

    controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    ResponsiveMediaQuery().init(context);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => GoogleSignInController(),
          )
        ],
        child: Scaffold(
          body: Preferences.logueado == true
              ? const HomeApp()
              : loginForm(vwidth, vheight),
        ));
    /*return Scaffold(
      body: Preferences.logueado == true ? const HomeScreen() : loginForm(),
    );*/
  }

  Widget _contenedor(double wi, double he) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        TextFormField(
          controller: emailcontroller,
          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
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
          decoration: const InputDecoration(
            hintText: 'ejemplo@email.com',
            labelText: 'Usuario',
            counterText: '',
            icon: Icon(
              Icons.person,
              size: 32.0,
              color: ColorFondo.BTNUBI,
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
        ),
        // Contraseña
        SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: passwordcontroller,
          style: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Este campo contraseña es requerido";
            } else if (value.length < 5) {
              return "Contraseña de 5 caracteres";
            }
            return null;
          },
          keyboardType: TextInputType.text,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: '∙∙∙∙∙∙∙∙∙∙',
            labelText: 'Contraseña',
            counterText: '',
            icon: const Icon(
              Icons.lock_reset_outlined,
              size: 32.0,
              color: ColorFondo.BTNUBI,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _showPassword ? Icons.visibility : Icons.visibility_off,
                color: _showPassword
                    ? ColorFondo.BTNUBI
                    : ColorFondo.BTNUBI.withOpacity(0.4),
              ),
              onPressed: () {
                setState(() {
                  _showPassword = !_showPassword;
                });
              },
            ),
            labelStyle: const TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: ColorFondo.PRIMARY,
              width: 1.0,
            )),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: ColorFondo.PRIMARY,
              width: 2.0,
            )),
          ),
          obscureText: !_showPassword,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            SizedBox(
              width: Responsive.isMobile_pequenio(context)
                  ? 30
                  : Responsive.isMobile_mediano(context)
                      ? 55
                      : Responsive.isMobile_grande(context)
                          ? 55
                          : Responsive.isMobile_extragrande(context)
                              ? 55
                              : Responsive.isMobile_extragrande2(context)
                                  ? 55
                                  : Responsive.isMobile_extragrande3(context)
                                      ? 55
                                      : Responsive.isTablet_pequenio(context)
                                          ? 55
                                          : Responsive.isTablet_mediano(context)
                                              ? 55
                                              : Responsive.isTablet_grande(
                                                      context)
                                                  ? 55
                                                  : Responsive.isDesktop(
                                                          context)
                                                      ? 55
                                                      : 55,
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        Center(
          child: GestureDetector(
              onTap: () async {
                /*  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeApp())); */
                InternetServices internet = InternetServices();

                if (await internet.verificarConexion()) {
                  if (validateAndSave()) {
                    ProgressDialog progressDialog = ProgressDialog(context);
                    progressDialog.show();
                    setState(() {
                      dologin(emailcontroller.text.toString(),
                              passwordcontroller.text.toString())
                          .then((_) {
                        user.then((value) {
                          if (value['success'] == 'OK') {
                            Preferences.logueado = true;
                            setState(() {
                              Preferences.logueado = true;
                              Preferences.num_page = 2;
                            });
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomeApp()),
                                (Route<dynamic> route) => false);
                          } else if (value['success'] == 'ERROR') {
                            mostrarError(context, value['mensaje']);
                            Preferences.logueado = false;
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
              child: Container(
                  width: wi * 0.7,
                  height: he * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF1B1464)),
                  child: Center(
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ))),
        ),
        /* ElevatedButton(
          onPressed: () async {
            InternetServices internet = InternetServices();

            if (await internet.verificarConexion()) {
              if (validateAndSave()) {
                ProgressDialog progressDialog = ProgressDialog(context);
                progressDialog.show();
                setState(() {
                  dologin(emailcontroller.text.toString(),
                          passwordcontroller.text.toString())
                      .then((_) {
                    user.then((value) {
                      if (value['success'] == 'OK') {
                        Preferences.logueado = true;
                        setState(() {
                          Preferences.logueado = true;
                          Preferences.num_page = 2;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                            (Route<dynamic> route) => false);
                      } else if (value['success'] == 'ERROR') {
                        mostrarError(context, value['mensaje']);
                        Preferences.logueado = false;
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
          child: const Text(
            'ACCEDER',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorFondo.BTNUBI,
            fixedSize: const Size(190, 40),
            shape: const StadiumBorder(),
          ),
        ), */
        const SizedBox(
          height: 30,
        ),
        /* SizedBox(
                width: 188,
                height: 30,
                child: Center(child: olvidoContrasena(context))), */
        /*divider(),
        const SizedBox(
          height: 40,
        ),*/
        /* crearCuenta(context),
        const SizedBox(
          height: 30,
        ), */
        Center(
          child: Text(
            versionapp,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        const SizedBox(
          height: 60,
        ),
        /*
        const BtnFacebook(),
        const SizedBox(
          height: 10,
        ),
        //loginUi(context),
        const BtnGoogle(),
        const SizedBox(
          height: 30,
        ),
*/
        //terminosYCondiciones(context),
      ],
    );
  }

  Widget loginForm(double we, double he) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_powernet.png"),
            fit: BoxFit.cover,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: ColorFondo.SECONDARY,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 3)
          ],
        ),
        child: Column(
          children: [
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
                                                    : Responsive
                                                            .isTablet_grande(
                                                                context)
                                                        ? 50
                                                        : Responsive.isDesktop(
                                                                context)
                                                            ? 50
                                                            : 50),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(Responsive.isMobile_pequenio(
                            context)
                        ? 20
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
                                                    : Responsive
                                                            .isTablet_grande(
                                                                context)
                                                        ? 50
                                                        : Responsive.isDesktop(
                                                                context)
                                                            ? 50
                                                            : 50),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/images/LOGONET.svg',
                        width: ResponsiveMediaQuery.horizontalLength * 64,
                      )
                    ],
                  ),
                  SizedBox(
                    width: 300.0,
                    child: Form(
                      key: _key,
                      child: _contenedor(we, he),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ],
        ),
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

  loggedInUI(GoogleSignInController model) {
    String? user;
    print('hola');
    return Column(children: const [
      Text('hola'),
    ]
        /* mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage: Image.network(model.googleAccount!.photoUrl ?? '').image,
          radius: 50,
        ),
      
        Text(model.googleAccount!.displayName ?? ''),
        Text(model.googleAccount!.email),
        ActionChip(
            avatar: const Icon(Icons.logout),
            label: const Text("Logout"),
            onPressed: () {
              Provider.of<GoogleSignInController>(context, listen: false).logOut();
            })
      ],*/
        );
  }

  loginControls(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            child: Image.asset(
              "assets/images/login-google.jpg",
              width: 250,
            ),
            onTap: () async {
              if (mounted) {
                await Provider.of<GoogleSignInController>(context,
                        listen: false)
                    .login();

                //Preferences.usrCorreo = (_currentUser?.email.toString());
                /*  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false); */
              }
            },
          ),
        ],
      ),
    );
  }

  loginUi(BuildContext context) {
    return Consumer<GoogleSignInController>(builder: (context, model, child) {
      if (model.googleAccount != null) {
        setState(() {
          Preferences.usrNombre = _currentUser?.displayName ?? '';
        });
        return const Center();
      } else {
        return loginControls(context);
      }
    });
  }
}

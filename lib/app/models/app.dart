import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/app/clases/cParametros.dart';
import '../clases/cConfig_UI.dart';
import '../pages/public/splash/screens/splashScreen.dart';
import '../providers/internet_provider.dart';

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Todas sus apliaciones deben de estar dentro de Material App para poder
    // hacer uso de las facilidades de Material Design puede omitirce esto pero
    // no podran hacer uso de estos widgets de material.dart
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => InternetProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
        ],
        title: nombre_largo,
        //  theme: Provider.of<ThemeProvider>(context).currentTheme,
        theme: ThemeData(
          fontFamily: 'AvenirNext',
          primaryColor: ColorFondo.PRIMARY,
          appBarTheme: const AppBarTheme(backgroundColor: ColorFondo.PRIMARY),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: const Color.fromRGBO(0, 0, 0, 1.0),
            selectionColor: Colors.blue[50],
            selectionHandleColor: ColorFondo.PRIMARY,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            //filled: true,
            //fillColor: const Color.fromARGB(255, 174, 5, 5).withOpacity(0.5),
            labelStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 1.0)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: ColorFondo.BLANCO,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(13)),
              borderSide: BorderSide(
                color: ColorFondo.BLANCO,
                width: 3.0,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(35)),
              borderSide: BorderSide(
                color: ColorFondo.BLANCO,
                width: 2.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              //borderRadius: BorderRadius.all(Radius.circular(35)),
              borderSide: BorderSide(
                color: ColorFondo.BLANCO,
                width: 3.0,
              ),
            ),
          ),
        ),

        home: const SplashScreen(),
        routes: {
          // ListadoDirItems.routeName: (ctx) => const ListadoDirItems(),
        },
      ),
    );
  }
}

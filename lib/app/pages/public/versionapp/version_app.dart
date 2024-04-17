// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../../../clases/cConfig_UI.dart';

class VersionApp extends StatefulWidget {
  const VersionApp({Key? key}) : super(key: key);
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const VersionApp(),
    );
  }

  @override
  State<VersionApp> createState() => _VersionAppState();
}

class _VersionAppState extends State<VersionApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Nueva Actualización',
              style: TextStyle(color: ColorFondo.BLANCO),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hemos dectectado que existe una nueva actualización",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Porfavor comunicate con la central PowerNet para actualizar a la última versión y recibir mayores beneficios",
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

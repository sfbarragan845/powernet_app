import 'package:powernet/app/api/internas/public/select/api_listado_tecnico.dart';
import 'package:powernet/app/pages/public/soporte/screens/asignar_tecnico.dart';
import 'package:flutter/material.dart';

import '/app/models/var_global.dart' as global;
import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../home/screens/menu.dart';
import '../../recursos/recursos.dart';
import '../widget/contactos.dart';
import '../widget/select_insidente.dart';

class Instalaciones extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => Instalaciones(),
    );
  }

  @override
  _InstalacionesState createState() => _InstalacionesState();
}

class _InstalacionesState extends State<Instalaciones> {
  var suma = 0;

  void mostrarList() {
    for (var i = 0; i < global.listarTecnicos.length; i++) {
      global.MostrarListTecnico[global.listarTecnicos[i]['codigo']] =
          global.listarTecnicos[i]['codigo'] +
              '. ' +
              global.listarTecnicos[i]['tecnicos'];
    }
  }

  final _formKey = GlobalKey<FormState>();
  int _cant = 0;
  String _tipocondicion = 'Select...';
  String _tipoape = 'Select...';
  Color _colorColum1 = Color.fromARGB(255, 255, 255, 255);
  Color _colorColum2 = ColorFondo.BTNUBI;
  String _tipotecnico = 'Seleccionar';
  @override
  void initState() {
    super.initState();
  }

  final _tipoTecnico = [
    'Seleccionar',
    'Bedon Cabezas Jeremy David',
    'Salcedo Chavez Oscar Moises',
    'Toapanta Montero Julio Andres',
  ];
  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Incidentes'),
        backgroundColor: ColorFondo.PRIMARY,
      ),
      drawer: const MenuPrincipal(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /* Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrarSolucion()));
                      },
                      child: Container(
                          width: varWidth * 0.45,
                          height: varHeight * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorFondo.BTNUBI),
                          child: Center(
                            child: Text(
                              'Solucionar'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          listadoTecnico('').then((_) {
                            lisTecnico.then((value) {
                              if (value['success'] == 'OK') {
                                // Preferences.logueado = true;
                                setState(() {});
                              } else if (value['success'] == 'ERROR') {
                                mostrarError(context, value['mensaje']);
                                Preferences.logueado = false;
                              }
                            });
                            // progressDialog.dismiss();
                          });
                        });
                        /*  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Contactos())); */
                      },
                      child: Container(
                          width: varWidth * 0.45,
                          height: varHeight * 0.05,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorFondo.BTNUBI),
                          child: Center(
                            child: Text(
                              'Contactos'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          )),
                    ),
                  ],
                )), 
            Padding(
              padding:
                  const EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0),
              child: Container(
                // width: varWidth,
                height: varHeight * 0.005,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color.fromARGB(5, 161, 161, 161),
                      //Color(0xFF069CDB),
                      Color.fromARGB(255, 131, 131, 131),
                      Color.fromARGB(0, 151, 151, 151),
                    ],
                  ),
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: sombra(
                        Container(
                          width: 360,
                          child: TextField(
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              onChanged: (value) {}, // => _filtro(value),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2, color: Colors.white54)),
                                labelStyle: TextStyle(
                                    color: Color.fromARGB(137, 0, 0, 0)),
                                labelText: 'Busqueda inteligente',
                                suffixIcon:
                                    Icon(Icons.search, color: Colors.white54),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.white54)),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromARGB(255, 161, 161, 161),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      /* Navigator.of(context)
                                        .pushReplacement(SelectInsidencias.route()); */
                    },
                    child: Container(
                      //color: Colors.blue,
                      width: 60,

                      child: Text(
                        'IpRadio',
                        style: TextStyle(fontSize: 14, color: _colorColum1),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* Navigator.of(context)
                                        .pushReplacement(SelectInsidencias.route()); */
                      print('Apellido');
                    },
                    child: Container(
                      width: 65,
                      child: Center(
                          child: Text(
                        'Apellido',
                        style: TextStyle(fontSize: 14, color: _colorColum2),
                        textAlign: TextAlign.center,
                      )),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /* Navigator.of(context)
                                        .pushReplacement(SelectInsidencias.route()); */
                    },
                    child: Container(
                      width: 75,
                      child: Text(
                        'Nombre',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _colorColum1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /*  Navigator.of(context)
                                        .pushReplacement(AsignarTecnicos.route()); */
                    },
                    child: Container(
                      width: 70,
                      child: Text('Asignado',
                          style: TextStyle(
                              color: _colorColum2,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                          textAlign: TextAlign
                              .center) /* Text('Solucionar',style: TextStyle(
                              color: _colorColum2,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)) */
                      ,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                //scrollDirection: Axis.horizontal,
                child: Container(
                  height: 500,
                  child: ListView.separated(
                    itemCount: global.ListadoInstalacion.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      color: Colors.black,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromARGB(255, 242, 146, 34),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectInsidencias()));
                                    /* Navigator.of(context)
                                            .pushReplacement(SelectInsidencias.route()); */
                                  },
                                  child: Container(
                                    //color: Colors.blue,
                                    width: 60,

                                    child: Text(
                                      'Preguntar',
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum1),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectInsidencias()));
                                    print('Valencia Quitnero');
                                  },
                                  child: Container(
                                    width: 65,
                                    child: Center(
                                        child: Text(
                                      'Unir',
                                      style: TextStyle(
                                          fontSize: 14, color: _colorColum2),
                                      textAlign: TextAlign.center,
                                    )),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectInsidencias()));
                                  },
                                  child: Container(
                                    width: 75,
                                    child: Text(
                                      global.ListadoInstalacion[index]
                                          .nombre_comercial,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: _colorColum1),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    listadoTecnico('hola').then((_) {
                                      lisTecnico.then((value) {
                                        print('Prueba API Pedidos');
                                        if (value['success'] == 'OK') {
                                          print(value);
                                          global.tipoRequerimiento =
                                              'Instalacion';
                                          global.listarTecnicos = value['data'];

                                          mostrarList();
                                          print(global.listarTecnicos);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AsignarTecnicos()));
                                        } else if (value['success'] ==
                                            'ERROR') {
                                          mostrarError(
                                              context, value['mensaje']);
                                        }
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 70,
                                    child: Text(global.tipotecnico,
                                        style: TextStyle(
                                            color: _colorColum2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        textAlign: TextAlign.center),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: varWidth,
                              height: varHeight * 0.04,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ColorFondo.BTNUBI,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectInsidencias()));
                                    },
                                    child: Container(
                                      width: varWidth / 2.5,
                                      height: varHeight,
                                      //color: Colors.amber,
                                      child: Center(
                                          child: Text('Detalle',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: varHeight,
                                    color: Color(0xFF808080),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Contactos()));
                                    },
                                    child: Container(
                                      width: varWidth / 2.5,
                                      height: varHeight,
                                      //color: Colors.blueAccent,
                                      child: Center(
                                          child: Text('Contactos',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17))),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

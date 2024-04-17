// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../clases/cConfig_UI.dart';
import '/app/models/var_global.dart' as global;
import 'Datos_GarantiaSeries.dart';

class BuscarSerieInactiva extends StatefulWidget {
  const BuscarSerieInactiva({Key? key}) : super(key: key);
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => BuscarSerieInactiva(),
    );
  }

  @override
  State<BuscarSerieInactiva> createState() => _BuscarSerieInactivaState();
}

class _BuscarSerieInactivaState extends State<BuscarSerieInactiva> {
  bool ifExist = true;
  bool ifExistAdicional = true;
  List<lista_series_garantia> _foundserie = [];
  /* CONSUMO API FILTRO */
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (mounted) {
      setState(() {
        _foundserie = global.Listadogarantias;
      });
    }
  }

  void _filtro(String busqueda) {
    List<lista_series_garantia> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = global.Listadogarantias;
      } else {
        results = global.Listadogarantias.where((evento) {
          Intl.defaultLocale = 'es';
          return evento.serie1
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.codigo
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.serie2
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.serie3
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.nombre_pro
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }

      setState(() {
        this._foundserie = results;
      });
    }
    // print(_foundEvents.length);
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    //final ordersData = Provider.of<PedidosProvider>(context).items;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Verificar Garantia',
          style: TextStyle(
              fontFamily: "Gotik", fontWeight: FontWeight.w600, fontSize: 18.5),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
        backgroundColor: ColorFondo.PRIMARY,
      ),
      body: /*_foundEvents.isEmpty? SkeletonListView(): */
          SingleChildScrollView(
        child: Container(
          width: vwidth,
          height: vheight / 1.05,
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              color: Color.fromARGB(255, 252, 252, 252),
              width: vwidth,
              height: vheight / 1.18,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: vwidth,
                      color: Color.fromARGB(255, 252, 252, 252),
                      child: TextField(
                          style: TextStyle(color: Color.fromARGB(248, 0, 0, 0)),
                          onChanged: (value) => _filtro(value),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Colors.grey.shade400)),
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Buscar',
                            suffixIcon:
                                Icon(Icons.search, color: Colors.white54),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white54)),
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: global.Listadogarantias.isEmpty
                        ? Text('No se han registrado series para este producto',
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0)))
                        : _foundserie.isNotEmpty
                            ? ListView.builder(
                                itemCount: _foundserie.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: vwidth,
                                            height: vheight * 0.13,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 156, 34, 34),
                                                width: 1,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  _foundserie[index]
                                                          .nombre_pro +
                                                      ', Serie :',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  _foundserie[index].serie1,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Estado Garantia: ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    _foundserie[index]
                                                                .garantia_vigente ==
                                                            'SI'
                                                        ? Text(
                                                            'Activa',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            'Inactiva',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Vencimiento Garantía: ',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    _foundserie[index]
                                                                .garantia_vigente ==
                                                            'SI'
                                                        ? Text(
                                                            _foundserie[index]
                                                                .vencimiento_garantia,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : Text(
                                                            _foundserie[index]
                                                                .vencimiento_garantia,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )
                            : const Text(
                                'No results found',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

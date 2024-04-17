// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../../../clases/cParametros.dart';
import '../../../../core/cToken.dart';
import '../../../../models/products/series_productos.dart';
import '../../../../models/share_preferences.dart';
import '/app/models/var_global.dart' as global;

const String banco_datos = "FORM_SERIES";
final String tokenizer_banco = generateMd5(Secret_Token, banco_datos);

class BuscarSerie extends StatefulWidget {
  const BuscarSerie({Key? key}) : super(key: key);
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => BuscarSerie(),
    );
  }

  @override
  State<BuscarSerie> createState() => _BuscarSerieState();
}

class _BuscarSerieState extends State<BuscarSerie> {
  /* CONSUMO API FILTRO */
  List<lista_series> serie = [];
  List<lista_series> _foundserie = [];
  @override
  void initState() {
    super.initState();
    _inition();
  }

  void _inition() {
    if (mounted) {
      tomar_series().then((value) {
        setState(() {
          serie.addAll(value);
        });
        _foundserie = serie;
        //print(_foundserie.toString());
      });
    }
  }

  Future<dynamic> tomar_series() async {
    final url = Uri.parse(
        '$ROOT/app/rest_powernet/productos/producto/api_listado_series_productos.php');
    try {
      final body = {
        "token": tokenizer_banco,
        "id_usuario": Preferences.usrID.toString(),
        "codigo_producto": global.codigo_Serie
      };
      final respose = await http.post(url, body: body);
      print('Hola $url');
      final List<lista_series> registros = [];
      if (respose.statusCode == 200) {
        print(respose.statusCode);
        final data = json.decode(respose.body);
        print(data);
        if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
          final eventos = data['data'] as List<dynamic>;
          for (var eventos in eventos) {
            registros.add(lista_series.fromJson(eventos));
          }
        } else if (data['success'] == 'ERROR' &&
            data['status_code'] == "ERROR_SELECT") {
          //globals.mensaje = data['mensaje'];
        }
        return registros;
      } else {
        print('Error al obtener los proyectos: ${respose.statusCode}');
      }
    } catch (error) {
      print('Error al llamar la API de Proyectos $error');
    }
  }

  void _filtro(String busqueda) {
    List<lista_series> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = serie;
      } else {
        results = serie.where((evento) {
          Intl.defaultLocale = 'es';
          return evento.serie1
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.codigo
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
        centerTitle: true,
        title: Text(
          'Buscar Serie',
          style: TextStyle(
              fontFamily: "Gotik", fontWeight: FontWeight.w600, fontSize: 18.5, color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
        backgroundColor: ColorFondo.PRIMARY,
      ),
      body: /*_foundEvents.isEmpty? SkeletonListView(): */
          Container(
        /* width: vwidth,
            height: vheight / 1.05, */
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(children: [
          Container(
            padding: EdgeInsets.all(8),
            width: vwidth,
            color: Color.fromARGB(255, 252, 252, 252),
            child: TextField(
                style: TextStyle(color: Color.fromARGB(248, 0, 0, 0)),
                onChanged: (value) => _filtro(value),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Colors.grey.shade400)),
                  labelStyle: TextStyle(color: Colors.black),
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search, color: Colors.white54),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54)),
                )),
          ),
          Expanded(
            child: serie.isEmpty
                ? Text('Cargando',
                    style: TextStyle(color: Color.fromARGB(255, 236, 235, 235)))
                : _foundserie.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundserie.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              const SizedBox(height: 15),
                              Center(
                                child: InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: vwidth,
                                        height: vheight * 0.1,
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
                                              global.nombrePro +
                                                  ' ' +
                                                  _foundserie[index].items +
                                                  ', Serie :',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
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
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          );
                        },
                      )
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
          )
        ]),
      ),
    );
  }
}


/*class BuscarBanco extends SearchDelegate<listabank> {
  @override
  // ignore: overridden_fields
  final String searchFieldLabel;

  final List<listabank> lista; //otorga el llenado de lista

  List<listabank> _filter = [];

  BuscarBanco(this.lista, this.searchFieldLabel);


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Info',
        onPressed: () {
          print(lista.length);
          //mostrarAlerta(context, 'Parámetros de búsqueda', 'La búsqueda del producto se la puede realizar mediante el código o nombre.');
        },
        icon: const Icon(Icons.help),
      ),
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
        tooltip: 'Cancelar búsqueda',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(
          context,
          listabank(
            banco: "",
            items: "",
          )),
      tooltip: 'Regresar',
      icon: const Icon(Icons.arrow_back_ios_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _filter.isEmpty
        ? _noExiste()
        : GridView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.229,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              //create: (_) => Proyectos[index],
              value: _filter[index],

              child: const listitenms(),
            ),
            itemCount: _filter.length,
          );
  }

  Widget _noExiste() {
    return ListTile(
      leading: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      title: Text(
        'No existe el Proyecto',
        style: TextStyle(color: Colors.red[600]),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _filter = lista.where((proyecto) {
      return proyecto.banco.toLowerCase().contains(query.trim().toLowerCase()) || proyecto.items.contains(query.trim());
    }).toList();
    return _filter.isEmpty
        ? _noExiste()
        : GridView.builder(
            itemCount: _filter.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 5.9,
              crossAxisSpacing: 10,
              mainAxisSpacing: 1,
            ),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              //create: (_) => Proyectos[index],
              value: _filter[index],

              child: const listitenms(),
            ),
          );
  }
}*/

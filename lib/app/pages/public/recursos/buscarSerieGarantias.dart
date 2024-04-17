// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:powernet/app/pages/public/productos/widgets/buscar_listado_productos.dart';
import 'package:powernet/app/pages/public/registrarSolucionInsta/screens/Solucion_Instalacion.dart';

import '../../../clases/cConfig_UI.dart';
import '../../../clases/cParametros.dart';
import '../../../core/cToken.dart';
import '../../../models/products/listas_prod.dart';
import '../../../models/products/series_prod.dart';
import '../../../models/share_preferences.dart';
import '../../components/mostrar_snack.dart';
import '/app/models/var_global.dart' as global;

const String banco_datos = "FORM_SERIES";
final String tokenizer_banco = generateMd5(Secret_Token, banco_datos);

class BuscarSerieGarantia extends StatefulWidget {
  const BuscarSerieGarantia({Key? key}) : super(key: key);
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => BuscarSerieGarantia(),
    );
  }

  @override
  State<BuscarSerieGarantia> createState() => _BuscarSerieGarantiaState();
}

class _BuscarSerieGarantiaState extends State<BuscarSerieGarantia> {
  bool ifExist = true;
  bool ifExistAdicional = true;
  /* CONSUMO API FILTRO */
  List<lista_seriesProd> serie = [];
  List<lista_seriesProd> _foundserie = [];
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
        '$ROOT/app/rest_powernet/productos/producto/api_listado_series_inactivas_productos.php');
    try {
      final body = {
        "token": tokenizer_banco,
        "id_usuario": Preferences.usrID.toString(),
        "codigo_producto": global.codigo_Serie
      };
      final respose = await http.post(url, body: body);
      print('Hola $url');
      print('Hola $body');
      final List<lista_seriesProd> registros = [];
      if (respose.statusCode == 200) {
        print(respose.statusCode);
        final data = json.decode(respose.body);
        print(data);
        if (data['success'] == 'OK' && data['status_code'] == "SELECT") {
          final eventos = data['data'] as List<dynamic>;
          for (var eventos in eventos) {
            registros.add(lista_seriesProd.fromJson(eventos));
          }
        } else if (data['success'] == 'ERROR' &&
            data['status_code'] == "ERROR_SELECT") {}
        return registros;
      } else {
        print('Error al obtener los proyectos: ${respose.statusCode}');
      }
    } catch (error) {
      print('Error al llamar la API de Proyectos $error');
    }
  }

  void _filtro(String busqueda) {
    List<lista_seriesProd> results = [];
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
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.serie2
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.serie3
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
    //final series_array = Provider.of<Serie_Cod>(context);
    //final ordersData = Provider.of<PedidosProvider>(context).items;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(BuscarProduct.route('NONE'));
          },
        ),
        centerTitle: true,
        title: Text(
          'Series de ' + global.nombrePro,
          style: TextStyle(
              fontFamily: "Gotik", fontWeight: FontWeight.w600, fontSize: 18.5, color :Colors.white),
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
              height: vheight / 1.09,
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
                    child: serie.isEmpty
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
                                        child: InkWell(
                                            onTap: () {
                                              if (global.numAdicioanl == 0) {
                                                //global.nDescuento.add(0);
                                                setState(() {
                                                  if (global.items.isEmpty) {
                                                    global.nTickets.add(1);
                                                    global.nfacturaSiNo
                                                        .add('NO');
                                                    global.nDescuento.add(0);
                                                    global.items
                                                        .add(lista_producto(
                                                      serie: global.seriePro,
                                                      series: global.seriesPro,
                                                      items: global.itemPro,
                                                      codigo: global.codigoPro,
                                                      codigoProducto: global
                                                          .codigoProductoPro,
                                                      nombre: global.nombrePro,
                                                      stock: global.stockPro,
                                                      precio: global.precioPro,
                                                      categoria:
                                                          global.categoriaPro,
                                                      descripcion:
                                                          global.descripcionPro,
                                                      foto: global.fotoPro,
                                                      tipo: global.tipoPro,
                                                      total: double.parse(
                                                          global.precioPro),
                                                    ));
                                                    global.serieProducts.add(
                                                        lista_seriesProd(
                                                            items: _foundserie[
                                                                    index]
                                                                .items,
                                                            codigo: _foundserie[
                                                                    index]
                                                                .codigo,
                                                            serie1: _foundserie[
                                                                    index]
                                                                .serie1,
                                                            serie2: _foundserie[
                                                                    index]
                                                                .serie2,
                                                            serie3: _foundserie[
                                                                    index]
                                                                .serie3,
                                                            estado: _foundserie[
                                                                    index]
                                                                .estado,
                                                            observacion:
                                                                _foundserie[index]
                                                                    .observacion,
                                                            garantia_vigente:
                                                                _foundserie[
                                                                        index]
                                                                    .garantia_vigente));
                                                  } else {
                                                    print(global.items.length);
                                                    for (var i = 1;
                                                        i <=
                                                            global.items.length;
                                                        i++) {
                                                      if (global
                                                              .serieProducts[
                                                                  i - 1]
                                                              .serie1 ==
                                                          _foundserie[index]
                                                              .serie1) {
                                                        print(true);
                                                        ifExist = true;
                                                        break;
                                                      } else {
                                                        print(false);
                                                        ifExist = false;
                                                      }
                                                    }
                                                    if (ifExist == true) {
                                                      mostrarError(context,
                                                          'Producto o Servicio ya existe actualice la cantidad');
                                                    } else {
                                                      global.nTickets.add(1);
                                                      global.nfacturaSiNo
                                                          .add('NO');
                                                      global.nDescuento.add(0);
                                                      global.items
                                                          .add(lista_producto(
                                                        serie: global.seriePro,
                                                        series:
                                                            global.seriesPro,
                                                        items: global.itemPro,
                                                        codigo:
                                                            global.codigoPro,
                                                        codigoProducto: global
                                                            .codigoProductoPro,
                                                        nombre:
                                                            global.nombrePro,
                                                        stock: global.stockPro,
                                                        precio:
                                                            global.precioPro,
                                                        categoria:
                                                            global.categoriaPro,
                                                        descripcion: global
                                                            .descripcionPro,
                                                        foto: global.fotoPro,
                                                        tipo: global.tipoPro,
                                                        total: double.parse(
                                                            global.precioPro),
                                                      ));
                                                      global.serieProducts.add(lista_seriesProd(
                                                          items:
                                                              _foundserie[index]
                                                                  .items,
                                                          codigo:
                                                              _foundserie[index]
                                                                  .codigo,
                                                          serie1:
                                                              _foundserie[index]
                                                                  .serie1,
                                                          serie2:
                                                              _foundserie[index]
                                                                  .serie2,
                                                          serie3:
                                                              _foundserie[index]
                                                                  .serie3,
                                                          estado:
                                                              _foundserie[index]
                                                                  .estado,
                                                          observacion:
                                                              _foundserie[index]
                                                                  .observacion,
                                                          garantia_vigente:
                                                              _foundserie[index]
                                                                  .garantia_vigente));
                                                    }
                                                  }

                                                  print('aqui imprimo' +
                                                      global.items.length
                                                          .toString());
                                                });
                                              } else {
                                                setState(() {
                                                  if (global.itemsAdcionales
                                                      .isEmpty) {
                                                    global.nTicketsAdicionales
                                                        .add(1);
                                                    global.nfacturaSiNoAdicional
                                                        .add('NO');
                                                    global.nDescuentoAdicional
                                                        .add(0);
                                                    global.itemsAdcionales
                                                        .add(lista_producto(
                                                      serie: global.seriePro,
                                                      series: global.seriesPro,
                                                      items: global.itemPro,
                                                      codigo: global.codigoPro,
                                                      codigoProducto: global
                                                          .codigoProductoPro,
                                                      nombre: global.nombrePro,
                                                      stock: global.stockPro,
                                                      precio: global.precioPro,
                                                      categoria:
                                                          global.categoriaPro,
                                                      descripcion:
                                                          global.descripcionPro,
                                                      foto: global.fotoPro,
                                                      tipo: global.tipoPro,
                                                      total: double.parse(
                                                          global.precioPro),
                                                    ));
                                                    global.serieProductsAdicional
                                                        .add(lista_seriesProd(
                                                            items: _foundserie[
                                                                    index]
                                                                .items,
                                                            codigo: _foundserie[
                                                                    index]
                                                                .codigo,
                                                            serie1: _foundserie[
                                                                    index]
                                                                .serie1,
                                                            serie2:
                                                                _foundserie[index]
                                                                    .serie2,
                                                            serie3: _foundserie[index]
                                                                .serie3,
                                                            estado: _foundserie[
                                                                    index]
                                                                .estado,
                                                            observacion:
                                                                _foundserie[
                                                                        index]
                                                                    .observacion,
                                                            garantia_vigente:
                                                                _foundserie[
                                                                        index]
                                                                    .garantia_vigente));
                                                  } else {
                                                    print(global.itemsAdcionales
                                                        .length);
                                                    for (var i = 1;
                                                        i <=
                                                            global
                                                                .itemsAdcionales
                                                                .length;
                                                        i++) {
                                                      if (global
                                                              .serieProductsAdicional[
                                                                  i - 1]
                                                              .serie1 ==
                                                          _foundserie[index]
                                                              .serie1) {
                                                        print(true);
                                                        ifExistAdicional = true;
                                                        break;
                                                      } else {
                                                        print(false);
                                                        ifExistAdicional =
                                                            false;
                                                      }
                                                    }
                                                    for (var i = 1;
                                                        i <=
                                                            global.items.length;
                                                        i++) {
                                                      if (global
                                                              .serieProducts[
                                                                  i - 1]
                                                              .serie1 ==
                                                          _foundserie[index]
                                                              .serie1) {
                                                        print(true);
                                                        ifExist = true;
                                                        break;
                                                      } else {
                                                        print(false);
                                                        ifExist = false;
                                                      }
                                                    }
                                                    if (ifExistAdicional ==
                                                        true) {
                                                      mostrarError(context,
                                                          'Producto o Servicio ya existe actualice la cantidad');
                                                    } else if (ifExist ==
                                                        true) {
                                                      mostrarError(context,
                                                          'Producto o Servicio ya insertado');
                                                    } else {
                                                      global.nDescuentoAdicional
                                                          .add(0);
                                                      global.nTicketsAdicionales
                                                          .add(1);
                                                      global
                                                          .nfacturaSiNoAdicional
                                                          .add(global
                                                              .nFactProduct);
                                                      global.itemsAdcionales
                                                          .add(lista_producto(
                                                        serie: global.seriePro,
                                                        series:
                                                            global.seriesPro,
                                                        items: global.itemPro,
                                                        codigo:
                                                            global.codigoPro,
                                                        codigoProducto: global
                                                            .codigoProductoPro,
                                                        nombre:
                                                            global.nombrePro,
                                                        stock: global.stockPro,
                                                        precio:
                                                            global.precioPro,
                                                        categoria:
                                                            global.categoriaPro,
                                                        descripcion: global
                                                            .descripcionPro,
                                                        foto: global.fotoPro,
                                                        tipo: global.tipoPro,
                                                        total: double.parse(
                                                            global.precioPro),
                                                      ));
                                                      global.serieProductsAdicional
                                                          .add(lista_seriesProd(
                                                              items: _foundserie[
                                                                      index]
                                                                  .items,
                                                              codigo: _foundserie[
                                                                      index]
                                                                  .codigo,
                                                              serie1:
                                                                  _foundserie[
                                                                          index]
                                                                      .serie1,
                                                              serie2:
                                                                  _foundserie[
                                                                          index]
                                                                      .serie2,
                                                              serie3:
                                                                  _foundserie[
                                                                          index]
                                                                      .serie3,
                                                              estado:
                                                                  _foundserie[
                                                                          index]
                                                                      .estado,
                                                              observacion:
                                                                  _foundserie[
                                                                          index]
                                                                      .observacion,
                                                              garantia_vigente:
                                                                  _foundserie[
                                                                          index]
                                                                      .garantia_vigente));
                                                    }
                                                  }

                                                  print('aqui imprimo' +
                                                      global.items.length
                                                          .toString());
                                                });
                                              }
                                              setState(() {
                                                global.deleteImg = false;
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      RegistrarInstalacion
                                                          .route());
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                          _foundserie[index]
                                                              .items +
                                                          ', Serie :',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                    Text(
                                                      _foundserie[index].serie1,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'Estado Garantia: ',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
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
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                      ],
                                                    )
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
                                style: TextStyle(
                                    fontSize: 24, color: Colors.white),
                              ),
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

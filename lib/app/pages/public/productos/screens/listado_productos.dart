import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:powernet/app/models/products/listas_prod.dart';
import 'package:powernet/app/pages/public/productos/screens/buscarSerie.dart';

import '../../../../api/internas/public/select/products/api_listado_productos_bodega.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../models/share_preferences.dart';
import '/app/models/var_global.dart' as global;

class ListadoProduct extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => ListadoProduct(),
    );
  }

  const ListadoProduct({Key? key}) : super(key: key);
  @override
  State<ListadoProduct> createState() => _ListadoProductState();
}

class _ListadoProductState extends State<ListadoProduct> {
  bool ifExist = true;
  String hola = Preferences.serie;
  /* CONSUMO API FILTRO */
  List<lista_producto> products = [];
  List<lista_producto> _foundProducts = [];

  @override
  void initState() {
    super.initState();
    _inition();
  }

  void _inition() {
    if (mounted) {
      list_products_bodega().then((value) {
        setState(() {
          products.addAll(value);
        });
        _foundProducts = products;
      });
    }
  }

  void _filtro(String busqueda) {
    List<lista_producto> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = products;
      } else {
        results = products.where((evento) {
          Intl.defaultLocale = 'es';
          return evento.nombre
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString()) ||
              evento.tipo
                  .toLowerCase()
                  .contains(busqueda.toLowerCase().toString());
        }).toList();
      }

      setState(() {
        this._foundProducts = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color:Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Listado de productos',style:TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: ColorFondo.PRIMARY,
      ),
      body: Container(
        /* width: vwidth,
        height: vheight, */
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(children: [
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            width: vwidth,
            height: vheight * 0.9,
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
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Container(
                    width: vwidth,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Descripción',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Stock         ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'Precio',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          )
                        ]),
                  ),
                ),
                Expanded(
                  child: products.isEmpty
                      ? Text('Cargando',
                          style: TextStyle(
                              color: Color.fromARGB(255, 236, 235, 235)))
                      : _foundProducts.isNotEmpty
                          ? ListView.builder(
                              itemCount: _foundProducts.length,
                              itemBuilder: (context, index) {
                                return SingleChildScrollView(
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      const SizedBox(height: 15),
                                      Center(
                                        child: InkWell(
                                            onTap: () async {},
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: vwidth,
                                                //height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                  border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 156, 38, 38),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        _foundProducts[index]
                                                                    .serie ==
                                                                'SI'
                                                            ? Container(
                                                                width:
                                                                    vwidth /
                                                                        1.2,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(right: 5),
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              80,
                                                                          child: _foundProducts[index].tipo == 'PRODUCTO'
                                                                              ? SvgPicture.asset('assets/images/product_icon.svg')
                                                                              : SvgPicture.asset('assets/images/service_icon.svg'),
                                                                        ),
                                                                        Container(
                                                                            width: 90,
                                                                            child: Text(
                                                                              _foundProducts[index].nombre,
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                        Container(
                                                                            width: 90,
                                                                            child: Text(
                                                                              _foundProducts[index].stock,
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                        Container(
                                                                            width: 80,
                                                                            child: Text(
                                                                              '\$ ${_foundProducts[index].precio}',
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                    Visibility(
                                                                      visible: _foundProducts[index].serie ==
                                                                              'SI'
                                                                          ? true
                                                                          : false,
                                                                      child:
                                                                          Card(
                                                                        elevation:
                                                                            3.0,
                                                                        margin:
                                                                            const EdgeInsets.all(10.0),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 8.8),
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color: ColorFondo.SECONDARY,
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(5.0),
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              ListTile(
                                                                            onTap: () async {
                                                                              setState(() {
                                                                                global.seriePro = _foundProducts[index].serie;
                                                                                global.seriesPro = _foundProducts[index].series;
                                                                                global.itemPro = _foundProducts[index].items;
                                                                                global.codigoPro = _foundProducts[index].codigo;
                                                                                global.codigoProductoPro = _foundProducts[index].codigoProducto;
                                                                                global.nombrePro = _foundProducts[index].nombre;
                                                                                global.stockPro = _foundProducts[index].stock;
                                                                                global.precioPro = _foundProducts[index].precio;
                                                                                global.categoriaPro = _foundProducts[index].categoria;
                                                                                global.descripcionPro = _foundProducts[index].descripcion;
                                                                                global.fotoPro = _foundProducts[index].foto;
                                                                                global.tipoPro = _foundProducts[index].tipo;
                                                                                global.totalPro = double.parse(_foundProducts[index].precio);
                                                                              });
                                                                              setState(() {
                                                                                global.codigo_Serie = _foundProducts[index].codigo;
                                                                              });
                                                                              Navigator.of(context).push(BuscarSerie.route());
                                                                            },
                                                                            title: Text('Seleccionar serie'),
                                                                            trailing: Icon(Icons.arrow_drop_down),
                                                                            iconColor: ColorFondo.PRIMARY,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ))
                                                            : Container(
                                                                width: 315,
                                                                height: 80,
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment.spaceAround,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment.center,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.only(right: 5),
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              80,
                                                                          child: _foundProducts[index].tipo == 'PRODUCTO'
                                                                              ? SvgPicture.asset('assets/images/product_icon.svg')
                                                                              : SvgPicture.asset('assets/images/service_icon.svg'),
                                                                        ),
                                                                        Container(
                                                                            width: 90,
                                                                            child: Text(
                                                                              _foundProducts[index].nombre,
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                        Container(
                                                                            width: 90,
                                                                            child: Text(
                                                                              _foundProducts[index].stock,
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                        Container(
                                                                            width: 80,
                                                                            child: Text(
                                                                              '\$ ${_foundProducts[index].precio}',
                                                                              textAlign: TextAlign.center,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ),
                                    ],
                                  )),
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
    );
  }
}

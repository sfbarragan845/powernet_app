// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:powernet/app/api/internas/public/select/products/api_listado_productos.dart';
import 'package:powernet/app/models/products/listas_prod.dart';
import 'package:powernet/app/pages/components/mostrar_snack.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../../../models/products/series_prod.dart';
import '../../registrarSolucion/screens/registrar_solucion.dart';
import '../../registrarSolucionInsta/screens/Solucion_Instalacion.dart';
import '../../registrarSolucionMigracion/screens/Solucion_Migracion.dart';
import '../../registrarSolucionTraslados/screens/Solucion_Traslado.dart';
import '/app/models/var_global.dart' as global;
import 'buscarSerieProduct.dart';

class BuscarProduct extends StatefulWidget {
  final String type; // Add your new parameter here

  static Route<dynamic> route(String type) {
    return MaterialPageRoute(
      builder: (context) => BuscarProduct(type: type),
    );
  }

  const BuscarProduct({Key? key, required this.type}) : super(key: key);

  @override
  State<BuscarProduct> createState() => _BuscarProductState();
}

class _BuscarProductState extends State<BuscarProduct> {
  bool ifExist = true;
  bool ifExistAdicioanl = true;

  /* CONSUMO API FILTRO */
  List<lista_producto> productos = [];
  List<lista_producto> _foundProductos = [];
  @override
  void initState() {
    super.initState();
    _inition();
  }

  void _inition() {
    if (mounted) {
      list_products().then((value) {
        setState(() {
          productos.addAll(value);
        });
        _foundProductos = productos;
      });
    }
  }

  void _filtro(String busqueda) {
    List<lista_producto> results = [];
    if (mounted) {
      if (busqueda.isEmpty) {
        results = productos;
      } else {
        results = productos.where((evento) {
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
        this._foundProductos = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              global.deleteImg = false;
            });
            switch (widget.type) {
              case 'SUPPORT':
                Navigator.of(context)
                    .pushReplacement(RegistrarSolucion.route());
                break;
              case 'INSTALATION':
                Navigator.of(context)
                    .pushReplacement(RegistrarInstalacion.route());
                break;
              case 'MIGRATION':
                Navigator.of(context)
                    .pushReplacement(RegistrarMigracion.route());
                break;
              case 'TRANSFER':
                Navigator.of(context)
                    .pushReplacement(RegistrarTraslados.route());
                break;
            }
          },
        ),
        centerTitle: true,
        title: Text(
          'Buscar Productos o Servicios',
          style: TextStyle(
              fontFamily: "Gotik",
              fontWeight: FontWeight.w600,
              fontSize: 18.5,
              color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0.0,
        backgroundColor: ColorFondo.PRIMARY,
      ),
      body: WillPopScope(
        onWillPop: () async {
          switch (widget.type) {
            case 'SUPPORT':
              Navigator.of(context).pushReplacement(RegistrarSolucion.route());
              break;
            case 'INSTALATION':
              Navigator.of(context)
                  .pushReplacement(RegistrarInstalacion.route());
              break;
            case 'MIGRATION':
              Navigator.of(context).pushReplacement(RegistrarMigracion.route());
              break;
            case 'TRANSFER':
              Navigator.of(context).pushReplacement(RegistrarTraslados.route());
              break;
          }
          return true;
        },
        child: SingleChildScrollView(
          child: Container(
            width: vwidth,
            height: vheight,
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(children: [
              const SizedBox(
                height: 20,
              ),
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
                            style:
                                TextStyle(color: Color.fromARGB(248, 0, 0, 0)),
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
                                  borderSide:
                                      BorderSide(color: Colors.white54)),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, bottom: 15),
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
                      child: productos.isEmpty
                          ? Text('No se han asignado productos',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 236, 235, 235)))
                          : _foundProductos.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _foundProductos.length,
                                  itemBuilder: (context, index) {
                                    return SingleChildScrollView(
                                        child: Column(
                                      children: [
                                        Center(
                                          child: InkWell(
                                              onTap:
                                                  _foundProductos[index]
                                                              .serie ==
                                                          'NO'
                                                      ? () async {
                                                          print(_foundProductos[
                                                                  index]
                                                              .categoria);
                                                          print(_foundProductos[
                                                                  index]
                                                              .tipo);
                                                          setState(() {
                                                            global.seriePro =
                                                                _foundProductos[
                                                                        index]
                                                                    .serie;
                                                            global.seriesPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .series;
                                                            global.itemPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .items;
                                                            global.codigoPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .codigo;
                                                            global.codigoProductoPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .codigoProducto;
                                                            global.nombrePro =
                                                                _foundProductos[
                                                                        index]
                                                                    .nombre;
                                                            global.stockPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .stock;
                                                            global.precioPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .precio;
                                                            global.categoriaPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .categoria;
                                                            global.descripcionPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .descripcion;
                                                            global.fotoPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .foto;
                                                            global.tipoPro =
                                                                _foundProductos[
                                                                        index]
                                                                    .tipo;
                                                            global.totalPro =
                                                                double.parse(
                                                                    _foundProductos[
                                                                            index]
                                                                        .precio);
                                                          });

                                                          if (global
                                                                  .numAdicioanl ==
                                                              0) {
                                                            setState(() {
                                                              if (global.items
                                                                  .isEmpty) {
                                                                if (int.parse(_foundProductos[index]
                                                                            .stock) ==
                                                                        0 &&
                                                                    _foundProductos[index]
                                                                            .tipo ==
                                                                        'PRODUCTO') {
                                                                  mostrarError(
                                                                      context,
                                                                      'Producto sin existencias');
                                                                } else {
                                                                  global.items.add(
                                                                      lista_producto(
                                                                    serie: _foundProductos[
                                                                            index]
                                                                        .serie,
                                                                    series: _foundProductos[
                                                                            index]
                                                                        .series,
                                                                    items: _foundProductos[
                                                                            index]
                                                                        .items,
                                                                    codigo: _foundProductos[
                                                                            index]
                                                                        .codigo,
                                                                    codigoProducto:
                                                                        _foundProductos[index]
                                                                            .codigoProducto,
                                                                    nombre: _foundProductos[
                                                                            index]
                                                                        .nombre,
                                                                    stock: _foundProductos[
                                                                            index]
                                                                        .stock,
                                                                    precio: _foundProductos[
                                                                            index]
                                                                        .precio,
                                                                    categoria: _foundProductos[
                                                                            index]
                                                                        .categoria,
                                                                    descripcion:
                                                                        _foundProductos[index]
                                                                            .descripcion,
                                                                    foto: _foundProductos[
                                                                            index]
                                                                        .foto,
                                                                    tipo: _foundProductos[
                                                                            index]
                                                                        .tipo,
                                                                    total: double.parse(
                                                                        _foundProductos[index]
                                                                            .precio),
                                                                  ));
                                                                  global.serieProducts.add(lista_seriesProd(
                                                                      items:
                                                                          'SN',
                                                                      codigo:
                                                                          'SN',
                                                                      serie1:
                                                                          'SN',
                                                                      serie2:
                                                                          'SN',
                                                                      serie3:
                                                                          'SN',
                                                                      estado:
                                                                          'SN',
                                                                      observacion:
                                                                          'SN',
                                                                      garantia_vigente:
                                                                          'NO'));
                                                                  global
                                                                      .nTickets
                                                                      .add(1);
                                                                  if (global.tipocondicion ==
                                                                          'No Procedente' ||
                                                                      global.tipocondicion ==
                                                                          'Averia') {
                                                                    global
                                                                        .nfacturaSiNo
                                                                        .add(
                                                                            'SI');
                                                                  } else {
                                                                    global
                                                                        .nfacturaSiNo
                                                                        .add(
                                                                            'NO');
                                                                  }

                                                                  global
                                                                      .nDescuento
                                                                      .add(0);
                                                                }
                                                              } else {
                                                                print(global
                                                                    .items
                                                                    .length);
                                                                if (int.parse(_foundProductos[index]
                                                                            .stock) ==
                                                                        0 &&
                                                                    _foundProductos[index]
                                                                            .tipo ==
                                                                        'PRODUCTO') {
                                                                  mostrarError(
                                                                      context,
                                                                      'Producto sin existencias');
                                                                } else {
                                                                  for (var i =
                                                                          1;
                                                                      i <=
                                                                          global
                                                                              .items
                                                                              .length;
                                                                      i++) {
                                                                    print(
                                                                        'paso');
                                                                    if (global
                                                                            .items[i -
                                                                                1]
                                                                            .codigo ==
                                                                        _foundProductos[index]
                                                                            .codigo) {
                                                                      print(global
                                                                          .items[i -
                                                                              1]
                                                                          .codigo);
                                                                      print(
                                                                          'paso2');

                                                                      print(_foundProductos[
                                                                              index]
                                                                          .codigo);
                                                                      print(
                                                                          true);
                                                                      ifExist =
                                                                          true;
                                                                      break;
                                                                    } else {
                                                                      print(
                                                                          false);
                                                                      ifExist =
                                                                          false;
                                                                    }
                                                                  }
                                                                  if (ifExist ==
                                                                      true) {
                                                                    mostrarError(
                                                                        context,
                                                                        'Producto o Servicio ya existe actualice la cantidad');
                                                                  } else {
                                                                    global
                                                                        .nDescuento
                                                                        .add(0);
                                                                    global
                                                                        .nTickets
                                                                        .add(1);
                                                                    if (global.tipocondicion ==
                                                                            'No Procedente' ||
                                                                        global.tipocondicion ==
                                                                            'Averia') {
                                                                      global
                                                                          .nfacturaSiNo
                                                                          .add(
                                                                              'SI');
                                                                    } else {
                                                                      global
                                                                          .nfacturaSiNo
                                                                          .add(
                                                                              'NO');
                                                                    }
                                                                    global.items
                                                                        .add(
                                                                            lista_producto(
                                                                      serie: _foundProductos[
                                                                              index]
                                                                          .serie,
                                                                      series: _foundProductos[
                                                                              index]
                                                                          .series,
                                                                      items: _foundProductos[
                                                                              index]
                                                                          .items,
                                                                      codigo: _foundProductos[
                                                                              index]
                                                                          .codigo,
                                                                      codigoProducto:
                                                                          _foundProductos[index]
                                                                              .codigoProducto,
                                                                      nombre: _foundProductos[
                                                                              index]
                                                                          .nombre,
                                                                      stock: _foundProductos[
                                                                              index]
                                                                          .stock,
                                                                      precio: _foundProductos[
                                                                              index]
                                                                          .precio,
                                                                      categoria:
                                                                          _foundProductos[index]
                                                                              .categoria,
                                                                      descripcion:
                                                                          _foundProductos[index]
                                                                              .descripcion,
                                                                      foto: _foundProductos[
                                                                              index]
                                                                          .foto,
                                                                      tipo: _foundProductos[
                                                                              index]
                                                                          .tipo,
                                                                      total: double.parse(
                                                                          _foundProductos[index]
                                                                              .precio),
                                                                    ));
                                                                    global.serieProducts.add(lista_seriesProd(
                                                                        items:
                                                                            'SN',
                                                                        codigo:
                                                                            'SN',
                                                                        serie1:
                                                                            'SN',
                                                                        serie2:
                                                                            'SN',
                                                                        serie3:
                                                                            'SN',
                                                                        estado:
                                                                            'SN',
                                                                        observacion:
                                                                            'SN',
                                                                        garantia_vigente:
                                                                            'NO'));
                                                                  }
                                                                }
                                                              }

                                                              print('aqui imprimo' +
                                                                  global.items
                                                                      .length
                                                                      .toString());

                                                              setState(() {
                                                                global.deleteImg =
                                                                    false;
                                                              });

                                                              switch (
                                                                  widget.type) {
                                                                case 'SUPPORT':
                                                                  supportSolution(
                                                                      index);
                                                                  break;
                                                                case 'INSTALATION':
                                                                  instalationSolution(
                                                                      index);
                                                                  break;
                                                                case 'MIGRATION':
                                                                  migrationSolution(
                                                                      index);
                                                                  break;
                                                                case 'TRANSFER':
                                                                  transferSolution(
                                                                      index);
                                                                  break;
                                                              }
                                                            });
                                                          } else {
                                                            if (_foundProductos[
                                                                        index]
                                                                    .serie ==
                                                                'NO') {
                                                              if (int.parse(_foundProductos[
                                                                              index]
                                                                          .stock) ==
                                                                      0 &&
                                                                  _foundProductos[
                                                                              index]
                                                                          .tipo ==
                                                                      'PRODUCTO') {
                                                                mostrarError(
                                                                    context,
                                                                    'Producto sin existencias');
                                                              } else {
                                                                setState(() {
                                                                  if (global
                                                                      .itemsAdcionales
                                                                      .isEmpty) {
                                                                    global
                                                                        .itemsAdcionales
                                                                        .add(
                                                                            lista_producto(
                                                                      serie: _foundProductos[
                                                                              index]
                                                                          .serie,
                                                                      series: _foundProductos[
                                                                              index]
                                                                          .series,
                                                                      items: _foundProductos[
                                                                              index]
                                                                          .items,
                                                                      codigo: _foundProductos[
                                                                              index]
                                                                          .codigo,
                                                                      codigoProducto:
                                                                          _foundProductos[index]
                                                                              .codigoProducto,
                                                                      nombre: _foundProductos[
                                                                              index]
                                                                          .nombre,
                                                                      stock: _foundProductos[
                                                                              index]
                                                                          .stock,
                                                                      precio: _foundProductos[
                                                                              index]
                                                                          .precio,
                                                                      categoria:
                                                                          _foundProductos[index]
                                                                              .categoria,
                                                                      descripcion:
                                                                          _foundProductos[index]
                                                                              .descripcion,
                                                                      foto: _foundProductos[
                                                                              index]
                                                                          .foto,
                                                                      tipo: _foundProductos[
                                                                              index]
                                                                          .tipo,
                                                                      total: double.parse(
                                                                          _foundProductos[index]
                                                                              .precio),
                                                                    ));
                                                                    global.serieProductsAdicional.add(lista_seriesProd(
                                                                        items:
                                                                            'SN',
                                                                        codigo:
                                                                            'SN',
                                                                        serie1:
                                                                            'SN',
                                                                        serie2:
                                                                            'SN',
                                                                        serie3:
                                                                            'SN',
                                                                        estado:
                                                                            'SN',
                                                                        observacion:
                                                                            'SN',
                                                                        garantia_vigente:
                                                                            'NO'));
                                                                    global
                                                                        .nTicketsAdicionales
                                                                        .add(1);
                                                                    global
                                                                        .nfacturaSiNoAdicional
                                                                        .add(global
                                                                            .nFactProduct);
                                                                    global
                                                                        .nDescuentoAdicional
                                                                        .add(0);
                                                                  } else {
                                                                    print(global
                                                                        .itemsAdcionales
                                                                        .length);
                                                                    for (var i =
                                                                            1;
                                                                        i <=
                                                                            global.itemsAdcionales.length;
                                                                        i++) {
                                                                      if (global
                                                                              .itemsAdcionales[i -
                                                                                  1]
                                                                              .codigo ==
                                                                          _foundProductos[index]
                                                                              .codigo) {
                                                                        print(
                                                                            true);
                                                                        ifExistAdicioanl =
                                                                            true;
                                                                        break;
                                                                      } else {
                                                                        print(
                                                                            false);
                                                                        ifExistAdicioanl =
                                                                            false;
                                                                      }
                                                                    }
                                                                    if (ifExistAdicioanl ==
                                                                        true) {
                                                                      mostrarError(
                                                                          context,
                                                                          'Producto o Servicio ya existe actualice la cantidad');
                                                                    } else {
                                                                      global
                                                                          .nDescuentoAdicional
                                                                          .add(
                                                                              0);
                                                                      global
                                                                          .nTicketsAdicionales
                                                                          .add(
                                                                              1);
                                                                      global
                                                                          .nfacturaSiNoAdicional
                                                                          .add(global
                                                                              .nFactProduct);

                                                                      global
                                                                          .itemsAdcionales
                                                                          .add(
                                                                              lista_producto(
                                                                        serie: _foundProductos[index]
                                                                            .serie,
                                                                        series:
                                                                            _foundProductos[index].series,
                                                                        items: _foundProductos[index]
                                                                            .items,
                                                                        codigo:
                                                                            _foundProductos[index].codigo,
                                                                        codigoProducto:
                                                                            _foundProductos[index].codigoProducto,
                                                                        nombre:
                                                                            _foundProductos[index].nombre,
                                                                        stock: _foundProductos[index]
                                                                            .stock,
                                                                        precio:
                                                                            _foundProductos[index].precio,
                                                                        categoria:
                                                                            _foundProductos[index].categoria,
                                                                        descripcion:
                                                                            _foundProductos[index].descripcion,
                                                                        foto: _foundProductos[index]
                                                                            .foto,
                                                                        tipo: _foundProductos[index]
                                                                            .tipo,
                                                                        total: double.parse(
                                                                            _foundProductos[index].precio),
                                                                      ));
                                                                      global.serieProductsAdicional.add(lista_seriesProd(
                                                                          items:
                                                                              'SN',
                                                                          codigo:
                                                                              'SN',
                                                                          serie1:
                                                                              'SN',
                                                                          serie2:
                                                                              'SN',
                                                                          serie3:
                                                                              'SN',
                                                                          estado:
                                                                              'SN',
                                                                          observacion:
                                                                              'SN',
                                                                          garantia_vigente:
                                                                              'NO'));
                                                                    }
                                                                  }

                                                                  print('aqui imprimo' +
                                                                      global
                                                                          .itemsAdcionales
                                                                          .length
                                                                          .toString());
                                                                });
                                                              }
                                                            }

                                                            setState(() {
                                                              global.deleteImg =
                                                                  false;
                                                            });

                                                            switch (
                                                                widget.type) {
                                                              case 'SUPPORT':
                                                                supportSolution(
                                                                    index);
                                                                break;
                                                              case 'INSTALATION':
                                                                instalationSolution(
                                                                    index);
                                                                break;
                                                              case 'MIGRATION':
                                                                migrationSolution(
                                                                    index);
                                                                break;
                                                              case 'TRANSFER':
                                                                transferSolution(
                                                                    index);
                                                                break;
                                                            }
                                                          }
                                                        }
                                                      : null,
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
                                                          _foundProductos[index]
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
                                                                            child: _foundProductos[index].tipo == 'PRODUCTO'
                                                                                ? SvgPicture.asset('assets/images/product_icon.svg')
                                                                                : SvgPicture.asset('assets/images/service_icon.svg'),
                                                                          ),
                                                                          Container(
                                                                              width: 90,
                                                                              child: Text(
                                                                                _foundProductos[index].nombre,
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          Container(
                                                                              width: 90,
                                                                              child: Text(
                                                                                _foundProductos[index].stock,
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          Container(
                                                                              width: 80,
                                                                              child: Text(
                                                                                '\$ ${_foundProductos[index].precio}',
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                        ],
                                                                      ),
                                                                      Visibility(
                                                                        visible: _foundProductos[index].serie ==
                                                                                'SI'
                                                                            ? true
                                                                            : false,
                                                                        child:
                                                                            Card(
                                                                          elevation:
                                                                              3.0,
                                                                          margin: const EdgeInsets
                                                                              .only(
                                                                              left: 10.0,
                                                                              right: 10,
                                                                              bottom: 10),
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
                                                                                  global.seriePro = _foundProductos[index].serie;
                                                                                  global.seriesPro = _foundProductos[index].series;
                                                                                  global.itemPro = _foundProductos[index].items;
                                                                                  global.codigoPro = _foundProductos[index].codigo;
                                                                                  global.codigoProductoPro = _foundProductos[index].codigoProducto;
                                                                                  global.nombrePro = _foundProductos[index].nombre;
                                                                                  global.stockPro = _foundProductos[index].stock;
                                                                                  global.precioPro = _foundProductos[index].precio;
                                                                                  global.categoriaPro = _foundProductos[index].categoria;
                                                                                  global.descripcionPro = _foundProductos[index].descripcion;
                                                                                  global.fotoPro = _foundProductos[index].foto;
                                                                                  global.tipoPro = _foundProductos[index].tipo;
                                                                                  global.totalPro = double.parse(_foundProductos[index].precio);
                                                                                });
                                                                                setState(() {
                                                                                  global.codigo_Serie = _foundProductos[index].codigo;
                                                                                });
                                                                                Navigator.of(context).pushReplacement(BuscarSerieProd.route(widget.type));
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
                                                                  width: 320,
                                                                  //height: 80,
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
                                                                            child: _foundProductos[index].tipo == 'PRODUCTO'
                                                                                ? SvgPicture.asset(
                                                                                    'assets/images/product_icon.svg',
                                                                                    fit: BoxFit.contain,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    'assets/images/service_icon.svg',
                                                                                    fit: BoxFit.contain,
                                                                                  ),
                                                                          ),
                                                                          Container(
                                                                              // color: Colors.amberAccent,
                                                                              width: 90,
                                                                              child: Text(
                                                                                _foundProductos[index].nombre,
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          Container(
                                                                              // color: Colors.blue,
                                                                              width: 90,
                                                                              child: Text(
                                                                                _foundProductos[index].stock,
                                                                                textAlign: TextAlign.center,
                                                                              )),
                                                                          Container(
                                                                              width: 80,
                                                                              child: Text(
                                                                                '\$ ${_foundProductos[index].precio}',
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
                                        const SizedBox(height: 15),
                                      ],
                                    ));
                                  },
                                )
                              : const Text(
                                  'No results found',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.white),
                                ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  void supportSolution(index) {
    if (_foundProductos[index].serie == 'NO') {
      Navigator.of(context).pushReplacement(RegistrarSolucion.route());
    }
  }

  void instalationSolution(index) {
    if (_foundProductos[index].serie == 'NO') {
      Navigator.of(context).pushReplacement(RegistrarInstalacion.route());
    }
  }

  void migrationSolution(index) {
    if (_foundProductos[index].serie == 'NO') {
      Navigator.of(context).pushReplacement(RegistrarMigracion.route());
    }
  }

  void transferSolution(index) {
    if (_foundProductos[index].serie == 'NO') {
      Navigator.of(context).pushReplacement(RegistrarTraslados.route());
    }
  }
}

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:powernet/app/api/internas/public/insert/support/api_factura_pendiente_Soporte.dart';
import 'package:powernet/app/api/internas/public/insert/support/api_facturar_Soporte.dart';
import 'package:powernet/app/api/internas/public/select/api_listado_serie_Inactiva.dart';
import 'package:powernet/app/models/pdf/producto_Pdf.dart';
import 'package:powernet/app/pages/public/productos/widgets/buscar_listado_productos.dart';
import 'package:powernet/app/pages/public/recursos/recursos.dart';

import '../../../../clases/cConfig_UI.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../actionScreens/action_screens.dart';
import '../../report_pdf/screens/pdf_screenIncidente.dart';
import '../../soporte/widgets/buscarSerieGarantia.dart';
import '/app/models/var_global.dart' as global;

class Productos {
  //final int num;
  final String nombre_serie;
  final int cant;
  final int desc;
  final String nombre_producto;
  final int codigo_serie;
  final int codigo;
  final String facturar;
  final String tipo;
  final String serie_producto;

  Productos({
    //required this.num,
    required this.nombre_serie,
    required this.cant,
    required this.desc,
    required this.nombre_producto,
    required this.codigo_serie,
    required this.codigo,
    required this.facturar,
    required this.tipo,
    required this.serie_producto,
  });
  @override
  toString() =>
      '{"codigo_producto":"$codigo","nombre_producto":"$nombre_producto","cantidad":"$cant","porcentaje_descuento":"$desc","facturar":"$facturar","tipo":"$tipo","serie_producto":"$serie_producto","codigo_serie":"$codigo_serie","nombre_serie":"$nombre_serie"}';
}

class RegistrarSolucion extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => RegistrarSolucion(),
    );
  }

  @override
  _RegistrarSolucionState createState() => _RegistrarSolucionState();
}

class _RegistrarSolucionState extends State<RegistrarSolucion> {
  Position? _currentPosition;
  List<Productos> items = [];
  List<Productos> itemsAdicionales = [];
  var suma = 0;
  final solucionController =
      TextEditingController(text: global.detalleSoluSoporte);
  final razonSinSoporteController = TextEditingController();
  final retiraProductosController =
      TextEditingController(text: global.detalleEquiposRetirados);
  final facturaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final txtCant = TextEditingController();
  final txtCantProd = TextEditingController();
  String facturarSiNo = 'SI';

  String? latitude = '';
  String? longitude = '';
  bool buttonEnabled = true;
  final _tipoCondicion = [
    'Seleccionar',
    'Procedente',
    'No Procedente',
    'Averia'
  ];

  final _tipoFactura = ['Facturacion Automatica', 'Facturar en Oficina'];

  final _cuotas = ['1', '2', '3', '4', '5'];
  final _cuotasAdicionales = ['1', '2', '3', '4', '5'];
  final client_name = TextEditingController(text: global.persona_presente);
  bool inter = true;
  var listener;

  @override
  void initState() {
    super.initState();
    if (global.deleteImg) {
      setState(() {
        global.updateCoords = false;
        global.btnUpdateCoords = false;
        global.tipo_factura_soporte = 'Facturacion Automatica';
        global.tipo_factura_soporteAdicional = 'Facturacion Automatica';
        global.ProductAdSoport = false;
        global.nCuotas = '1';
        global.btnFacturaOficina = false;
        global.tipocondicion = 'Seleccionar';
        global.ProductAdiciSoport = 'NO';
      });
    }

    initTotal();
    valorDelArrayFactProAdicionales();
    _getCurrentPosition();
  }

  void valorDelArrayFactProAdicionales() {
    if (global.itemsAdcionales.isNotEmpty) {
      if (global.tipo_factura_soporte == 'Facturacion Automatica') {
        for (var i = 0; i <= global.itemsAdcionales.length - 1; i++) {
          if (global.nfacturaSiNoAdicional[i] == 'NO') {
            global.visiblecuotasadi = true;
            break;
          } else {
            global.visiblecuotasadi = false;
          }
        }
      } else {
        for (var i = 0; i <= global.itemsAdcionales.length - 1; i++) {
          global.nfacturaSiNoAdicional[i] = 'SI';
          global.visiblecuotasadi = true;
        }
      }
      /* if (global.nCuotasAdicionales == '0') {
        for (var i = 0; i <= global.itemsAdcionales.length - 1; i++) {
          global.nfacturaSiNoAdicional[i] = 'SI';
        }
      } else {
        for (var i = 0; i <= global.itemsAdcionales.length - 1; i++) {
          global.nfacturaSiNoAdicional[i] = 'NO';
        }
      } */
    }
  }

  void initfacturaSiNo() {
    if (global.items.isEmpty) {
      null;
    } else {
      global.nfacturaSiNo.clear();
      for (int i = 1; i <= global.items.length; i++) {
        global.nfacturaSiNo.add(global.factura == true ? 'SI' : 'NO');
      }
    }
    print(global.nfacturaSiNo);
    print(global.totalFacturar);
  }

  double tot1 = 0.0;
  double tot2 = 0.00;
  double tot = 0.00;
  void initTotal() {
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          print('Data connection is available.');
          if (mounted) {
            setState(() {
              inter = true;
            });
            Future.delayed(Duration(seconds: 1), () {
              mostrarCorrectoMSG(context, 'Conexión a internet reestablecida.');
            });
          }
          break;
        case InternetConnectionStatus.disconnected:
          print('You are disconnected from the internet.');
          if (mounted) {
            setState(() {
              inter = false;
            });
          }
          Future.delayed(Duration(seconds: 1), () {
            AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dialogType: DialogType.error,
              body: Column(
                children: [
                  Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'No estas conectado a ',
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'INTERNET ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                  text: 'o estas teniendo una señal con ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                    text: 'INTERMITENCIA.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ])))
                ],
              ),
              btnOkOnPress: () {},
              btnOkText: 'Aceptar',
            ).show();
          });

          break;
      }
    });
    if (mounted) {
      setState(() {
        global.nFactProduct = 'SI';
      });
    }
    tot1 = 0.00;
    tot2 = 0.00;
    tot = 0.00;
    if (global.tipocondicion == 'Procedente') {
      if (global.itemsAdcionales == [] || global.itemsAdcionales.isEmpty) {
      } else {
        for (var y = 0; y <= global.nTicketsAdicionales.length - 1; y++) {
          /*  _nTotal
            .add((global.nTickets[y] * double.parse(global.items[y].precio))); */
          if (global.nfacturaSiNoAdicional[y] == 'SI') {
            tot1 = tot1 +
                double.parse(((global.nTicketsAdicionales[y].toDouble() *
                            double.parse(global.itemsAdcionales[y].precio)) -
                        (((global.nDescuentoAdicional[y] / 100) *
                            (double.parse(global.itemsAdcionales[y].precio)) *
                            global.nTicketsAdicionales[y].toDouble())))
                    .toStringAsFixed(2));
            if (tot1 < 0) {
              tot1 = 0.00;
            }
          } else {
            tot2 = tot2 +
                double.parse(((global.nTicketsAdicionales[y].toDouble() *
                            double.parse(global.itemsAdcionales[y].precio)) -
                        (((global.nDescuentoAdicional[y] / 100) *
                            (double.parse(global.itemsAdcionales[y].precio)) *
                            global.nTicketsAdicionales[y].toDouble())))
                    .toStringAsFixed(2));
            if (tot2 < 0) {
              tot2 = 0.00;
            }
          }
          tot = (tot1);
          //tot = tot1 + tot2;
        }
      }
    } else {
      if (global.items == [] || global.items.isEmpty) {
      } else {
        for (var y = 0; y <= global.nTickets.length - 1; y++) {
          /*  _nTotal
            .add((global.nTickets[y] * double.parse(global.items[y].precio))); */
          if (global.nfacturaSiNo[y] == 'SI') {
            tot1 = tot1 +
                double.parse(((global.nTickets[y].toDouble() *
                            double.parse(global.items[y].precio)) -
                        (((global.nDescuento[y] / 100) *
                            (double.parse(global.items[y].precio)) *
                            global.nTickets[y].toDouble())))
                    .toStringAsFixed(2));
            if (tot1 < 0) {
              tot1 = 0.00;
            }
          } else {
            tot2 = tot2 +
                double.parse(((global.nTickets[y].toDouble() *
                            double.parse(global.items[y].precio)) -
                        (((global.nDescuento[y] / 100) *
                            (double.parse(global.items[y].precio)) *
                            global.nTickets[y].toDouble())))
                    .toStringAsFixed(2));

            if (tot2 < 0) {
              tot2 = 0.00;
            }
          }
          tot = (tot1);
        }
      }
    }
    print(global.nTickets);
    print(global.totalFacturar);
  }

  @override
  dispose() {
    // Es importante SIEMPRE realizar el dispose del controller.
    solucionController.dispose();
    facturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;
    /* if (inter == true) {
      mostrarCorrectoMSG(context, 'Conexión a internet reestablecida.');
    } else {
      mostrarErrorMSG(context, 'Sin internet');
      /* AwesomeDialog(
        context: context,
        dismissOnTouchOutside: false,
        dialogType: DialogType.error,
        body: Column(
          children: [
            Center(
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: 'No estas conectado a ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'INTERNET ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                          TextSpan(
                            text: 'o estas teniendo una señal con ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                              text: 'INTERMITENCIA.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))
                        ])))
          ],
        ),
        btnOkOnPress: () {},
        btnOkText: 'Aceptar',
      ).show(); */
    } */
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: true,
        title: Text(
          'Registrar Solución',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorFondo.PRIMARY,
      ),
      //drawer: const MenuPrincipal(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              width: varWidth,
              padding: EdgeInsets.all(16),
              color: ColorFondo.BTNUBI,
              child: Text(
                  'Cod. ${global.codigo_servicioDetSoporte} - ${global.clienteDetSoporte}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Categoría Solución:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white, //blue
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: varWidth,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: _tipoCondicion.map((String a) {
                            return DropdownMenuItem(
                                value: a,
                                child: Text(
                                  a,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'AvenirNext-Regular',
                                  ),
                                ));
                          }).toList(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: ColorFondo.PRIMARY, // <-- SEE HERE
                          ),
                          onChanged: (valor) => {
                            global.tipocondicion = valor.toString(),
                            if (global.tipocondicion == 'Procedente')
                              {
                                global.isProcedenteSoporte = true,
                                global.factura = false,
                                //global.factura_SI_NO = 'SI',
                                global.nFactProduct = 'SI',
                                for (int i = 1; i <= global.items.length; i++)
                                  {
                                    global.nfacturaSiNo[i - 1] = 'SI',
                                    global.nDescuento[i - 1] = 0,
                                  },
                                initTotal()
                              }
                            else if (global.tipocondicion == 'No Procedente')
                              {
                                global.isProcedenteSoporte = false,
                                global.factura = true,
                                global.ProductAdSoport = false,
                                global.ProductAdiciSoport = 'NO',
                                //global.factura_SI_NO = 'NO',
                                global.nFactProduct = 'SI',
                                global.itemsAdcionales.clear(),
                                global.nTicketsAdicionales.clear(),
                                //global.nDescuento.removeAt(index);
                                global.nfacturaSiNoAdicional.clear(),
                                global.serieProductsAdicional.clear(),
                                global.nDescuentoAdicional.clear(),
                                for (int i = 1; i <= global.items.length; i++)
                                  {
                                    global.nfacturaSiNo[i - 1] = 'SI',
                                    global.nDescuento[i - 1] = 0,
                                  },
                                initTotal(),
                                global.visiblecuotasadi = false
                              }
                            else if (global.tipocondicion == 'Averia')
                              {
                                global.isProcedenteSoporte = false,
                                global.factura = true,
                                global.ProductAdSoport = false,
                                global.ProductAdiciSoport = 'NO',
                                //global.factura_SI_NO = 'NO',
                                global.nFactProduct = 'SI',
                                global.itemsAdcionales.clear(),
                                global.nTicketsAdicionales.clear(),
                                //global.nDescuento.removeAt(index);
                                global.nfacturaSiNoAdicional.clear(),
                                global.serieProductsAdicional.clear(),
                                global.nDescuentoAdicional.clear(),
                                for (int i = 1; i <= global.items.length; i++)
                                  {
                                    global.nfacturaSiNo[i - 1] = 'SI',
                                    global.nDescuento[i - 1] = 0,
                                  },
                                initTotal(),
                                global.visiblecuotasadi = false
                              }
                            else
                              {
                                global.isProcedenteSoporte = false,
                                global.factura = true,
                                global.ProductAdSoport = false,
                                global.ProductAdiciSoport = 'NO',
                                //global.factura_SI_NO = 'NO',
                                global.nFactProduct = 'SI',
                                global.items.clear(),
                                global.nTickets.clear(),
                                //global.nDescuento.removeAt(index);
                                global.nfacturaSiNo.clear(),
                                global.serieProducts.clear(),
                                global.nDescuento.clear(),
                                global.itemsAdcionales.clear(),
                                global.nTicketsAdicionales.clear(),
                                //global.nDescuento.removeAt(index);
                                global.nfacturaSiNo.clear(),
                                global.nfacturaSiNoAdicional.clear(),
                                global.serieProductsAdicional.clear(),
                                global.nDescuentoAdicional.clear(),
                                initTotal(),
                                global.visiblecuotasadi = false
                              },
                            print(global.factura),
                            //global.factura_SI_NO = 'SI',
                            print(global.nFactProduct),

                            // global.tipoEventoTxt = valor.toString(),
                            // AQUI AGREGAR
                            setState(() {
                              global.tipo_factura_soporte =
                                  'Facturacion Automatica';
                              global.btnFacturaOficina = false;
                            })
                          },
                          hint: Text(
                            global.tipocondicion,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Tipo de Facturación:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.white, //blue
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: varWidth,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          items: _tipoFactura.map((String a) {
                            return DropdownMenuItem(
                                value: a,
                                child: Text(
                                  a,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'AvenirNext-Regular',
                                  ),
                                ));
                          }).toList(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: ColorFondo.PRIMARY, // <-- SEE HERE
                          ),
                          onChanged: (valor) => {
                            setState(() {
                              global.tipo_factura_soporte = valor.toString();
                              if (global.tipo_factura_soporte ==
                                  'Facturar en Oficina') {
                                global.btnFacturaOficina = true;
                              } else {
                                global.btnFacturaOficina = false;
                                global.nCuotas = '1';
                              }
                              global.nCuotasAdicionales = '1';
                              valorDelArrayFactProAdicionales();
                            })
                          },
                          hint: Text(
                            global.tipo_factura_soporte,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: global.btnFacturaOficina,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('Cuotas:'),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.white, //blue
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: varWidth,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  isExpanded: true,
                                  items: _cuotas.map((String a) {
                                    return DropdownMenuItem(
                                        value: a,
                                        child: Text(
                                          a,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'AvenirNext-Regular',
                                          ),
                                        ));
                                  }).toList(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: ColorFondo.PRIMARY, // <-- SEE HERE
                                  ),
                                  onChanged: (valor) => {
                                    setState(() {
                                      global.nCuotas = valor.toString();
                                    })
                                  },
                                  hint: Text(
                                    global.nCuotas,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Seleccionar Auxiliar:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 8, right: 8, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.white, //blue
                          borderRadius: BorderRadius.circular(12),
                        ),
                        width: varWidth,
                        child: DropdownButton<dynamic>(
                          isExpanded: true,
                          value: global.selectAcomp,
                          onChanged: (newValue) {
                            setState(() {
                              global.selectAcomp = newValue;
                            });
                          },
                          items: global.tecnicoAcomp
                              .map<DropdownMenuItem<dynamic>>((dynamic value) {
                            return DropdownMenuItem<dynamic>(
                              value: value,
                              child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: ColorFondo.PRIMARY, // <-- SEE HERE
                          ),
                        )),
                    Center(
                        child: CheckboxListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text:
                                          'Actualizar las coordenadas del servicio',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: global.updateCoords,
                      onChanged: global.ischeckedCoord
                          ? (newValue) {
                              if (global.updateCoords == false) {
                                setState(() {
                                  global.btnUpdateCoords = true;
                                });
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.infoReverse,
                                        animType: AnimType.bottomSlide,
                                        //headerAnimationLoop: true,
                                        title:
                                            'Las coordenadas del servicio se actualizaran por las de la posición actual del técnico al finalizar la instalación',
                                        dialogBackgroundColor: Colors.white,
                                        //  desc: 'Por favor, cambie e intente nuevamente.',
                                        btnOkOnPress: () {
                                          //Navigator.pop(context);
                                        },
                                        btnOkText: 'Aceptar',
                                        btnOkColor: ColorFondo.BTNUBI)
                                    .show();
                              } else {
                                setState(() {
                                  global.btnUpdateCoords = false;
                                });
                              }

                              setState(() {
                                global.updateCoords = newValue!;
                              });
                            }
                          : null,
                      activeColor: ColorFondo.PRIMARY,
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    )),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Persona Presente:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    sombra(Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextField(
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.text,
                        controller: client_name,
                        onChanged: (value) {
                          setState(() {
                            global.persona_presente = value.toString();
                          });
                        },
                        maxLength: 60,
                        decoration: InputDecoration(
                          counterText: "",
                          hintText: 'Ingrese el nombre de persona presente',
                        ),
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('Detalle la Solución:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Column(
                      children: <Widget>[
                        sombra(Card(
                            //color: Color.fromARGB(255, 233, 229, 229),
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            onChanged: (value) {
                              global.detalleSoluSoporte = value.toString();
                            },
                            controller: solucionController,
                            maxLines: 8,
                            decoration: InputDecoration.collapsed(
                                hintText: "Escriba aquí la solución"),
                          ),
                        )))
                      ],
                    ),
                    Center(
                        child: CheckboxListTile(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                    text:
                                        'Acepto que he retirado y debo entregar los productos.',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      value: global.checkBoxValue,
                      onChanged: global.ischecked
                          ? (newValue) {
                              if (global.checkBoxValue == false) {
                                global.btnRecibeProd = true;
                                AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.infoReverse,
                                        animType: AnimType.bottomSlide,
                                        //headerAnimationLoop: true,
                                        title:
                                            'Recuerda que debes seleccionar los nuevos productos dejados en el sitio',
                                        dialogBackgroundColor: Colors.white,
                                        //  desc: 'Por favor, cambie e intente nuevamente.',
                                        btnOkOnPress: () {
                                          //Navigator.pop(context);
                                        },
                                        btnOkText: 'Aceptar',
                                        btnOkColor: ColorFondo.BTNUBI)
                                    .show();
                              } else {
                                global.btnRecibeProd = false;
                              }

                              setState(() {
                                global.checkBoxValue = newValue!;
                              });
                            }
                          : null,
                      activeColor: ColorFondo.PRIMARY,
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    )),
                    Visibility(
                      visible: global.btnRecibeProd,
                      child: Column(
                        children: <Widget>[
                          sombra(Card(
                              //color: Color.fromARGB(255, 233, 229, 229),
                              child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                global.detalleEquiposRetirados =
                                    value.toString();
                              },
                              controller: retiraProductosController,
                              maxLines: 11,
                              decoration: InputDecoration.collapsed(
                                  hintText:
                                      "Detalle aquí los productos que ha retirado y debe entregar en oficina"),
                            ),
                          )))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    ProgressDialog progressDialog =
                                        ProgressDialog(context);
                                    progressDialog.show();
                                    global.Listadogarantias.clear();
                                    listadoGarantias('').then((value) {
                                      if (mounted) {
                                        setState(() {
                                          global.Listadogarantias.addAll(value);
                                          //_foundSoportes = global.ListadoSoportes;
                                        });
                                      }
                                    });
                                    Future.delayed(Duration(seconds: 3), () {
                                      if (global.Listadogarantias.isEmpty) {
                                        progressDialog.dismiss();
                                        mostrarError(
                                            context, 'No se encontraron datos');
                                      } else {
                                        progressDialog.dismiss();
                                        Navigator.of(context)
                                            .push(BuscarSerieInactiva.route());
                                      }
                                    });
                                  },
                                  child: Container(
                                      width: varWidth * 0.6,
                                      height: varHeight * 0.05,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: ColorFondo.BTNUBI),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              'Verificar Garantía'
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat'),
                                            ),
                                            Icon(
                                              Icons.add_shopping_cart,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          /* Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(BuscarProduct.route());
                                      /*  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BuscarProduct())); */
                                    },
                                    child: Text('Productos')),
                                /* ElevatedButton(
                                    onPressed: () async {
                                      final url =
                                          'https://power.net.ec/app/reportes/comprobantes_sri/factura_electronica/ride_factura_movil.php?id_documento=vrG1w863kKSfj5mXop-x&valor_documento=SI&sucursales=y8W1xMu4kKSfj5mUoqCs';
                                      final file = await ApiPdf.loadNetwork(url);
                                      openPdf(context, file);
                                      /* Navigator.of(context)
                                          .pushReplacement(PDFVIEW.route()); */
                                    },
                                    child: Text('Ver Pdf')), */
                              ],
                            ), */
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    global.numAdicioanl = 0;
                                  });
                                  Navigator.of(context).pushReplacement(
                                      BuscarProduct.route('SUPPORT'));
                                },
                                child: Container(
                                    width: varWidth * 0.6,
                                    height: varHeight * 0.05,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: ColorFondo.BTNUBI),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Agregar Productos'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Montserrat'),
                                          ),
                                          Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('Detalle de la Factura:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              //scrollDirection: Axis.horizontal,
                              child: Container(
                                height: 300,
                                child: global.items.length > 0
                                    ? ListView.separated(
                                        itemCount: global.items.length,
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(
                                          color: Colors.black,
                                        ),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Dismissible(
                                            onDismissed:
                                                (DismissDirection direction) {
                                              setState(() {
                                                global.items.removeAt(index);
                                                global.nTickets.removeAt(index);
                                                //global.nDescuento.removeAt(index);
                                                global.nfacturaSiNo
                                                    .removeAt(index);
                                                global.serieProducts
                                                    .removeAt(index);
                                                global.nDescuento
                                                    .removeAt(index);
                                              });
                                              initTotal();
                                              print(global.items.length);
                                              print(tot.toStringAsFixed(2));
                                            },
                                            secondaryBackground: Container(
                                              child: Center(
                                                child: Text(
                                                  'Eliminar?',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              color: Colors.red,
                                            ),
                                            background: Container(),
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        'Descripción: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    Container(
                                                      //color: Colors.blue,
                                                      width: 200,
                                                      child: Text(
                                                        global.items[index]
                                                            .nombre,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Visibility(
                                                  visible: global.items[index]
                                                              .serie ==
                                                          'SI'
                                                      ? true
                                                      : false,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              'Serie: ',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Container(
                                                            //color: Colors.blue,
                                                            width: 200,
                                                            child: Text(
                                                              global
                                                                  .serieProducts[
                                                                      index]
                                                                  .serie1,
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                              ),
                                                              maxLines: 3,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          /* Container(
                                                                                          width: 65,
                                                                                          child: Center(
                                                                                              child: Text(
                                                                                            global.items[index].categoria,
                                                                                            style: TextStyle(
                                                                                                fontSize: 14, ),
                                                                                            textAlign: TextAlign.center,
                                                                                          )),
                                                                                        ), */
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Facturar Prod.: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Radio(
                                                                      activeColor:
                                                                          ColorFondo
                                                                              .PRIMARY,
                                                                      value:
                                                                          'SI',
                                                                      groupValue:
                                                                          global.nfacturaSiNo[
                                                                              index],
                                                                      onChanged: global.factura ==
                                                                              true
                                                                          ? (value) {
                                                                              facturarSiNo = value.toString();
                                                                              global.nfacturaSiNo[index] = value.toString();
                                                                              print(global.nfacturaSiNo);
                                                                              initTotal();
                                                                              setState(() {});
                                                                            }
                                                                          : null),
                                                                  Text('SI',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Radio(
                                                                      activeColor:
                                                                          ColorFondo
                                                                              .PRIMARY,
                                                                      value:
                                                                          'NO',
                                                                      groupValue:
                                                                          global.nfacturaSiNo[
                                                                              index],
                                                                      onChanged: global.factura ==
                                                                              true
                                                                          ? (value) {
                                                                              facturarSiNo = value.toString();
                                                                              global.nfacturaSiNo[index] = value.toString();
                                                                              print(global.nfacturaSiNo);
                                                                              setState(() {});
                                                                              initTotal();
                                                                            }
                                                                          : null),
                                                                  Text('NO',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black)),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Descuento: ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      InkWell(
                                                        child: CircleAvatar(
                                                          backgroundColor:
                                                              global.factura ==
                                                                      true
                                                                  ? ColorFondo
                                                                      .BTNUBI
                                                                  : Color
                                                                      .fromARGB(
                                                                          164,
                                                                          2,
                                                                          40,
                                                                          255),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child: FittedBox(
                                                              child: Text(
                                                                global
                                                                    .nDescuento[
                                                                        index]
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        22),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        onTap:
                                                            global.factura ==
                                                                    true
                                                                ? () {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (BuildContext
                                                                                context) {
                                                                          return AlertDialog(
                                                                            title:
                                                                                const Text("Cantidad"),
                                                                            content:
                                                                                TextField(
                                                                              controller: txtCant,
                                                                              keyboardType: TextInputType.number,
                                                                              decoration: InputDecoration(hintText: 'Ingrese el porcentaje a descontar', filled: true, fillColor: Colors.grey.shade50),
                                                                            ),
                                                                            actions: <Widget>[
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: const Text('Cancelar'),
                                                                              ),
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  if (txtCant.text.isEmpty || txtCant.text == "") {
                                                                                    print('aqui vacio');
                                                                                    null;
                                                                                  } else if (int.parse(txtCant.text) < 0) {
                                                                                    print('aqui 0');
                                                                                    mostrarError(context, 'Ingrese una cantidad valida');
                                                                                  } else if (int.parse(txtCant.text) > 100) {
                                                                                    print('aqui 100');
                                                                                    mostrarError(context, 'Ingrese una cantidad valida');
                                                                                  } else {
                                                                                    print('aqui contrario');

                                                                                    global.nDescuento[index] = int.parse(txtCant.text);
                                                                                  }
                                                                                  initTotal();
                                                                                  Navigator.pop(context);
                                                                                  txtCant.text = "";
                                                                                  /*  try {
                                                                          txtCant.text.isEmpty ||
                                                                                  txtCant.text == ""
                                                                              ? null
                                                                              : int.parse(txtCant.text) >= 0
                                                                                  ? global.nDescuento[index] = int.parse(txtCant.text)
                                                                                  :int.parse(txtCant.text) >= 100? mostrarError(context, 'Ingrese una cantidad valida'):mostrarError(context, 'Ingrese una cantidad valida');
                                                                          Navigator.pop(
                                                                              context);
                                                                          initTotal();
                                                                          txtCant.text =
                                                                              "";
                                                                        } catch (e) {
                                                                          mostrarError(
                                                                              context,
                                                                              'Ingrese una cantidad correcta');
                                                                          Navigator.pop(
                                                                              context);
                                                                          txtCant.text =
                                                                              "";
                                                                        } */
                                                                                },
                                                                                child: const Text('Aceptar'),
                                                                              ),
                                                                            ],
                                                                          );
                                                                        });
                                                                  }
                                                                : null,
                                                      ),
                                                      Text(
                                                        ' %',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        //color: Colors.amber,
                                                        width: 140,
                                                        height: 70,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              'Cant.',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (global
                                                                              .items[index]
                                                                              .tipo ==
                                                                          'PRODUCTO') {
                                                                        if (global.nTickets[index] >
                                                                            1) {
                                                                          global.nTickets[index] =
                                                                              global.nTickets[index] - 1;
                                                                          tot = tot -
                                                                              double.parse(global.items[index].precio);
                                                                        } else {
                                                                          global.nTickets[index] =
                                                                              global.nTickets[index];
                                                                        }
                                                                        print(global
                                                                            .nTickets);
                                                                        initTotal();
                                                                      } else {
                                                                        null;
                                                                      }
                                                                    });
                                                                  },
                                                                  child: Icon(
                                                                    Icons
                                                                        .do_disturb_on_outlined,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    if (global
                                                                            .items[index]
                                                                            .tipo ==
                                                                        'PRODUCTO') {
                                                                      if (global
                                                                              .items[index]
                                                                              .serie ==
                                                                          'NO') {
                                                                        if (global.nTickets[index] <
                                                                            int.parse(global.items[index].stock)) {
                                                                          showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Text("Cantidad"),
                                                                                  content: TextField(
                                                                                    controller: txtCantProd,
                                                                                    keyboardType: TextInputType.number,
                                                                                    decoration: InputDecoration(hintText: 'Ingrese la cantidad deseada', filled: true, fillColor: Colors.grey.shade50),
                                                                                  ),
                                                                                  actions: <Widget>[
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: const Text('Cancelar'),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        if (txtCantProd.text.isEmpty || txtCantProd.text == "") {
                                                                                          print('aqui vacio');
                                                                                          null;
                                                                                        } else if (int.parse(txtCantProd.text) < 0) {
                                                                                          print('aqui 0');
                                                                                          mostrarError(context, 'Ingrese una cantidad valida');
                                                                                        } else if (int.parse(txtCantProd.text) > int.parse(global.items[index].stock)) {
                                                                                          print('aqui 100');
                                                                                          mostrarError(context, 'Ingrese una cantidad valida');
                                                                                        } else {
                                                                                          print('aqui contrario');

                                                                                          global.nTickets[index] = int.parse(txtCantProd.text);
                                                                                        }
                                                                                        initTotal();
                                                                                        Navigator.pop(context);
                                                                                        txtCantProd.text = "";
                                                                                      },
                                                                                      child: const Text('Aceptar'),
                                                                                    ),
                                                                                  ],
                                                                                );
                                                                              });
                                                                        } else {
                                                                          global.nTickets[index] =
                                                                              global.nTickets[index];
                                                                          print('mi cantidad siiiii:' +
                                                                              '${global.nTickets[index].toString()}');
                                                                        }
                                                                        tot = 0;
                                                                        initTotal();
                                                                      } else {
                                                                        null;
                                                                      }
                                                                    } else {
                                                                      null;
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    '${global.nTickets[index]}',
                                                                    style: TextStyle(
                                                                        color: global.nTickets[index] ==
                                                                                0
                                                                            ? Colors
                                                                                .red
                                                                            : Colors
                                                                                .green,
                                                                        fontSize:
                                                                            15),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      if (global
                                                                              .items[index]
                                                                              .tipo ==
                                                                          'PRODUCTO') {
                                                                        if (global.items[index].serie ==
                                                                            'NO') {
                                                                          if (global.nTickets[index] <
                                                                              int.parse(global.items[index].stock)) {
                                                                            global.nTickets[index] =
                                                                                global.nTickets[index] + 1;
                                                                            print('mi cantidad:' +
                                                                                '${global.nTickets[index].toString()}');
                                                                            print(global.nTickets);
                                                                          } else {
                                                                            global.nTickets[index] =
                                                                                global.nTickets[index];
                                                                            print('mi cantidad siiiii:' +
                                                                                '${global.nTickets[index].toString()}');
                                                                          }
                                                                          tot =
                                                                              0;
                                                                          initTotal();
                                                                        } else {
                                                                          null;
                                                                        }
                                                                      } else {
                                                                        null;
                                                                      }
                                                                      /* for(var i =0; i<=global.items.length; i++){
                                                                        global.totalFacturar= global.totalFacturar+(global.nTickets[index] * double.parse(global
                                                                    .items[index].precio));
                
                                                                      } */
                                                                    });
                                                                  },
                                                                  child: Icon(Icons
                                                                      .add_circle_outline),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        //color: Colors.greenAccent,
                                                        width: 70,
                                                        height: 70,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Precio',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                                global
                                                                    .items[
                                                                        index]
                                                                    .precio,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        // color: Colors.green,
                                                        width: 80,
                                                        height: 70,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Center(
                                                                child: Text(
                                                              'Total',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            )),
                                                            SizedBox(
                                                              height: 15,
                                                            ),
                                                            Text(
                                                              //'${_nTotal[index]}',
                                                              '${((global.nTickets[index].toDouble() * double.parse(global.items[index].precio)) - (((global.nDescuento[index] / 100) * (double.parse(global.items[index].precio)) * global.nTickets[index].toDouble()))).toStringAsFixed(2)}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16),
                                                              textAlign:
                                                                  TextAlign.end,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ])
                                              ],
                                            ),
                                            key: UniqueKey(),
                                            direction:
                                                DismissDirection.endToStart,
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text(
                                            'Sin productos seleccionados')),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: global.isProcedenteSoporte,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text('¿Requiere productos adicionales?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Radio(
                                                  activeColor:
                                                      ColorFondo.PRIMARY,
                                                  value: 'SI',
                                                  groupValue:
                                                      global.ProductAdiciSoport,
                                                  onChanged: (valueAd) {
                                                    this.setState(() {
                                                      global.ProductAdiciSoport =
                                                          valueAd.toString();
                                                    });
                                                    initTotal();
                                                    global.ProductAdSoport =
                                                        true;
                                                  }),
                                              Text('SI',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Radio(
                                                  activeColor:
                                                      ColorFondo.PRIMARY,
                                                  value: 'NO',
                                                  groupValue:
                                                      global.ProductAdiciSoport,
                                                  onChanged: (valueAd) {
                                                    global.ProductAdSoport =
                                                        false;
                                                    global.itemsAdcionales
                                                        .clear();
                                                    initTotal();
                                                    this.setState(() {
                                                      global.ProductAdiciSoport =
                                                          valueAd.toString();
                                                    });
                                                  }),
                                              Text('NO',
                                                  style: TextStyle(
                                                      color: Colors.black)),
                                              SizedBox(
                                                width: 5,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                              visible: global.visiblecuotasadi,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                        'Cuotas de productos adicionales:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white, //blue
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    width: varWidth,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        dropdownColor: Colors.white,
                                        isExpanded: true,
                                        items:
                                            _cuotasAdicionales.map((String a) {
                                          return DropdownMenuItem(
                                              value: a,
                                              child: Text(
                                                a,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontFamily:
                                                      'AvenirNext-Regular',
                                                ),
                                              ));
                                        }).toList(),
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: ColorFondo
                                              .PRIMARY, // <-- SEE HERE
                                        ),
                                        onChanged: (valor) => {
                                          setState(() {
                                            global.nCuotasAdicionales =
                                                valor.toString();
                                            //valorDelArrayFactProAdicionales();
                                            initTotal();
                                          })
                                        },
                                        hint: Text(
                                          global.nCuotasAdicionales,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Visibility(
                            visible: global.ProductAdSoport,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            global.numAdicioanl = 1;
                                          });
                                          Navigator.of(context).pushReplacement(
                                              BuscarProduct.route('SUPPORT'));
                                        },
                                        child: Container(
                                            width: varWidth * 0.6,
                                            height: varHeight * 0.05,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: ColorFondo.BTNUBI),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Text(
                                                    'Agregar Adicionales'
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'Montserrat'),
                                                  ),
                                                  Icon(
                                                    Icons.add_shopping_cart,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Visibility(
                            visible: global.ProductAdSoport,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, bottom: 10),
                              child: SingleChildScrollView(
                                //scrollDirection: Axis.horizontal,
                                child: Container(
                                  height: 300,
                                  child: global.itemsAdcionales.length > 0
                                      ? ListView.separated(
                                          itemCount:
                                              global.itemsAdcionales.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(
                                            color: Colors.black,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Dismissible(
                                              onDismissed:
                                                  (DismissDirection direction) {
                                                setState(() {
                                                  global.itemsAdcionales
                                                      .removeAt(index);
                                                  global.nTicketsAdicionales
                                                      .removeAt(index);
                                                  global.nfacturaSiNoAdicional
                                                      .removeAt(index);
                                                  global.serieProductsAdicional
                                                      .removeAt(index);
                                                  global.nDescuentoAdicional
                                                      .removeAt(index);
                                                });
                                                initTotal();
                                                print(global
                                                    .itemsAdcionales.length);
                                                print(tot.toStringAsFixed(2));
                                              },
                                              secondaryBackground: Container(
                                                child: Center(
                                                  child: Text(
                                                    'Eliminar?',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                color: Colors.red,
                                              ),
                                              background: Container(),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          'Descripción: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        //color: Colors.blue,
                                                        width: 200,
                                                        child: Text(
                                                          global
                                                              .itemsAdcionales[
                                                                  index]
                                                              .nombre,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Visibility(
                                                    visible: global
                                                                .itemsAdcionales[
                                                                    index]
                                                                .serie ==
                                                            'SI'
                                                        ? true
                                                        : false,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Container(
                                                              child: Text(
                                                                'Serie: ',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              //color: Colors.blue,
                                                              width: 200,
                                                              child: Text(
                                                                global
                                                                    .serieProductsAdicional[
                                                                        index]
                                                                    .serie1,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 14,
                                                                ),
                                                                maxLines: 3,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Facturar Prod.: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Radio(
                                                                        activeColor:
                                                                            ColorFondo
                                                                                .PRIMARY,
                                                                        value:
                                                                            'SI',
                                                                        groupValue:
                                                                            global.nfacturaSiNoAdicional[
                                                                                index],
                                                                        onChanged: global.tipo_factura_soporte ==
                                                                                'Facturacion Automatica'
                                                                            ? (value) {
                                                                                global.nfacturaSiNoAdicional[index] = value.toString();
                                                                                print(global.nfacturaSiNoAdicional);
                                                                                valorDelArrayFactProAdicionales();
                                                                                initTotal();
                                                                                setState(() {});
                                                                              }
                                                                            : null),
                                                                    Text('SI',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Radio(
                                                                        activeColor:
                                                                            ColorFondo
                                                                                .PRIMARY,
                                                                        value:
                                                                            'NO',
                                                                        groupValue:
                                                                            global.nfacturaSiNoAdicional[
                                                                                index],
                                                                        onChanged: global.tipo_factura_soporte ==
                                                                                'Facturacion Automatica'
                                                                            ? (value) {
                                                                                global.nfacturaSiNoAdicional[index] = value.toString();
                                                                                print(global.nfacturaSiNoAdicional);
                                                                                Fluttertoast.showToast(msg: "Verificar cuotas adicionales", gravity: ToastGravity.CENTER, backgroundColor: Color.fromARGB(239, 81, 193, 233), toastLength: Toast.LENGTH_LONG, textColor: Colors.black);
                                                                                setState(() {});
                                                                                valorDelArrayFactProAdicionales();
                                                                                initTotal();
                                                                              }
                                                                            : null),
                                                                    Text('NO',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                    SizedBox(
                                                                      width: 5,
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Descuento: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        InkWell(
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                ColorFondo
                                                                    .BTNUBI,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3.0),
                                                              child: FittedBox(
                                                                child: Text(
                                                                  global
                                                                      .nDescuentoAdicional[
                                                                          index]
                                                                      .toString(),
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          22),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: const Text(
                                                                        "Cantidad"),
                                                                    content:
                                                                        TextField(
                                                                      controller:
                                                                          txtCant,
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .number,
                                                                      decoration: InputDecoration(
                                                                          hintText:
                                                                              'Ingrese el porcentaje a descontar',
                                                                          filled:
                                                                              true,
                                                                          fillColor: Colors
                                                                              .grey
                                                                              .shade50),
                                                                    ),
                                                                    actions: <Widget>[
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: const Text(
                                                                            'Cancelar'),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          if (txtCant.text.isEmpty ||
                                                                              txtCant.text ==
                                                                                  "") {
                                                                            print('aqui vacio');
                                                                            null;
                                                                          } else if (int.parse(txtCant.text) <
                                                                              0) {
                                                                            print('aqui 0');
                                                                            mostrarError(context,
                                                                                'Ingrese una cantidad valida');
                                                                          } else if (int.parse(txtCant.text) >
                                                                              100) {
                                                                            print('aqui 100');
                                                                            mostrarError(context,
                                                                                'Ingrese una cantidad valida');
                                                                          } else {
                                                                            print('aqui contrario');
                                                                            initTotal();
                                                                            global.nDescuentoAdicional[index] =
                                                                                int.parse(txtCant.text);
                                                                          }
                                                                          initTotal();
                                                                          Navigator.pop(
                                                                              context);
                                                                          txtCant.text =
                                                                              "";
                                                                        },
                                                                        child: const Text(
                                                                            'Aceptar'),
                                                                      ),
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                        ),
                                                        Text(
                                                          ' %',
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          //color: Colors.amber,
                                                          width: 150,
                                                          height: 80,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                'Cant.',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (global.itemsAdcionales[index].tipo ==
                                                                            'PRODUCTO') {
                                                                          if (global.nTicketsAdicionales[index] >
                                                                              1) {
                                                                            global.nTicketsAdicionales[index] =
                                                                                global.nTicketsAdicionales[index] - 1;
                                                                            tot =
                                                                                tot - double.parse(global.itemsAdcionales[index].precio);
                                                                          } else {
                                                                            global.nTicketsAdicionales[index] =
                                                                                global.nTicketsAdicionales[index];
                                                                          }
                                                                          print(
                                                                              global.nTicketsAdicionales);
                                                                          initTotal();
                                                                        } else {
                                                                          null;
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .do_disturb_on_outlined,
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (global
                                                                              .itemsAdcionales[index]
                                                                              .tipo ==
                                                                          'PRODUCTO') {
                                                                        if (global.itemsAdcionales[index].serie ==
                                                                            'NO') {
                                                                          if (global.nTicketsAdicionales[index] <
                                                                              int.parse(global.itemsAdcionales[index].stock)) {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (BuildContext context) {
                                                                                  return AlertDialog(
                                                                                    title: const Text("Cantidad"),
                                                                                    content: TextField(
                                                                                      controller: txtCantProd,
                                                                                      keyboardType: TextInputType.number,
                                                                                      decoration: InputDecoration(hintText: 'Ingrese la cantidad deseada', filled: true, fillColor: Colors.grey.shade50),
                                                                                    ),
                                                                                    actions: <Widget>[
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: const Text('Cancelar'),
                                                                                      ),
                                                                                      TextButton(
                                                                                        onPressed: () {
                                                                                          if (txtCantProd.text.isEmpty || txtCantProd.text == "") {
                                                                                            print('aqui vacio');
                                                                                            null;
                                                                                          } else if (int.parse(txtCantProd.text) < 0) {
                                                                                            print('aqui 0');
                                                                                            mostrarError(context, 'Ingrese una cantidad valida');
                                                                                          } else if (int.parse(txtCantProd.text) > int.parse(global.itemsAdcionales[index].stock)) {
                                                                                            print('aqui 100');
                                                                                            mostrarError(context, 'Ingrese una cantidad valida');
                                                                                          } else {
                                                                                            print('aqui contrario');

                                                                                            global.nTicketsAdicionales[index] = int.parse(txtCantProd.text);
                                                                                          }
                                                                                          initTotal();
                                                                                          Navigator.pop(context);
                                                                                          txtCantProd.text = "";
                                                                                        },
                                                                                        child: const Text('Aceptar'),
                                                                                      ),
                                                                                    ],
                                                                                  );
                                                                                });
                                                                          } else {
                                                                            global.nTicketsAdicionales[index] =
                                                                                global.nTicketsAdicionales[index];
                                                                            print('mi cantidad siiiii:' +
                                                                                '${global.nTicketsAdicionales[index].toString()}');
                                                                          }
                                                                          //tot = 0;
                                                                          initTotal();
                                                                        } else {
                                                                          null;
                                                                        }
                                                                      } else {
                                                                        null;
                                                                      }
                                                                    },
                                                                    child: Text(
                                                                      '${global.nTicketsAdicionales[index]}',
                                                                      style: TextStyle(
                                                                          color: global.nTicketsAdicionales[index] == 0
                                                                              ? Colors.red
                                                                              : Colors.green,
                                                                          fontSize: 15),
                                                                    ),
                                                                  ),
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        if (global.itemsAdcionales[index].tipo ==
                                                                            'PRODUCTO') {
                                                                          if (global.itemsAdcionales[index].serie ==
                                                                              'NO') {
                                                                            if (global.nTicketsAdicionales[index] <
                                                                                int.parse(global.itemsAdcionales[index].stock)) {
                                                                              global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index] + 1;
                                                                              print('mi cantidad:' + '${global.nTicketsAdicionales[index].toString()}');
                                                                              print(global.nTicketsAdicionales);
                                                                            } else {
                                                                              global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index];
                                                                              print('mi cantidad siiiii:' + '${global.nTicketsAdicionales[index].toString()}');
                                                                            }
                                                                            tot =
                                                                                0;
                                                                            initTotal();
                                                                          } else {
                                                                            null;
                                                                          }
                                                                        } else {
                                                                          null;
                                                                        }
                                                                      });
                                                                    },
                                                                    child: Icon(
                                                                        Icons
                                                                            .add_circle_outline),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 60,
                                                          height: 80,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                'Precio',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                  global
                                                                      .itemsAdcionales[
                                                                          index]
                                                                      .precio,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          // color: Colors.green,
                                                          width: 105,
                                                          height: 80,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Center(
                                                                  child: Text(
                                                                'Total',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              )),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                '${((global.nTicketsAdicionales[index].toDouble() * double.parse(global.itemsAdcionales[index].precio)) - (((global.nDescuentoAdicional[index] / 100) * (double.parse(global.itemsAdcionales[index].precio)) * global.nTicketsAdicionales[index].toDouble()))).toStringAsFixed(2)}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16),
                                                                textAlign:
                                                                    TextAlign
                                                                        .end,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ])
                                                ],
                                              ),
                                              key: UniqueKey(),
                                              direction:
                                                  DismissDirection.endToStart,
                                            );
                                          },
                                        )
                                      : Center(
                                          child: Text(
                                              'Sin productos seleccionados')),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10.0, left: 10.0, right: 30.0),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /* Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Subtotal No Facturado: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${tot2.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ), */
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Subtotal Facturado: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${tot1.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'TOTAL: ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${tot.toStringAsFixed(2)}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Valor cobrado:'),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.attach_money_sharp,
                                            size: 40,
                                            color: Color.fromARGB(
                                                255, 119, 119, 119),
                                          ),
                                          sombra(
                                            Container(
                                              width: 90,
                                              child: TextFormField(
                                                controller: txtCant,
                                                /* onChanged: (value) {
                                                  if (value == '') {
                                                  } else if (!RegExp(
                                                          r'^\d+\.?\d{0,2}$')
                                                      .hasMatch(value == null
                                                          ? ''
                                                          : value)) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Solo se permiten 2 decimales",
                                                        gravity: ToastGravity
                                                            .CENTER,
                                                        backgroundColor: Color
                                                            .fromARGB(239, 81,
                                                                193, 233),
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        textColor: Colors
                                                            .black); /* """
        Error:
        - El monto no debe ser mayor a ${tot.toStringAsFixed(2)}
        """; */
                                                  } else if (double.parse(
                                                          value.toString()) >
                                                      tot) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "El monto no debe ser mayor a ${tot.toStringAsFixed(2)}",
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        backgroundColor:
                                                            Color.fromARGB(239,
                                                                81, 193, 233),
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        textColor:
                                                            Colors.black);
                                                  }
                                                }, */
                                                /* validator: (value) {
                                                  
                                                  return null;
                                                }, */
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                    hintText: 'Ej: 5.30',
                                                    filled: true,
                                                    fillColor: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                              visible: !global.btnFacturaOficina,
                              child: btnFacturaAutomatica()),
                          Visibility(
                              visible: global.btnFacturaOficina,
                              child: facturaOficina()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print(_currentPosition?.latitude);
      print(_currentPosition?.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Widget btnFacturaAutomatica() {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (inter == true) {
            print('Pos aca');
            global.items.forEach(print);

            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.show();

            print('aqui');
            print(_currentPosition?.latitude);
            print(_currentPosition?.longitude);

            setState(() {
              latitude = _currentPosition?.latitude != '' &&
                      _currentPosition?.latitude != null
                  ? _currentPosition?.latitude.toString()
                  : '0';
              longitude = _currentPosition?.longitude != '' &&
                      _currentPosition?.longitude != null
                  ? _currentPosition?.longitude.toString()
                  : '0';
            });

            print(global.tipocondicion);
            if (solucionController.text.isEmpty) {
              progressDialog.dismiss();
              mostrarError(context, 'Detalle una solucion para continuar');
            } else if (global.persona_presente.isEmpty) {
              progressDialog.dismiss();
              mostrarError(context, 'Campo Nombre del Cliente Vacio');
            } else if (global.tipocondicion == 'Seleccionar') {
              progressDialog.dismiss();
              mostrarError(context, 'Seleccione una categoría de solución');
            } else if (global.tipo_factura_soporte == 'Seleccionar') {
              progressDialog.dismiss();
              mostrarError(context, 'Seleccione un tipo de facturacion');
            } else if (global.checkBoxValue == true && global.items.isEmpty) {
              //TOAST
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.infoReverse,
                      animType: AnimType.bottomSlide,
                      //headerAnimationLoop: true,
                      title:
                          'Recuerda que debes seleccionar los nuevos productos dejados en el sitio',
                      dialogBackgroundColor: Colors.white,
                      //  desc: 'Por favor, cambie e intente nuevamente.',
                      btnOkOnPress: () {
                        //Navigator.pop(context);
                        progressDialog.dismiss();
                      },
                      btnOkText: 'Aceptar',
                      btnOkColor: ColorFondo.BTNUBI)
                  .show();
            } /* else if (global.items.isEmpty &&
              global.tipocondicion != 'Procedente') {
            progressDialog.dismiss();
            mostrarError(
                context, 'Seleccione un producto o servicio para finalizar');
          } */
            else if (global.selectAcomp == 'Seleccionar') {
              progressDialog.dismiss();
              mostrarError(
                  context, 'Seleccione un tecnico auxiliar para finalizar');
            } /* else if (double.parse(txtCant.text == '' ? '0' : txtCant.text) >
              tot) {
            progressDialog.dismiss();
            mostrarError(context,
                'El monto no debe ser mayor a ${tot.toStringAsFixed(2)}');
          } */
            else {
              setState(() {
                print('aqui ando');
                global.nomAuxiliar = global.selectAcomp;
                global.valorCobrado =
                    txtCant.text != '' ? double.parse(txtCant.text) : 0.0;
                print(global.nomAuxiliar);
                buttonEnabled = false;
              });
              items.clear();
              itemsAdicionales.clear();
              global.itemsPDF.clear();
              print('ingrese antes for');
              print(global.items.length - 1);
              print(global.nTickets.length);
              for (var i = 0; i <= global.items.length - 1; i++) {
                print('voy for $i');
                if (global.nfacturaSiNo[i] == 'SI') {
                  global.itemsPDF.add(Productos_PDF(
                      nombre: global.items[i].nombre,
                      cant: global.nTickets[i],
                      desc: global.nDescuento[i],
                      precio: double.parse(global.items[i].precio)
                          .toStringAsFixed(2)));
                }
                print('aqui lenth' + global.itemsPDF.length.toString());
                items.add(Productos(
                    codigo: int.parse(global.items[i].codigo),
                    nombre_producto: global.items[i].nombre,
                    cant: global.nTickets[i],
                    desc: global.nDescuento[i],
                    facturar: global.nfacturaSiNo[i],
                    tipo: global.items[i].tipo,
                    serie_producto: global.items[i].serie,
                    codigo_serie: global.items[i].serie == 'SI'
                        ? int.parse(global.serieProducts[i].codigo)
                        : 0,
                    nombre_serie: global.items[i].serie == 'SI'
                        ? global.serieProducts[i].serie1
                        : 'SN'));
              }
              if (global.itemsAdcionales.isNotEmpty) {
                for (var y = 0; y <= global.itemsAdcionales.length - 1; y++) {
                  print('voy for adi $y');
                  if (global.nfacturaSiNoAdicional[y] == 'SI') {
                    global.itemsPDF.add(Productos_PDF(
                        nombre: global.itemsAdcionales[y].nombre,
                        cant: global.nTicketsAdicionales[y],
                        desc: global.nDescuentoAdicional[y],
                        precio: double.parse(global.itemsAdcionales[y].precio)
                            .toStringAsFixed(2)));
                  }
                  print('aqui lenth 2 ' + global.itemsPDF.length.toString());
                  itemsAdicionales.add(Productos(
                      codigo: int.parse(global.itemsAdcionales[y].codigo),
                      nombre_producto: global.itemsAdcionales[y].nombre,
                      cant: global.nTicketsAdicionales[y],
                      desc: global.nDescuentoAdicional[y],
                      facturar: global.nfacturaSiNoAdicional[y],
                      tipo: global.itemsAdcionales[y].tipo,
                      serie_producto: global.itemsAdcionales[y].serie,
                      codigo_serie: global.itemsAdcionales[y].serie == 'SI'
                          ? int.parse(global.serieProductsAdicional[y].codigo)
                          : 0,
                      nombre_serie: global.itemsAdcionales[y].serie == 'SI'
                          ? global.serieProductsAdicional[y].serie1
                          : 'SN'));
                }
              } else {
                itemsAdicionales.add(Productos(
                    codigo: 0,
                    nombre_producto: '',
                    cant: 0,
                    desc: 0,
                    facturar: '',
                    tipo: '',
                    serie_producto: '',
                    codigo_serie: 0,
                    nombre_serie: ''));
              }
              print('aqui mi lista para enviar:  ' + items.toString());
              await SemiFactura(
                      global.codigo_clienteSoporte,
                      global.id_pk,
                      global.codigo_servicioDetSoporte,
                      global.tipocondicion.toUpperCase(),
                      solucionController.text == ''
                          ? 'SN'
                          : solucionController.text,
                      global.factura_SI_NO,
                      global.ProductAdiciSoport,
                      global.id_tecnico,
                      txtCant.text == '' ? '0' : txtCant.text.toString(),
                      items.toString(),
                      itemsAdicionales.toString(),
                      global.btnRecibeProd == true ? 'SI' : 'NO',
                      retiraProductosController.text,
                      global.selectAcomp.toString(),
                      latitude.toString(),
                      longitude.toString(),
                      global.btnUpdateCoords == true ? 'SI' : 'NO',
                      global.nCuotasAdicionales,
                      global.persona_presente)
                  .then((value) {
                print(value.toString());
                if (value == null) {
                  setState(() {
                    progressDialog.dismiss();
                  });
                  mostrarErrorMSG(context, "NO hay conexion con el servidor");
                  return;
                }
                if (value['success'] == 'OK') {
                  if (global.tipocondicion == 'Procedente') {
                    global.items.clear();
                    global.nTicketsAdicionales.clear();
                    global.nfacturaSiNo.clear();
                    global.serieProducts.clear();
                    global.nDescuento.clear();
                  }
                  setState(() {
                    global.codigo_clienteSoporte = '';
                    global.id_pk = '';
                    global.codigo_servicioDetSoporte = '';
                    solucionController.text = '';
                    global.detalleSoluSoporte = '';
                    global.tipocondicion = 'Seleccionar';
                    global.colorFact = '2';
                    global.ProductAdSoport = false;
                    global.isProcedenteSoporte = false;
                    global.factura_SI_NO = 'NO';
                    global.persona_presente = '';
                    global.persona_presente = '';
                    // global.items.clear();
                    // global.nTicketsAdicionales
                    //     .clear();
                    // global.nfacturaSiNo.clear();
                    // global.serieProducts.clear();
                    // global.nDescuento.clear();

                    txtCant.text = '';

                    txtCant.text = '';
                    global.ischeckedCoord = false;
                    global.updateCoords = false;
                    global.btnUpdateCoords = false;
                    global.facturaOficina = false;
                    global.visiblecuotasadi = false;
                  });

                  progressDialog.dismiss();
                  print(global.itemsPDF);
                  if (global.itemsPDF.isEmpty || global.itemsPDF == []) {
                    /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActionScreens(
                                        message: value['mensaje'],
                                        type: 'SUCCESS',
                                      ))); */
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => ActionScreens(
                                  message: value['mensaje'],
                                  type: 'SUCCESS',
                                )),
                        (Route<dynamic> route) => false);
                  } else {
                    setState(() {
                      global.numFactura = value['secuencial'];
                    });

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const PDFScreen()),
                        (Route<dynamic> route) => false);
                  }
                } else if (value['success'] == 'ERROR') {
                  progressDialog.dismiss();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActionScreens(
                                message: value['mensaje'],
                                type: 'ERROR',
                              )));
                  /* Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ActionScreens(
                                      message: value['mensaje'],
                                      type: 'ERROR',
                                    )),
                            (Route<dynamic> route) => false); */
                }
              });
            }
          } else {
            AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dialogType: DialogType.error,
              body: Column(
                children: [
                  Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'No estas conectado a ',
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'INTERNET ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                  text: 'o estas teniendo una señal con ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                    text: 'INTERMITENCIA.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ])))
                ],
              ),
              btnOkOnPress: () {},
              btnOkText: 'Aceptar',
            ).show();
          }
        },
        child: Container(
            width: varWidth * 0.6,
            height: varHeight * 0.05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorFondo.BTNUBI),
            child: Center(
              child: Text(
                'Registrar solución'.toUpperCase(),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            )),
      ),
    );
  }

  Widget facturaOficina() {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;
    return Center(
      child: GestureDetector(
        onTap: () async {
          if (inter == true) {
            print('Pos aca');
            global.items.forEach(print);

            ProgressDialog progressDialog = ProgressDialog(context);
            progressDialog.show();

            print('aqui');
            print(_currentPosition?.latitude);
            print(_currentPosition?.longitude);

            setState(() {
              latitude = _currentPosition?.latitude != '' &&
                      _currentPosition?.latitude != null
                  ? _currentPosition?.latitude.toString()
                  : '0';
              longitude = _currentPosition?.longitude != '' &&
                      _currentPosition?.longitude != null
                  ? _currentPosition?.longitude.toString()
                  : '0';
            });

            print(global.tipocondicion);
            if (solucionController.text.isEmpty) {
              progressDialog.dismiss();
              mostrarError(context, 'Detalle una solucion para continuar');
            } else if (global.persona_presente.isEmpty) {
              progressDialog.dismiss();
              mostrarError(context, 'Campo Nombre del Cliente Vacio');
            } else if (global.tipocondicion == 'Seleccionar') {
              progressDialog.dismiss();
              mostrarError(context, 'Seleccione una categoría de solución');
            } else if (global.checkBoxValue == true && global.items.isEmpty) {
              //TOAST
              AwesomeDialog(
                      context: context,
                      dialogType: DialogType.infoReverse,
                      animType: AnimType.bottomSlide,
                      //headerAnimationLoop: true,
                      title:
                          'Recuerda que debes seleccionar los nuevos productos dejados en el sitio',
                      dialogBackgroundColor: Colors.white,
                      //  desc: 'Por favor, cambie e intente nuevamente.',
                      btnOkOnPress: () {
                        //Navigator.pop(context);
                        progressDialog.dismiss();
                      },
                      btnOkText: 'Aceptar',
                      btnOkColor: ColorFondo.BTNUBI)
                  .show();
            } /* else if (global.items.isEmpty &&
              global.tipocondicion != 'Procedente') {
            progressDialog.dismiss();
            mostrarError(
                context, 'Seleccione un producto o servicio para finalizar');
          } */
            else if (global.selectAcomp == 'Seleccionar') {
              progressDialog.dismiss();
              mostrarError(
                  context, 'Seleccione un tecnico auxiliar para finalizar');
            } /* else if (double.parse(txtCant.text == '' ? '0' : txtCant.text) >
              tot) {
            progressDialog.dismiss();
            mostrarError(context,
                'El monto no debe ser mayor a ${tot.toStringAsFixed(2)}');
          } */
            else {
              setState(() {
                print('aqui ando');
                global.nomAuxiliar = global.selectAcomp;
                global.valorCobrado =
                    txtCant.text != '' ? double.parse(txtCant.text) : 0.0;
                print(global.nomAuxiliar);
                buttonEnabled = false;
              });
              items.clear();
              itemsAdicionales.clear();
              global.itemsPDF.clear();
              print('ingrese antes for');
              print(global.items.length - 1);
              print(global.nTickets.length);
              for (var i = 0; i <= global.items.length - 1; i++) {
                print('voy for $i');
                if (global.nfacturaSiNo[i] == 'SI') {
                  global.itemsPDF.add(Productos_PDF(
                      nombre: global.items[i].nombre,
                      cant: global.nTickets[i],
                      desc: global.nDescuento[i],
                      precio: double.parse(global.items[i].precio)
                          .toStringAsFixed(2)));
                }
                print('aqui lenth' + global.itemsPDF.length.toString());
                items.add(Productos(
                    codigo: int.parse(global.items[i].codigo),
                    nombre_producto: global.items[i].nombre,
                    cant: global.nTickets[i],
                    desc: global.nDescuento[i],
                    facturar: global.nfacturaSiNo[i],
                    tipo: global.items[i].tipo,
                    serie_producto: global.items[i].serie,
                    codigo_serie: global.items[i].serie == 'SI'
                        ? int.parse(global.serieProducts[i].codigo)
                        : 0,
                    nombre_serie: global.items[i].serie == 'SI'
                        ? global.serieProducts[i].serie1
                        : 'SN'));
              }
              if (global.itemsAdcionales.isNotEmpty) {
                for (var y = 0; y <= global.itemsAdcionales.length - 1; y++) {
                  print('voy for adi $y');
                  if (global.nfacturaSiNoAdicional[y] == 'SI') {
                    global.itemsPDF.add(Productos_PDF(
                        nombre: global.itemsAdcionales[y].nombre,
                        cant: global.nTicketsAdicionales[y],
                        desc: global.nDescuentoAdicional[y],
                        precio: double.parse(global.itemsAdcionales[y].precio)
                            .toStringAsFixed(2)));
                  }
                  print('aqui lenth 2 ' + global.itemsPDF.length.toString());
                  itemsAdicionales.add(Productos(
                      codigo: int.parse(global.itemsAdcionales[y].codigo),
                      nombre_producto: global.itemsAdcionales[y].nombre,
                      cant: global.nTicketsAdicionales[y],
                      desc: global.nDescuentoAdicional[y],
                      facturar: global.nfacturaSiNoAdicional[y],
                      tipo: global.itemsAdcionales[y].tipo,
                      serie_producto: global.itemsAdcionales[y].serie,
                      codigo_serie: global.itemsAdcionales[y].serie == 'SI'
                          ? int.parse(global.serieProductsAdicional[y].codigo)
                          : 0,
                      nombre_serie: global.itemsAdcionales[y].serie == 'SI'
                          ? global.serieProductsAdicional[y].serie1
                          : 'SN'));
                }
              } else {
                itemsAdicionales.add(Productos(
                    codigo: 0,
                    nombre_producto: '',
                    cant: 0,
                    desc: 0,
                    facturar: '',
                    tipo: '',
                    serie_producto: '',
                    codigo_serie: 0,
                    nombre_serie: ''));
              }
              print('aqui mi lista para enviar:  ' + items.toString());
              await SemiFacturaPendiente(
                      global.codigo_clienteSoporte,
                      global.id_pk,
                      global.codigo_servicioDetSoporte,
                      global.tipocondicion.toUpperCase(),
                      solucionController.text == ''
                          ? 'SN'
                          : solucionController.text,
                      global.factura_SI_NO,
                      global.ProductAdiciSoport,
                      global.id_tecnico,
                      txtCant.text == '' ? '0' : txtCant.text.toString(),
                      items.toString(),
                      itemsAdicionales.toString(),
                      global.btnRecibeProd == true ? 'SI' : 'NO',
                      retiraProductosController.text,
                      global.selectAcomp.toString(),
                      latitude.toString(),
                      longitude.toString(),
                      global.btnUpdateCoords == true ? 'SI' : 'NO',
                      global.nCuotas,
                      global.persona_presente,
                      global.nCuotasAdicionales)
                  .then((value) {
                print(value.toString());
                if (value == null) {
                  setState(() {
                    progressDialog.dismiss();
                  });
                  mostrarErrorMSG(context, "NO hay conexion con el servidor");
                  return;
                }
                if (value['success'] == 'OK') {
                  if (global.tipocondicion == 'Procedente') {
                    global.items.clear();
                    global.nTicketsAdicionales.clear();
                    global.nfacturaSiNo.clear();
                    global.serieProducts.clear();
                    global.nDescuento.clear();
                  }
                  setState(() {
                    global.codigo_clienteSoporte = '';
                    global.id_pk = '';
                    global.codigo_servicioDetSoporte = '';
                    solucionController.text = '';
                    global.detalleSoluSoporte = '';
                    global.tipocondicion = 'Seleccionar';
                    global.colorFact = '2';
                    global.ProductAdSoport = false;
                    global.isProcedenteSoporte = false;
                    global.factura_SI_NO = 'NO';

                    txtCant.text = '';
                    global.updateCoords = false;
                    global.btnUpdateCoords = false;
                    global.tipo_factura_soporte = 'Facturacion Automatica';
                    global.persona_presente = '';
                    global.persona_presente = '';
                    global.visiblecuotasadi = false;
                  });

                  print(value);
                  progressDialog.dismiss();
                  print(global.itemsPDF);
                  if (global.itemsPDF.isEmpty || global.itemsPDF == []) {
                    /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ActionScreens(
                                        message: value['mensaje'],
                                        type: 'SUCCESS',
                                      ))); */
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => ActionScreens(
                                  message: value['mensaje'],
                                  type: 'SUCCESS',
                                )),
                        (Route<dynamic> route) => false);
                  } else {
                    setState(() {
                      global.numFactura = value['secuencial'];
                    });

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const PDFScreen()),
                        (Route<dynamic> route) => false);
                  }
                } else if (value['success'] == 'ERROR') {
                  progressDialog.dismiss();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActionScreens(
                                message: value['mensaje'],
                                type: 'ERROR',
                              )));
                  /* Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ActionScreens(
                                      message: value['mensaje'],
                                      type: 'ERROR',
                                    )),
                            (Route<dynamic> route) => false); */
                }
              });
            }
          } else {
            AwesomeDialog(
              context: context,
              dismissOnTouchOutside: false,
              dialogType: DialogType.error,
              body: Column(
                children: [
                  Center(
                      child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: 'No estas conectado a ',
                              style: TextStyle(color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'INTERNET ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                TextSpan(
                                  text: 'o estas teniendo una señal con ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                    text: 'INTERMITENCIA.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ])))
                ],
              ),
              btnOkOnPress: () {},
              btnOkText: 'Aceptar',
            ).show();
          }
        },
        child: Container(
            width: varWidth * 0.6,
            height: varHeight * 0.05,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: ColorFondo.BTNUBI),
            child: Center(
              child: Text(
                'Registrar solución'.toUpperCase(),
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),
              ),
            )),
      ),
    );
  }
}

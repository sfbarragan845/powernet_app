import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:powernet/app/api/internas/public/delete/migration/api_anular_Migracion.dart';
import 'package:powernet/app/api/internas/public/insert/migration/api_facturar_migracion.dart';
import 'package:powernet/app/pages/public/recursos/recursos.dart';

import '../../../../api/internas/public/insert/migration/api_facturar_pendiente_migracion.dart';
import '../../../../clases/cConfig_UI.dart';
import '../../../../models/pdf/producto_Pdf.dart';
import '../../../components/mostrar_snack.dart';
import '../../../components/progress.dart';
import '../../actionScreens/action_screens.dart';
import '../../home/screens/home.dart';
import '../../productos/widgets/buscar_listado_productos.dart';
import '../../report_pdf/screens/pdf_screenIncidente.dart';
import '/app/models/var_global.dart' as global;

class Productos {
  //final int num;
  final String nombre_serie;
  final int cant;
  final String nombre_producto;
  final int codigo_serie;
  final int codigo;
  final String facturar;
  final String tipo;
  final String serie_producto;
  final int desc;

  Productos({
    //required this.num,
    required this.nombre_serie,
    required this.cant,
    required this.nombre_producto,
    required this.codigo_serie,
    required this.codigo,
    required this.facturar,
    required this.tipo,
    required this.serie_producto,
    required this.desc,
  });
  @override
  toString() =>
      '{"codigo_producto":"$codigo","nombre_producto":"$nombre_producto","cantidad":"$cant","facturar":"$facturar","tipo":"$tipo","serie_producto":"$serie_producto","codigo_serie":"$codigo_serie","nombre_serie":"$nombre_serie","porcentaje_descuento":"$desc"}';
}

class RegistrarMigracion extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => RegistrarMigracion(),
    );
  }

  @override
  _RegistrarMigracionState createState() => _RegistrarMigracionState();
}

class _RegistrarMigracionState extends State<RegistrarMigracion> {
  List<Productos> items = [];
  List<Productos> itemsAdicionales = [];
  var suma = 0;
  final solucionController =
      TextEditingController(text: global.detalleSoluMigracion);
  final facturaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final txtCant = TextEditingController();
  final txtCantProd = TextEditingController();
  bool existPrest = false;
  //bool _factura = false;
  //String _factura_SI_NO = '';
  final razonSinSoporteController = TextEditingController();
  final retiraProductosController =
      TextEditingController(text: global.detalleEquiposRetirados);
  Color _btnFactura = Color.fromARGB(255, 214, 214, 214);
  String? latitude = '';
  String? longitude = '';
  Position? _currentPosition;
  bool buttonEnabled = true;
  final ImagePicker _picker = ImagePicker();
  final _tipoFactura = ['Facturacion Automatica', 'Facturar en Oficina'];
  final _cuotas = ['1', '2', '3', '4', '5'];
  final _cuotasAdicionales = ['1', '2', '3', '4', '5'];
  final client_name = TextEditingController(text: global.persona_presente);
  var listener;
  bool inter = true;
  @override
  void initState() {
    super.initState();
    print('aqui variable con fallo');
    print(global.codigo_servicio_DetMigracion);
    if (global.deleteImg) {
      setState(() {
        global.fileImageHouse = null;
        global.fileImageInstalation = null;
        global.updateCoords = false;
        global.btnUpdateCoords = false;
        global.tipo_factura_migracion = 'Facturacion Automatica';
        global.tipo_factura_migracionAdicional = 'Facturacion Automatica';
        global.ProductAdiciInsta = 'NO';
        global.nCuotas = '1';
        global.btnFacturaOficina = false;
      });
    }
    initTotal();
    valorDelArrayFactProAdicionales();
    _getCurrentPosition();
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
  }

  void valorDelArrayFactProAdicionales() {
    if (global.itemsAdcionales.isNotEmpty) {
      if (global.tipo_factura_migracion == 'Facturacion Automatica') {
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
          global.nfacturaSiNoAdicional[i] = 'NO';
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

  double tot1 = 0.0;
  double tot2 = 0.0;
  double tot = 0.0;
  void initTotal() {
    tot = 0.0;
    tot1 = 0.0;
    tot2 = 0.0;
    if (global.items == [] || global.items.isEmpty) {
      print('no hago total');
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
            tot2 = 0.0;
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
            tot2 = 0.0;
          }
        }
        //tot = tot1 + tot2;
      }
      for (var p = 0; p <= global.nTicketsAdicionales.length - 1; p++) {
        /*  _nTotal
            .add((global.nTickets[y] * double.parse(global.items[y].precio))); */
        if (global.nfacturaSiNoAdicional[p] == 'SI') {
          tot1 = tot1 +
              double.parse(((global.nTicketsAdicionales[p].toDouble() *
                          double.parse(global.itemsAdcionales[p].precio)) -
                      (((global.nDescuentoAdicional[p] / 100) *
                          (double.parse(global.itemsAdcionales[p].precio)) *
                          global.nTicketsAdicionales[p].toDouble())))
                  .toStringAsFixed(2));
          if (tot1 < 0) {
            tot2 = 0.0;
          }
        } else {
          tot2 = tot2 +
              double.parse(((global.nTicketsAdicionales[p].toDouble() *
                          double.parse(global.itemsAdcionales[p].precio)) -
                      (((global.nDescuentoAdicional[p] / 100) *
                          (double.parse(global.itemsAdcionales[p].precio)) *
                          global.nTicketsAdicionales[p].toDouble())))
                  .toStringAsFixed(2));
          if (tot2 < 0) {
            tot2 = 0.0;
          }
        }
      }
      tot = tot1;
    }
  }

  //FOTO
  Future<void> _showSelectionDialog(BuildContext context, String tipo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("¿Cómo desea subir la imagen?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: const Icon(
                              Icons.camera_alt,
                              color: ColorFondo.PRIMARY,
                            ),
                            title: const Text('Cámara'),
                            onTap: () => _openCameraDisp(context),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            leading: const Icon(
                              Icons.drive_folder_upload,
                              color: ColorFondo.PRIMARY,
                            ),
                            title: const Text('Galería'),
                            onTap: () => _openGalleryDisp(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
        });
  }

  //IMAGEN DISPOSITIVOS
  void _openGalleryDisp(BuildContext context) async {
    var picture = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 50);
    if (picture != null) {
      setState(() {
        switch (global.numImageInstalation) {
          case 1:
            global.imageInstalation = picture;
            if (global.imageInstalation != null) {
              // Checking if global.imageHouse is not null
              global.fileImageInstalation = File(global.imageInstalation!
                  .path); // Creating a new File with the path from global.imageHouse
            }
            break;
        }
      });
    }
    Navigator.of(context).pop();
    if (global.imageInstalation != null) {
      //_postEnviarfoto.call();
    }
  }

  void _openCameraDisp(BuildContext context) async {
    var picture = await _picker.pickImage(source: ImageSource.camera,imageQuality: 50);
    if (picture != null) {
      setState(() {
        switch (global.numImageInstalation) {
          case 1:
            global.imageInstalation = picture;
            if (global.imageInstalation != null) {
              global.fileImageInstalation = File(global.imageInstalation!.path);
            }
            break;
        }
      });
    }
    Navigator.of(context).pop();
    if (global.imageInstalation != null) {
      //_postEnviarfoto.call();
    }
  }

  @override
  dispose() {
    // Es importante SIEMPRE realizar el dispose del controller.
    solucionController.dispose();
    facturaController.dispose();
    txtCantProd.dispose();
    txtCant.dispose();
    razonSinSoporteController.dispose();
    retiraProductosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
        title: Text('Registrar Migración',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: ColorFondo.PRIMARY,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: varWidth,
              padding: EdgeInsets.all(16),
              color: ColorFondo.BTNUBI,
              child: Text(
                  'Cod. ${global.codigo_servicio_DetMigracion_mostrar} - ${global.cliente_DetMigracion}',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('¿Se migró el servio?'),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                  activeColor: ColorFondo.PRIMARY,
                                  value: 'SI',
                                  groupValue: global.procedeMigracion,
                                  onChanged: (valueAd) {
                                    this.setState(() {
                                      global.procedeMigracion =
                                          valueAd.toString();
                                      global.isRealizaMigracion = true;
                                      razonSinSoporteController.text = '';
                                    });
                                    //initTotal();
                                    //global.ProductAdSoport = true;
                                  }),
                              Text('SI', style: TextStyle(color: Colors.black)),
                              SizedBox(
                                width: 5,
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                  activeColor: ColorFondo.PRIMARY,
                                  value: 'NO',
                                  groupValue: global.procedeMigracion,
                                  onChanged: (valueAd) {
                                    this.setState(() {
                                      global.selectAcomp = 'Seleccionar';
                                      global.procedeMigracion =
                                          valueAd.toString();
                                      global.isRealizaMigracion = false;
                                      global.tipocondicion = 'Seleccionar';
                                      global.colorFact = '2';
                                      global.ProductAdSoport = false;
                                      global.isProcedenteSoporte = false;
                                      global.factura_SI_NO = 'NO';
                                      global.itemsAdcionales.clear();
                                      global.nTicketsAdicionales.clear();
                                      // global.nfacturaSiNo.clear();
                                      global.nfacturaSiNoAdicional.clear();
                                      global.serieProductsAdicional.clear();
                                      global.nDescuentoAdicional.clear();
                                      txtCant.text = '';
                                      global.checkBoxValue = false;
                                      global.ischecked = true;
                                      global.btnRecibeProd = false;
                                      retiraProductosController.text = '';
                                      global.updateCoords = false;
                                    });
                                  }),
                              Text('NO', style: TextStyle(color: Colors.black)),
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
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Tipo de Facturación:')),
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.only(left: 8, right: 8),
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
                      global.tipo_factura_migracion = valor.toString();
                      if (global.tipo_factura_migracion ==
                          'Facturar en Oficina') {
                        global.btnFacturaOficina = true;
                      } else {
                        global.btnFacturaOficina = false;
                        global.nCuotas = '1';
                      }
                    })
                  },
                  hint: Text(
                    global.tipo_factura_migracion,
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
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.only(left: 8, right: 8),
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
            Visibility(
              visible: global.isRealizaMigracion,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Seleccionar Auxiliar:'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                        //margin: EdgeInsets.all(10),
                        padding: EdgeInsets.only(left: 8, right: 8),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: sombra(Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: client_name,
                        textCapitalization: TextCapitalization.characters,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            child: Text('Observación:'),
                          ),
                          Column(
                            children: <Widget>[
                              sombra(Card(
                                  child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    global.detalleSoluMigracion =
                                        value.toString();
                                  },
                                  controller: solucionController,
                                  maxLines: 8,
                                  decoration: InputDecoration.collapsed(
                                      hintText: "Escriba aquí la solución"),
                                ),
                              )))
                            ],
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text('Foto de los dispositivos instalados',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                          ),
                          Center(
                            child: Stack(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      global.numImageInstalation = 1;
                                      _showSelectionDialog(
                                          context, 'DISPOSITIVOS');
                                    });
                                  },
                                  child: Container(
                                    //radius: 45,
                                    child: global.fileImageInstalation == null
                                        ? Image.asset(
                                            'assets/images/placeholder.png',
                                            fit: BoxFit.cover)
                                        : Image.file(
                                            global.fileImageInstalation!,
                                          ),
                                    width: varWidth / 1.2,
                                    height: 250,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: const Offset(0, 10))
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          global.numImageInstalation = 1;
                                          _showSelectionDialog(
                                              context, 'DISPOSITIVOS');
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 4,
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                          ),
                                          color: ColorFondo.PRIMARY,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 35,
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
                                              color: Colors.black,
                                              fontSize: 14),
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
                                              dialogType:
                                                  DialogType.infoReverse,
                                              animType: AnimType.bottomSlide,
                                              //headerAnimationLoop: true,
                                              title:
                                                  'Recuerda que debes seleccionar los nuevos productos dejados en el sitio',
                                              dialogBackgroundColor:
                                                  Colors.white,
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
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  sombra(Card(
                                      //color: Color.fromARGB(255, 233, 229, 229),
                                      child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextField(
                                      textCapitalization:
                                          TextCapitalization.characters,
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          global.numAdicioanl = 0;
                                          global.tipocondicion = 'Seleccionar';
                                        });
                                        Navigator.of(context).pushReplacement(
                                            BuscarProduct.route('MIGRATION'));
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
                                                  'Agregar Productos'
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                  child: Text('Detalle de la Factura:'),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                /* Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, left: 10.0, right: 30.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'TOTAL: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '${tot.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ), */
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
                                                  (BuildContext context,
                                                          int index) =>
                                                      const Divider(
                                                color: Colors.black,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Dismissible(
                                                  onDismissed: (DismissDirection
                                                      direction) {
                                                    for (var i = 0;
                                                        i <=
                                                            global.arrayPrestacionInst
                                                                    .length -
                                                                1;
                                                        i++) {
                                                      if (global.items[index]
                                                              .codigo ==
                                                          global
                                                              .arrayPrestacionInst[
                                                                  i]
                                                              .codigo_prestacion) {
                                                        setState(() {
                                                          existPrest = true;
                                                        });

                                                        //print('aqui codigo pres'+ global.arrayPrestacionInst[i].codigo_prestacion);
                                                        print('aqui codigo' +
                                                            global.items[index]
                                                                .codigo);
                                                        print('aquibool' +
                                                            existPrest
                                                                .toString());
                                                        break;
                                                      } else {
                                                        setState(() {
                                                          existPrest = false;
                                                        });
                                                        //print('aqui codigo pres'+ global.arrayPrestacionInst[i].codigo_prestacion);
                                                        print('aqui codigo' +
                                                            global.items[index]
                                                                .codigo);
                                                        print('aquibool' +
                                                            existPrest
                                                                .toString());
                                                      }
                                                    }
                                                    setState(() {
                                                      if (existPrest == true) {
                                                        print('no borro');
                                                      } else {
                                                        global.items
                                                            .removeAt(index);
                                                        global.nTickets
                                                            .removeAt(index);
                                                        //global.nDescuento.removeAt(index);
                                                        global.nfacturaSiNo
                                                            .removeAt(index);
                                                        global.serieProducts
                                                            .removeAt(index);
                                                        global.nDescuento
                                                            .removeAt(index);
                                                        initTotal();
                                                      }
                                                    });
                                                    initTotal();
                                                    print(global.items.length);
                                                    print(
                                                        tot.toStringAsFixed(2));
                                                  },
                                                  secondaryBackground:
                                                      Container(
                                                    child: Center(
                                                      child:
                                                          global.codigo_PrestacionInst ==
                                                                  global
                                                                      .items[
                                                                          index]
                                                                      .codigo
                                                              ? Text(
                                                                  'No se puede Eliminar',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              : Text(
                                                                  'Eliminar?',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
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
                                                                  .items[index]
                                                                  .nombre,
                                                              style: TextStyle(
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
                                                      Visibility(
                                                        visible: global
                                                                    .items[
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
                                                                            FontWeight.bold),
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
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14,
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
                                                                            activeColor: ColorFondo
                                                                                .PRIMARY,
                                                                            value:
                                                                                'SI',
                                                                            groupValue:
                                                                                global.nfacturaSiNo[index],
                                                                            onChanged: null /* global.codigo_PrestacionInst ==
                                                                                    global.items[index].codigo
                                                                                ? null
                                                                                : global.factura == true
                                                                                    ? (value) {
                                                                                        global.nfacturaSiNo[index] = value.toString();
                                                                                        print(global.nfacturaSiNo);
                                                                                        //initTotal();
                                                                                        setState(() {});
                                                                                      }
                                                                                    : null */
                                                                            ),
                                                                        Text(
                                                                            'SI',
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
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
                                                                            activeColor: ColorFondo
                                                                                .PRIMARY,
                                                                            value:
                                                                                'NO',
                                                                            groupValue:
                                                                                global.nfacturaSiNo[index],
                                                                            onChanged: null /* global.codigo_PrestacionInst ==
                                                                                    global.items[index].codigo
                                                                                ? null
                                                                                : global.factura == true
                                                                                    ? (value) {
                                                                                        
                                                                                        global.nfacturaSiNo[index] = value.toString();
                                                                                        print(global.nfacturaSiNo);
                                                                                        setState(() {});
                                                                                        //initTotal();
                                                                                      }
                                                                                    : null */
                                                                            ),
                                                                        Text(
                                                                            'NO',
                                                                            style:
                                                                                TextStyle(color: Colors.black)),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
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
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor: global
                                                                            .factura ==
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
                                                                          .all(
                                                                          3.0),
                                                                  child:
                                                                      FittedBox(
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
                                                                              context: context,
                                                                              builder: (BuildContext context) {
                                                                                return AlertDialog(
                                                                                  title: const Text("Cantidad"),
                                                                                  content: TextField(
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
                                                                  color: Colors
                                                                      .black,
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
                                                              width: 150,
                                                              height: 70,
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    'Cant.',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                                            if (global.items[index].tipo ==
                                                                                'PRODUCTO') {
                                                                              if (global.nTickets[index] > 1) {
                                                                                global.nTickets[index] = global.nTickets[index] - 1;
                                                                                tot = tot - double.parse(global.items[index].precio);
                                                                              } else {
                                                                                global.nTickets[index] = global.nTickets[index];
                                                                              }
                                                                              print(global.nTickets);
                                                                            } else {
                                                                              null;
                                                                            }
                                                                          });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .do_disturb_on_outlined,
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (global.items[index].tipo ==
                                                                              'PRODUCTO') {
                                                                            if (global.items[index].serie ==
                                                                                'NO') {
                                                                              if (global.nTickets[index] < int.parse(global.items[index].stock)) {
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
                                                                                global.nTickets[index] = global.nTickets[index];
                                                                                print('mi cantidad siiiii:' + '${global.nTickets[index].toString()}');
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
                                                                        child:
                                                                            Text(
                                                                          '${global.nTickets[index]}',
                                                                          style: TextStyle(
                                                                              color: global.nTickets[index] == 0 ? Colors.red : Colors.green,
                                                                              fontSize: 15),
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          print('aqui index:  ?' +
                                                                              global.items[index].toString());
                                                                          setState(
                                                                              () {
                                                                            if (global.items[index].tipo ==
                                                                                'PRODUCTO') {
                                                                              if (global.items[index].serie == 'NO') {
                                                                                if (global.nTickets[index] < int.parse(global.items[index].stock)) {
                                                                                  global.nTickets[index] = global.nTickets[index] + 1;
                                                                                  print('mi cantidad:' + '${global.nTickets[index].toString()}');
                                                                                  print(global.nTickets);
                                                                                } else {
                                                                                  global.nTickets[index] = global.nTickets[index];
                                                                                  print('mi cantidad siiiii:' + '${global.nTickets[index].toString()}');
                                                                                }
                                                                                tot = 0;
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
                                                                        child: Icon(
                                                                            Icons.add_circle_outline),
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
                                                                            FontWeight.bold),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Text(
                                                                      double.parse(global
                                                                              .items[
                                                                                  index]
                                                                              .precio)
                                                                          .toStringAsFixed(
                                                                              2),
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
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
                                                                      child:
                                                                          Text(
                                                                    'Total',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
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
                                                                    /*  - ((global.nDescuento[index] / 100) * (global.nTickets[index].toDouble() * double.parse(global.items[index].precio)))).toStringAsFixed(2)} */
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
                                                  direction: DismissDirection
                                                      .endToStart,
                                                );
                                              },
                                            )
                                          : Center(
                                              child: Text(
                                                  'Sin productos seleccionados')),
                                    ),
                                  ),
                                ),
                                Padding(
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
                                                      groupValue: global
                                                          .ProductAdiciInsta,
                                                      onChanged: (valueAd) {
                                                        this.setState(() {
                                                          global.ProductAdiciInsta =
                                                              valueAd
                                                                  .toString();
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
                                                      groupValue: global
                                                          .ProductAdiciInsta,
                                                      onChanged: (valueAd) {
                                                        global.ProductAdSoport =
                                                            false;
                                                        global.itemsAdcionales
                                                            .clear();
                                                        initTotal();
                                                        this.setState(() {
                                                          global.ProductAdiciInsta =
                                                              valueAd
                                                                  .toString();
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
                                Visibility(
                                  visible: global.ProductAdiciInsta == 'SI'
                                      ? true
                                      : false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  global.numAdicioanl = 1;
                                                });
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        BuscarProduct.route(
                                                            'MIGRATION'));
                                              },
                                              child: Container(
                                                  width: varWidth * 0.6,
                                                  height: varHeight * 0.05,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
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
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Montserrat'),
                                                        ),
                                                        Icon(
                                                          Icons
                                                              .add_shopping_cart,
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
                                Visibility(
                                    visible: global.visiblecuotasadi,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(20),
                                          child: Text(
                                              'Cuotas de productos adicionales:'),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 8,
                                              right: 8,
                                              top: 5,
                                              bottom: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white, //blue
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          width: varWidth,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              dropdownColor: Colors.white,
                                              isExpanded: true,
                                              items: _cuotasAdicionales
                                                  .map((String a) {
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
                                  visible: global.ProductAdiciInsta == 'SI'
                                      ? true
                                      : false,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SingleChildScrollView(
                                      //scrollDirection: Axis.horizontal,
                                      child: Container(
                                        height: 300,
                                        child: global.itemsAdcionales.length > 0
                                            ? ListView.separated(
                                                itemCount: global
                                                    .itemsAdcionales.length,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        const Divider(
                                                  color: Colors.black,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Dismissible(
                                                    onDismissed:
                                                        (DismissDirection
                                                            direction) {
                                                      setState(() {
                                                        global.itemsAdcionales
                                                            .removeAt(index);
                                                        global
                                                            .nTicketsAdicionales
                                                            .removeAt(index);
                                                        global
                                                            .nfacturaSiNoAdicional
                                                            .removeAt(index);
                                                        global
                                                            .serieProductsAdicional
                                                            .removeAt(index);
                                                        global
                                                            .nDescuentoAdicional
                                                            .removeAt(index);
                                                      });
                                                      initTotal();
                                                    },
                                                    secondaryBackground:
                                                        Container(
                                                      child: Center(
                                                        child: Text(
                                                          'Eliminar?',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
                                                                              FontWeight.bold),
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
                                                                        fontSize:
                                                                            14,
                                                                      ),
                                                                      maxLines:
                                                                          3,
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
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Radio(
                                                                              activeColor: ColorFondo.PRIMARY,
                                                                              value: 'SI',
                                                                              groupValue: global.nfacturaSiNoAdicional[index],
                                                                              onChanged: global.tipo_factura_migracion == 'Facturacion Automatica'
                                                                                  ? (value) {
                                                                                      global.nfacturaSiNoAdicional[index] = value.toString();
                                                                                      print(global.nfacturaSiNoAdicional);
                                                                                      initTotal();
                                                                                      valorDelArrayFactProAdicionales();
                                                                                      setState(() {});
                                                                                    }
                                                                                  : null),
                                                                          Text(
                                                                              'SI',
                                                                              style: TextStyle(color: Colors.black)),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Radio(
                                                                              activeColor: ColorFondo.PRIMARY,
                                                                              value: 'NO',
                                                                              groupValue: global.nfacturaSiNoAdicional[index],
                                                                              onChanged: global.tipo_factura_migracion == 'Facturacion Automatica'
                                                                                  ? (value) {
                                                                                      global.nfacturaSiNoAdicional[index] = value.toString();
                                                                                      print(global.nfacturaSiNoAdicional);
                                                                                      Fluttertoast.showToast(msg: "Verificar cuotas adicionales", gravity: ToastGravity.CENTER, backgroundColor: Color.fromARGB(239, 81, 193, 233), toastLength: Toast.LENGTH_LONG, textColor: Colors.black);
                                                                                      valorDelArrayFactProAdicionales();
                                                                                      setState(() {});
                                                                                      initTotal();
                                                                                    }
                                                                                  : null),
                                                                          Text(
                                                                              'NO',
                                                                              style: TextStyle(color: Colors.black)),
                                                                          SizedBox(
                                                                            width:
                                                                                5,
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
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor:
                                                                      ColorFondo
                                                                          .BTNUBI,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            3.0),
                                                                    child:
                                                                        FittedBox(
                                                                      child:
                                                                          Text(
                                                                        global
                                                                            .nDescuentoAdicional[index]
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 22),
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
                                                                          title:
                                                                              const Text("Cantidad"),
                                                                          content:
                                                                              TextField(
                                                                            controller:
                                                                                txtCant,
                                                                            keyboardType:
                                                                                TextInputType.number,
                                                                            decoration: InputDecoration(
                                                                                hintText: 'Ingrese el porcentaje a descontar',
                                                                                filled: true,
                                                                                fillColor: Colors.grey.shade50),
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
                                                                                  initTotal();
                                                                                  global.nDescuentoAdicional[index] = int.parse(txtCant.text);
                                                                                }
                                                                                initTotal();
                                                                                Navigator.pop(context);
                                                                                txtCant.text = "";
                                                                              },
                                                                              child: const Text('Aceptar'),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      });
                                                                },
                                                              ),
                                                              Text(
                                                                ' %',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18),
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
                                                                width: 150,
                                                                height: 70,
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Cant.',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              if (global.itemsAdcionales[index].tipo == 'PRODUCTO') {
                                                                                if (global.nTicketsAdicionales[index] > 1) {
                                                                                  global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index] - 1;
                                                                                  tot = tot - double.parse(global.itemsAdcionales[index].precio);
                                                                                } else {
                                                                                  global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index];
                                                                                }
                                                                                print(global.nTicketsAdicionales);
                                                                                initTotal();
                                                                              } else {
                                                                                null;
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(
                                                                            Icons.do_disturb_on_outlined,
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            if (global.itemsAdcionales[index].tipo ==
                                                                                'PRODUCTO') {
                                                                              if (global.itemsAdcionales[index].serie == 'NO') {
                                                                                if (global.nTicketsAdicionales[index] < int.parse(global.itemsAdcionales[index].stock)) {
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
                                                                                  global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index];
                                                                                  print('mi cantidad siiiii:' + '${global.nTicketsAdicionales[index].toString()}');
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
                                                                          child:
                                                                              Text(
                                                                            '${global.nTicketsAdicionales[index]}',
                                                                            style:
                                                                                TextStyle(color: global.nTicketsAdicionales[index] == 0 ? Colors.red : Colors.green, fontSize: 15),
                                                                          ),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              if (global.itemsAdcionales[index].tipo == 'PRODUCTO') {
                                                                                if (global.itemsAdcionales[index].serie == 'NO') {
                                                                                  if (global.nTicketsAdicionales[index] < int.parse(global.itemsAdcionales[index].stock)) {
                                                                                    global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index] + 1;
                                                                                    print('mi cantidad:' + '${global.nTicketsAdicionales[index].toString()}');
                                                                                    print(global.nTicketsAdicionales);
                                                                                  } else {
                                                                                    global.nTicketsAdicionales[index] = global.nTicketsAdicionales[index];
                                                                                    print('mi cantidad siiiii:' + '${global.nTicketsAdicionales[index].toString()}');
                                                                                  }
                                                                                  tot = 0;
                                                                                  initTotal();
                                                                                } else {
                                                                                  null;
                                                                                }
                                                                              } else {
                                                                                null;
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Icon(Icons.add_circle_outline),
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
                                                                              FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Text(global.itemsAdcionales[index].precio,
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            fontSize:
                                                                                16),
                                                                        textAlign:
                                                                            TextAlign.center),
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
                                                                        child:
                                                                            Text(
                                                                      'Total',
                                                                      style: TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    )),
                                                                    SizedBox(
                                                                      height:
                                                                          15,
                                                                    ),
                                                                    Text(
                                                                      //'${_nTotal[index]}',
                                                                      '${((global.nTicketsAdicionales[index].toDouble() * double.parse(global.itemsAdcionales[index].precio)) - (((global.nDescuentoAdicional[index] / 100) * (double.parse(global.itemsAdcionales[index].precio)) * global.nTicketsAdicionales[index].toDouble()))).toStringAsFixed(2)}',
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
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
                                                    direction: DismissDirection
                                                        .endToStart,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Subtotal No Facturado: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Subtotal Facturado: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'TOTAL: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
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
                                                            .hasMatch(
                                                                value == null
                                                                    ? ''
                                                                    : value)) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Solo se permiten 2 decimales",
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                      239,
                                                                      81,
                                                                      193,
                                                                      233),
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              textColor: Colors
                                                                  .black); /* """
        Error:
        - El monto no debe ser mayor a ${tot.toStringAsFixed(2)}
        """; */
                                                        } else if (double.parse(
                                                                value
                                                                    .toString()) >
                                                            tot) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "El monto no debe ser mayor a ${tot.toStringAsFixed(2)}",
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              backgroundColor:
                                                                  Color.fromARGB(
                                                                      239,
                                                                      81,
                                                                      193,
                                                                      233),
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
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
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  'Ej: 5.30',
                                                              filled: true,
                                                              fillColor: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255)),
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
            Visibility(
              visible: global.isRealizaMigracion == true ? false : true,
              child: Column(
                children: [
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
                    child: Row(
                      children: [
                        Text('Detalle la razón:'),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      sombra(Card(
                          //color: Color.fromARGB(255, 233, 229, 229),
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          onChanged: (value) {
                            //global.detalleSoluSoporte = value.toString();
                          },
                          controller: razonSinSoporteController,
                          maxLines: 11,
                          decoration: InputDecoration.collapsed(
                              hintText:
                                  "Escriba aquí la razón por la que no se realizá la migración"),
                        ),
                      )))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        ProgressDialog progressDialog = ProgressDialog(context);
                        progressDialog.show();
                        if (razonSinSoporteController.text.isEmpty) {
                          progressDialog.dismiss();
                          mostrarError(
                              context, 'Detalle una razón para continuar');
                        } else {
                          setState(() {
                            latitude = _currentPosition?.latitude != '' &&
                                    _currentPosition?.latitude != null
                                ? _currentPosition?.latitude.toString()
                                : '';
                            longitude = _currentPosition?.longitude != '' &&
                                    _currentPosition?.longitude != null
                                ? _currentPosition?.longitude.toString()
                                : '';
                          });
                          AnularMigracion(
                                  global.id_pk,
                                  razonSinSoporteController.text,
                                  latitude.toString(),
                                  longitude.toString(),
                                  global.btnUpdateCoords == true ? 'SI' : 'NO',
                                  global.codigo_servicio_DetMigracion)
                              .then((_) {
                            anularMig.then((value) {
                              if (value['success'] == 'OK') {
                                setState(() {
                                  razonSinSoporteController.text = '';
                                });

                                progressDialog.dismiss();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => ActionScreens(
                                            message: value['mensaje'],
                                            type: 'SUCCESS')),
                                    (Route<dynamic> route) => false);
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
                                            type: 'ERROR')),
                                    (Route<dynamic> route) => false); */
                              }
                            });
                          });
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
                              'Registrar'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            )
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
    return Visibility(
      visible: global.items.isEmpty ? false : true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: buttonEnabled
                ? () {
                    if (inter == true) {
                      ProgressDialog progressDialog = ProgressDialog(context);
                      progressDialog.show();

                      print('aqui');
                      print(_currentPosition?.latitude);
                      print(_currentPosition?.longitude);

                      setState(() {
                        latitude = _currentPosition?.latitude != '' &&
                                _currentPosition?.latitude != null
                            ? _currentPosition?.latitude.toString()
                            : '';
                        longitude = _currentPosition?.longitude != '' &&
                                _currentPosition?.longitude != null
                            ? _currentPosition?.longitude.toString()
                            : '';
                      });
                      if (solucionController.text.isEmpty) {
                        progressDialog.dismiss();
                        mostrarError(
                            context, 'Detalle una solucion para continuar');
                      } else if (global.persona_presente.isEmpty) {
                        progressDialog.dismiss();
                        mostrarError(context, 'Campo Nombre del Cliente Vacio');
                      } else if (global.selectAcomp.toString() ==
                          'Seleccionar') {
                        progressDialog.dismiss();
                        mostrarError(context, 'Seleccione un técnico auxiliar');
                      } else if (global.checkBoxValue == true &&
                          global.items.isEmpty) {
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
                      } else if (global.fileImageInstalation == null) {
                        progressDialog.dismiss();
                        mostrarError(context, 'Adjunte las fotos del servicio');
                      } /* else if (double.parse(
                            txtCant.text == '' ? '0' : txtCant.text) >
                        tot) {
                      progressDialog.dismiss();
                      mostrarError(context,
                          'El monto no debe ser mayor a ${tot.toStringAsFixed(2)}');
                    } */
                      else {
                        setState(() {
                          print('aqui ando');
                          global.nomAuxiliar = global.selectAcomp;
                          print(txtCant.text);
                          global.valorCobrado = txtCant.text != ''
                              ? double.parse(txtCant.text)
                              : 0.0;
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
                          if (global.nfacturaSiNo[i] == 'SI') {
                            /*global.itemsPDF.add(
                                                    Productos_PDF(
                                                        nombre: global
                                                            .items[i].nombre,
                                                        cant:
                                                            global.nTickets[i],
                                                        desc: global
                                                            .nDescuento[i],
                                                        precio: global
                                                            .items[i].precio));*/
                          }
                          //print('voy for $i');
                          items.add(Productos(
                              codigo: int.parse(global.items[i].codigo),
                              nombre_producto: global.items[i].nombre,
                              cant: global.nTickets[i],
                              facturar: global.nfacturaSiNo[i],
                              tipo: global.items[i].tipo,
                              serie_producto: global.items[i].serie,
                              codigo_serie: global.items[i].serie == 'SI'
                                  ? int.parse(global.serieProducts[i].codigo)
                                  : 0,
                              nombre_serie: global.items[i].serie == 'SI'
                                  ? global.serieProducts[i].serie1
                                  : 'SN',
                              desc: global.nDescuento[i]));
                        }
                        for (var i = 0;
                            i <= global.itemsAdcionales.length - 1;
                            i++) {
                          if (global.nfacturaSiNoAdicional[i] == 'SI') {
                            global.itemsPDF.add(Productos_PDF(
                                nombre: global.itemsAdcionales[i].nombre,
                                cant: global.nTicketsAdicionales[i],
                                desc: global.nDescuentoAdicional[i],
                                precio: global.itemsAdcionales[i].precio));
                          }
                          print('voy for $i');
                          itemsAdicionales.add(Productos(
                              codigo:
                                  int.parse(global.itemsAdcionales[i].codigo),
                              nombre_producto: global.itemsAdcionales[i].nombre,
                              cant: global.nTicketsAdicionales[i],
                              facturar: global.nfacturaSiNoAdicional[i],
                              tipo: global.itemsAdcionales[i].tipo,
                              serie_producto: global.itemsAdcionales[i].serie,
                              codigo_serie: global.itemsAdcionales[i].serie ==
                                      'SI'
                                  ? int.parse(
                                      global.serieProductsAdicional[i].codigo)
                                  : 0,
                              nombre_serie:
                                  global.itemsAdcionales[i].serie == 'SI'
                                      ? global.serieProductsAdicional[i].serie1
                                      : 'SN',
                              desc: global.nDescuentoAdicional[i]));
                        }
                        print(
                            'aqui mi lista para enviar:  ' + items.toString());
                        print(global.codigo_servicio_DetMigracion);
                        semifacturaMigracion(
                                global.id_cliente_DetMigracion,
                                items.toString(),
                                global.id_pk,
                                global.codigo_servicio_DetMigracion,
                                solucionController.text == ''
                                    ? 'SN'
                                    : solucionController.text,
                                global.factura_SI_NO,
                                global.id_tecnico_DetMigracion,
                                txtCant.text,
                                global.ProductAdiciInsta,
                                itemsAdicionales.toString(),
                                global.btnRecibeProd == true ? 'SI' : 'NO',
                                retiraProductosController.text,
                                global.selectAcomp.toString(),
                                latitude.toString() == ''
                                    ? '0'
                                    : latitude.toString(),
                                longitude.toString() == ''
                                    ? '0'
                                    : longitude.toString(),
                                global.imageInstalation,
                                global.btnUpdateCoords == true ? 'SI' : 'NO',
                                global.persona_presente,
                                global.nCuotasAdicionales)
                            .then((value) {
                          print('luego de consumir');
                          print(global.codigo_servicio_DetMigracion);
                          if (value == null) {
                            setState(() {
                              progressDialog.dismiss();
                            });
                            mostrarErrorMSG(
                                context, "NO hay conexion con el servidor");
                            return;
                          }
                          if (value['success'] == 'OK') {
                            print(value);
                            progressDialog.dismiss();

                            if (global.itemsPDF.isEmpty ||
                                global.itemsPDF == []) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => ActionScreens(
                                          message: value['mensaje'],
                                          type: 'SUCCESS')),
                                  (Route<dynamic> route) => false);
                            } else {
                              setState(() {
                                print('aqui ando');
                                print('aqui ando2');
                                print(value['secuencial_adicional']);
                                global.numFactura =
                                    value['secuencial_adicional'];
                                print(global.numFactura);
                              });

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const PDFScreen()),
                                  (Route<dynamic> route) => false);
                            }

                            setState(() {
                              // global.nTickets
                              //     .clear();
                              global.id_cliente_DetMigracion = '';
                              // items.clear();
                              global.id_pk = '';
                              global.codigo_servicio_DetMigracion = '';
                              solucionController.text = '';
                              global.tipocondicion = 'Seleccionar';
                              global.colorFact = '2';

                              global.factura_SI_NO = 'NO';

                              global.fileImageHouse = null;
                              global.fileImageInstalation = null;
                              global.updateCoords = false;
                              global.btnUpdateCoords = false;
                              global.persona_presente = '';
                            });
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
                                        type: 'ERROR')),
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
                                            text:
                                                'o estas teniendo una señal con ',
                                            style:
                                                TextStyle(color: Colors.black),
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
                  }
                : null,
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
        ),
      ),
    );
  }

  Widget facturaOficina() {
    double varWidth = MediaQuery.of(context).size.width;
    double varHeight = MediaQuery.of(context).size.height;
    return Visibility(
      visible: global.items.isEmpty ? false : true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: buttonEnabled
                ? () {
                    if (inter = true) {
                      ProgressDialog progressDialog = ProgressDialog(context);
                      progressDialog.show();

                      print('aqui');
                      print(_currentPosition?.latitude);
                      print(_currentPosition?.longitude);

                      setState(() {
                        latitude = _currentPosition?.latitude != '' &&
                                _currentPosition?.latitude != null
                            ? _currentPosition?.latitude.toString()
                            : '';
                        longitude = _currentPosition?.longitude != '' &&
                                _currentPosition?.longitude != null
                            ? _currentPosition?.longitude.toString()
                            : '';
                      });
                      if (solucionController.text.isEmpty) {
                        progressDialog.dismiss();
                        mostrarError(
                            context, 'Detalle una solucion para continuar');
                      } else if (global.persona_presente.isEmpty) {
                        progressDialog.dismiss();
                        mostrarError(context, 'Campo Nombre del Cliente Vacio');
                      } else if (global.selectAcomp.toString() ==
                          'Seleccionar') {
                        progressDialog.dismiss();
                        mostrarError(context, 'Seleccione un técnico auxiliar');
                      } else if (global.checkBoxValue == true &&
                          global.items.isEmpty) {
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
                      } else if (global.fileImageInstalation == null) {
                        progressDialog.dismiss();
                        mostrarError(context, 'Adjunte las fotos del servicio');
                      } /* else if (double.parse(
                            txtCant.text == '' ? '0' : txtCant.text) >
                        tot) {
                      progressDialog.dismiss();
                      mostrarError(context,
                          'El monto no debe ser mayor a ${tot.toStringAsFixed(2)}');
                    } */
                      else {
                        setState(() {
                          print('aqui ando');
                          global.nomAuxiliar = global.selectAcomp;
                          print(txtCant.text);
                          global.valorCobrado = txtCant.text != ''
                              ? double.parse(txtCant.text)
                              : 0.0;
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
                          if (global.nfacturaSiNo[i] == 'SI') {
                            /*global.itemsPDF.add(
                                                    Productos_PDF(
                                                        nombre: global
                                                            .items[i].nombre,
                                                        cant:
                                                            global.nTickets[i],
                                                        desc: global
                                                            .nDescuento[i],
                                                        precio: global
                                                            .items[i].precio));*/
                          }
                          //print('voy for $i');
                          items.add(Productos(
                              codigo: int.parse(global.items[i].codigo),
                              nombre_producto: global.items[i].nombre,
                              cant: global.nTickets[i],
                              facturar: global.nfacturaSiNo[i],
                              tipo: global.items[i].tipo,
                              serie_producto: global.items[i].serie,
                              codigo_serie: global.items[i].serie == 'SI'
                                  ? int.parse(global.serieProducts[i].codigo)
                                  : 0,
                              nombre_serie: global.items[i].serie == 'SI'
                                  ? global.serieProducts[i].serie1
                                  : 'SN',
                              desc: global.nDescuento[i]));
                        }
                        for (var i = 0;
                            i <= global.itemsAdcionales.length - 1;
                            i++) {
                          if (global.nfacturaSiNoAdicional[i] == 'SI') {
                            global.itemsPDF.add(Productos_PDF(
                                nombre: global.itemsAdcionales[i].nombre,
                                cant: global.nTicketsAdicionales[i],
                                desc: global.nDescuentoAdicional[i],
                                precio: global.itemsAdcionales[i].precio));
                          }
                          print('voy for $i');
                          itemsAdicionales.add(Productos(
                              codigo:
                                  int.parse(global.itemsAdcionales[i].codigo),
                              nombre_producto: global.itemsAdcionales[i].nombre,
                              cant: global.nTicketsAdicionales[i],
                              facturar: global.nfacturaSiNoAdicional[i],
                              tipo: global.itemsAdcionales[i].tipo,
                              serie_producto: global.itemsAdcionales[i].serie,
                              codigo_serie: global.itemsAdcionales[i].serie ==
                                      'SI'
                                  ? int.parse(
                                      global.serieProductsAdicional[i].codigo)
                                  : 0,
                              nombre_serie:
                                  global.itemsAdcionales[i].serie == 'SI'
                                      ? global.serieProductsAdicional[i].serie1
                                      : 'SN',
                              desc: global.nDescuentoAdicional[i]));
                        }
                        print(
                            'aqui mi lista para enviar:  ' + items.toString());
                        print(global.codigo_servicio_DetMigracion);
                        semiFacturaPendienteMigracion(
                                global.id_cliente_DetMigracion,
                                items.toString(),
                                global.id_pk,
                                global.codigo_servicio_DetMigracion,
                                solucionController.text == ''
                                    ? 'SN'
                                    : solucionController.text,
                                global.factura_SI_NO,
                                global.id_tecnico_DetMigracion,
                                txtCant.text,
                                global.ProductAdiciInsta,
                                itemsAdicionales.toString(),
                                global.btnRecibeProd == true ? 'SI' : 'NO',
                                retiraProductosController.text,
                                global.selectAcomp.toString(),
                                latitude.toString() == ''
                                    ? '0'
                                    : latitude.toString(),
                                longitude.toString() == ''
                                    ? '0'
                                    : longitude.toString(),
                                global.imageInstalation,
                                global.btnUpdateCoords == true ? 'SI' : 'NO',
                                global.nCuotas,
                                global.persona_presente,
                                global.nCuotasAdicionales)
                            .then((value) {
                          print('luego de consumir');
                          print(global.codigo_servicio_DetMigracion);
                          if (value == null) {
                            setState(() {
                              progressDialog.dismiss();
                            });
                            mostrarErrorMSG(
                                context, "NO hay conexion con el servidor");
                            return;
                          }
                          if (value['success'] == 'OK') {
                            print(value);
                            progressDialog.dismiss();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ActionScreens(
                                        message: value['mensaje'],
                                        type: 'SUCCESS')),
                                (Route<dynamic> route) => false);

                            if (global.itemsPDF.isEmpty ||
                                global.itemsPDF == []) {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const HomeApp()),
                                  (Route<dynamic> route) => false);
                            } else {
                              setState(() {
                                print('aqui ando');
                                print('aqui ando2');
                                print(value['secuencial_adicional']);
                                global.numFactura =
                                    value['secuencial_adicional'];
                                print(global.numFactura);
                              });

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const PDFScreen()),
                                  (Route<dynamic> route) => false);
                            }

                            setState(() {
                              // global.nTickets
                              //     .clear();
                              global.id_cliente_DetMigracion = '';
                              // items.clear();
                              global.id_pk = '';
                              global.codigo_servicio_DetMigracion = '';
                              solucionController.text = '';
                              global.tipocondicion = 'Seleccionar';
                              global.colorFact = '2';

                              global.factura_SI_NO = 'NO';
                              //global.nDescuento.clear();
                              // global.nfacturaSiNo
                              //     .clear();
                              global.fileImageHouse = null;
                              global.fileImageInstalation = null;
                              global.updateCoords = false;
                              global.btnUpdateCoords = false;
                              global.tipo_factura_migracion =
                                  'Facturacion Automatica';
                              global.persona_presente = '';
                            });
                          } else if (value['success'] == 'ERROR') {
                            progressDialog.dismiss();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ActionScreens(
                                          message: value['mensaje'],
                                          type: 'ERROR',
                                        )));
                            /*  Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ActionScreens(
                                        message: value['mensaje'],
                                        type: 'ERROR')),
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
                                            text:
                                                'o estas teniendo una señal con ',
                                            style:
                                                TextStyle(color: Colors.black),
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
                  }
                : null,
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
        ),
      ),
    );
  }
}

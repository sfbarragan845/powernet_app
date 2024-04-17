import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:powernet/app/clases/cConfig_UI.dart';
import 'package:powernet/app/pages/public/home/screens/home.dart';
import 'package:printing/printing.dart';

import '../../../../models/share_preferences.dart';
import '/app/models/var_global.dart' as global;

class PDFScreenCobro extends StatefulWidget {
  static const routeNamed = '/pdf_screen';
  const PDFScreenCobro({Key? key}) : super(key: key);

  static Route<dynamic> route() {
    return MaterialPageRoute(
      builder: (context) => const PDFScreenCobro(),
    );
  }

  @override
  _PDFScreenCobroState createState() => _PDFScreenCobroState();
}

class _PDFScreenCobroState extends State<PDFScreenCobro> {
  late pw.Document pdf;

  late Uint8List archivoPdf;

  double sizeIcon1 = 45;
  double sizeIcon2 = 30;
  double sizeIcon3 = 30;
  double tot = 0.0;

  @override
  void initState() {
    super.initState();
    initPDF();
    totalPEDIDO();
  }

  void totalPEDIDO() {
    for (var y = 0; y <= global.itemsPDF.length - 1; y++) {
      tot = tot +
          double.parse(((global.itemsPDF[y].cant.toDouble() *
                      double.parse(global.itemsPDF[y].precio)) -
                  (((global.itemsPDF[y].desc / 100) *
                      (double.parse(global.itemsPDF[y].precio)) *
                      global.itemsPDF[y].cant.toDouble())))
              .toStringAsFixed(2));
    }
  }

  Future<void> initPDF() async {
    archivoPdf = await generarPdf1();
  }

  void iconoSeleccionado(int numero) {
    if (numero == 1) {
      sizeIcon1 = 45;
      sizeIcon2 = 30;
      sizeIcon3 = 30;
    } else if (numero == 2) {
      sizeIcon1 = 30;
      sizeIcon2 = 45;
      sizeIcon3 = 30;
    } else {
      sizeIcon1 = 30;
      sizeIcon2 = 30;
      sizeIcon3 = 45;
    }
  }

  @override
  Widget build(BuildContext context) {
    double varHeight = MediaQuery.of(context).size.height;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('PDF'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: varHeight * 0.7,
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 25,
                  ),
                  child: PdfPreview(
                    build: (format) => archivoPdf,
                    useActions: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Printing.sharePdf(
                            bytes: archivoPdf,
                            filename: 'Comprobante_Pago.pdf');
                      },
                      child: const Icon(
                        Icons.share,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      global.itemsPDF.clear();
                      global.valorCobrado = 0.0;
                    });
                    Navigator.of(context).pushReplacement(HomeApp.route());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: ColorFondo.BTNUBI,
                    ),
                    width: 180,
                    height: 80,
                    child: Center(
                      child: Text(
                        'Finalizar',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future savePDFGREAT() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File('$documentPath/Reporte_powernet.pdf');
    file.writeAsBytesSync(List.from(await pdf.save()));
    print('ESTE PRINTING' + '$file'.toString());
    print('ESTE PRINTING' + '$documentDirectory'.toString());
  }

  final headers = ['Descripción', 'Cantidad', 'Precio', 'Total'];

  Future<Uint8List> generarPdf1() async {
    pdf = pw.Document();

    final imagen = ((await rootBundle.load('assets/logos/logo_PowerNet.png'))
        .buffer
        .asUint8List());

    final productData = headers;

    final proyectos = productData;
    print("LA CANTIDAD2 ES " "${proyectos.length}");

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Container(
            child: pw.Column(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Image(
                          pw.MemoryImage(imagen),
                          height: 150,
                          width: 150,
                        ),
                        pw.Text(
                          'DETALLE DOCUMENTO ELECTRÓNICO',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          '***DOCUMENTO SIN VALOR TRIBUTARIO***',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        pw.Text(
                          '----------------------------------------------------------',
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                        /* pw.Text(
                          'N. Comprobante: ' + global.numFactura,
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.Text(
                          'Cliente: ' + global.clienteFactura,
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.left,
                        ), */
                        pw.Text(
                          'Tecnico: ' + Preferences.usrNombre,
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                        /* pw.Text(
                          'Auxiliar: ' + global.nomAuxiliar,
                          style: const pw.TextStyle(
                            fontSize: 12,
                            color: PdfColors.black,
                          ),
                          textAlign: pw.TextAlign.left,
                        ), */
                      ],
                    ),
                  ),
                ),
                pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.start,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisSize: pw.MainAxisSize.min,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.SizedBox(
                                  width: 23,
                                ),
                                pw.Text(
                                  'Fecha de generación: ' +
                                      DateFormat('yyyy-MM-dd HH:mm:ss a')
                                          .format(DateTime.now()),
                                  style: const pw.TextStyle(
                                    fontSize: 12,
                                    color: PdfColors.black,
                                  ),
                                  textAlign: pw.TextAlign.left,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(
                  height: 8,
                ),
                pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    // ignore: deprecated_member_use
                    child: pw.Table.fromTextArray(
                      headers: headers,
                      data: [
                        for (var i = 0; i < global.itemsPDF.length; i++)
                          [
                            global.itemsPDF.elementAt(i).nombre,
                            global.itemsPDF.elementAt(i).cant,
                            double.parse(global.itemsPDF.elementAt(i).precio)
                                .toStringAsFixed(2),
                            double.parse(((global.itemsPDF.elementAt(i).cant *
                                            double.parse(global.itemsPDF
                                                .elementAt(i)
                                                .precio)) -
                                        (((global.itemsPDF.elementAt(i).desc /
                                                100) *
                                            (double.parse(global.itemsPDF
                                                .elementAt(i)
                                                .precio)) *
                                            global.itemsPDF
                                                .elementAt(i)
                                                .cant
                                                .toDouble())))
                                    .toStringAsFixed(2))
                                .toStringAsFixed(2),
                          ],
                      ],
                      border: null,
                      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      headerDecoration:
                          const pw.BoxDecoration(color: PdfColors.grey300),
                      cellHeight: 30,
                      headerAlignments: {
                        0: pw.Alignment.centerLeft,
                        1: pw.Alignment.center,
                        2: pw.Alignment.centerRight,
                        3: pw.Alignment.centerRight,
                      },
                      cellAlignments: {
                        0: pw.Alignment.centerLeft,
                        1: pw.Alignment.center,
                        2: pw.Alignment.centerRight,
                        3: pw.Alignment.centerRight,
                      },
                      cellStyle: const pw.TextStyle(fontSize: 12),
                    )),
                pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Total: ' + tot.toStringAsFixed(2),
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ])),
                pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Valor Cobrado: ' +
                                global.valorCobrado.toStringAsFixed(2),
                            style: const pw.TextStyle(
                              fontSize: 12,
                              color: PdfColors.black,
                            ),
                            textAlign: pw.TextAlign.center,
                          ),
                        ])),
                pw.SizedBox(
                  height: 8,
                )
              ],
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}

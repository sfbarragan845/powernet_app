import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import '../../../../clases/cConfig_UI.dart';

class WidgetApp {
  showAlertDriver(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Salir"),
      onPressed: () {
        Navigator.pushReplacementNamed(context, '/formDriver');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text("El conductor ya esta registrado en CanarioApp"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDriverError(BuildContext context, String msg) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cerrar"),
      onPressed: () {
        //Navigator.pushReplacementNamed(context, '/formDriver');
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alerta"),
      content: Text(msg),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget TitleInformation(String title) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        textPoppins(title, 20),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  void showSnackBarRegister(context, String text, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), duration: Duration(seconds: duration)));
  }

  void showSnackBar(context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), duration: const Duration(seconds: 3)));
  }

  void showSnackBarColor(context, String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content: Text(text),
        duration: const Duration(seconds: 3)));
  }

  Widget inkwell(Function() onpresed, IconData icon, Color color) {
    return InkWell(
      onTap: onpresed,
      child: Icon(icon, size: 30.0, color: color),
    );
  }

  Widget preciePuja(String porcent, String precie, Function() onpressed) {
    return Column(
      children: [
        textPoppins(porcent, 20),
        GestureDetector(onTap: onpressed, child: containerGrey(precie, 80))
      ],
    );
  }

  Widget dottedDecoration() {
    return Container(
      decoration: DottedDecoration(
          shape: Shape.line, linePosition: LinePosition.top, strokeWidth: 3),
    );
  }

  Widget containerGrey(String text, double width) {
    return Container(
      height: 45,
      width: width,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(child: textPoppinsBold(text, 16)),
    );
  }

  Widget containerWithe(String text, double width) {
    return Container(
      height: 45,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(child: textSans(text, 17)),
    );
  }

  Widget buttonCircle(
      Function() funcion, IconData icon, double size, Color primary) {
    return ElevatedButton(
      onPressed: funcion,
      style: ElevatedButton.styleFrom(
          //shadowColor: Colors.orange,
          //side: BorderSide(color: primary, width: 2),
          foregroundColor: Colors.white,
          shape: const CircleBorder(),
          backgroundColor: primary,
          padding: const EdgeInsets.all(9),
          elevation: 3),
      child: Icon(
        icon,
        color: ColorFondo.PRIMARY,
        size: 25,
      ),
    );
  }

  Widget firstChild(
      BuildContext context,
      String ridername,
      String urlRider,
      String origen,
      String destino,
      String note,
      double precioBase,
      String rating) {
    return Row(
      children: [
        Expanded(child: riderOrder(context, ridername, urlRider, rating)),
        Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textBorder(Icons.my_location_sharp, origen),
                const SizedBox(
                  height: 5,
                ),
                textBorder(Icons.location_on_sharp, destino),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: textPoppinsLeft(note, 17),
                ),
              ],
            )),
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
                border: Border.all(color: ColorFondo.PRIMARY, width: 2),
                shape: BoxShape.circle),
            child: Center(
                child: textSans('\$ ${precioBase.toStringAsFixed(2)}', 18)),
          ),
        )
      ],
    );
  }

  Widget textBorder(IconData icondata, String text) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            //margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: ColorFondo.PRIMARY, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: icon(icondata, 20, Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade100, width: 2),
              ),
              child: textPoppinsLeft(text, 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget iconBackground(IconData icondata, Color color) {
    return Container(
      //margin: EdgeInsets.all(5),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: icon(icondata, 35, Colors.white),
      ),
    );
  }

  Widget outlineButtonIcon(Function() onpresed, IconData icondata) {
    return GestureDetector(
      onTap: onpresed,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Container(
            decoration: BoxDecoration(
                color: ColorFondo.PRIMARY,
                border: Border.all(color: Colors.grey.shade300, width: 2),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: icon(icondata, 30, Color.fromARGB(255, 0, 0, 0))),
      ),
    );
  }

  Widget listtile(
      String title, IconData icon, Color color, Function() onpressed) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: color),
      onTap: onpressed,
    );
  }

  Widget textField(
      String placeholder,
      TextInputType tipoTexto,
      TextEditingController? controlador,
      TextCapitalization textCapitalization,
      int maxLength) {
    return TextFormField(
        inputFormatters: [
          new LengthLimitingTextInputFormatter(maxLength),
        ],
        keyboardType: tipoTexto,
        textCapitalization: textCapitalization,
        controller: controlador,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo Obligatorio';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: placeholder,
        ));
  }

  Widget textFieldBorderNone(
      String placeholder,
      TextInputType tipoTexto,
      TextEditingController? controlador,
      TextCapitalization textCapitalization) {
    return TextField(
        keyboardType: tipoTexto,
        textCapitalization: textCapitalization,
        controller: controlador,
        decoration:
            InputDecoration(hintText: placeholder, border: InputBorder.none));
  }

  Widget IconButton(
      String text, IconData icon, Color primary, Function() onpressed) {
    return ElevatedButton.icon(
        onPressed: onpressed,
        style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            minimumSize: const Size(double.infinity, 40)),
        icon: FaIcon(icon),
        label: Text(text));
  }

  Widget butonOutline(String text, void Function() onPressed) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            //maximumSize: Size(100, 50),
            foregroundColor: ColorFondo.PRIMARY,
            minimumSize: const Size(double.infinity, 45),
            backgroundColor: Colors.white,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                side: BorderSide(color: ColorFondo.PRIMARY))),
        onPressed: onPressed,
        child: textPoppins(text, 18));
  }

  Widget buton(Function() onpressed, String text, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          minimumSize: const Size(double.infinity, 40)),
      onPressed: onpressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }

  //Radio buton para el comprobar si el usuario es socio o conductor
  Widget customRadio<T>(
    T value,
    T groupValue,
    ValueChanged<T?> onChanged,
    String label,
  ) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  Widget SelectForm(String text, IconData icon, double sizeText,
      Function() onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconBackground(icon, color),
            SizedBox(
              width: 20,
            ),
            textPoppinsLeft(text, sizeText)
          ],
        ),
      ),
    );
  }

  Widget divider() {
    return const Divider(
      color: Colors.grey,
      height: 1,
      thickness: 1,
    );
  }

  Widget icon(IconData icon, double size, Color color) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }

  Widget iconButonTravel(
      IconData icon, double size, Color color, Function() onpressed) {
    return GestureDetector(
      onTap: onpressed,
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }

  Widget riderOrder(
      BuildContext context, String name, String urlRider, String rating) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        textPoppins(name, 14),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTap: () {
            showMaterialDialogImage(context, urlRider);
          },
          child: circleAvatar(urlRider),
          /* child: ClipOval(
            child: Image.network(
              urlRider,
              fit: BoxFit.cover,
              height: 65,
              width: 65,
            ),
          ), */
        ),
        /* const SizedBox(
          height: 3,
        ), */
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon(Icons.star, 20, Colors.yellow),
            textPoppins(rating, 11)
          ],
        )
      ],
    );
  }

  Widget circleAvatar(String url) {
    return CircleAvatar(
      radius: 35,
      backgroundColor: ColorFondo.PRIMARY,
      child: CircleAvatar(
        //backgroundColor: Colors.white,
        backgroundImage: NetworkImage(url),
        radius: 32,
      ),
    );
  }

  Widget rowOrder(String text) {
    return Row(
      children: [
        icon(Icons.circle, 10, Colors.grey.shade400),
        Flexible(child: textPoppinsLeft(text, 17))
      ],
    );
  }

  Widget textPoppins(String text, double fontSize, {Color? color}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }

  Widget textPoppinsBold(String text, double fontSize) {
    return Text(text,
        style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center);
  }

  Widget textPoppinsLeft(String text, double fontSize, {Color? color}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: fontSize),
      textAlign: TextAlign.left,
    );
  }

  Widget textSansBold(String text, double fontSize) {
    return Text(text,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'Public Sans'),
        textAlign: TextAlign.center);
  }

  Widget textSans(String text, double fontSize, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
          color: color, fontSize: fontSize, fontFamily: 'Public Sans'),
      textAlign: TextAlign.center,
    );
  }

  Widget offline(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: icon(Icons.wifi_tethering_off_rounded, 300, Colors.grey),
        ),
        const SizedBox(
          height: 30,
        ),
        textSans('Fuera de servicio', 20, color: Colors.black),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: 180,
            height: 35,
            child: buton(() async {
              await Geolocator.openAppSettings();
            }, 'Configuración', ColorFondo.PRIMARY)),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: 210,
            height: 35,
            child: buton(() async {
              await Geolocator.openLocationSettings();
            }, 'Activar Ubicación', ColorFondo.PRIMARY))
      ],
    );
  }

  Widget permissionLocation(context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textPoppins('Uso de tu ubicación', 30, color: Colors.black),
                textPoppins(
                    'Para ver mapas y actividades de rastreo automático, permita que Canario use su ubicación cuando tome un pedido.',
                    16,
                    color: Colors.black),
                textPoppins(
                    'Canario utilizará su ubicación en segundo plano para mostrar a los clientes la ubicación de su viaje.',
                    16,
                    color: Colors.black),
                Center(
                  child: Image.asset(
                    'assets/images/icon_drivers.png',
                    height: 300,
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          showSnackBar(context,
                              'Canario requiere de estos permisos de Ubicación');
                        },
                        child: Text('No gracias')),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.red.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          //minimumSize: Size(double.infinity, 50)
                          //snapshot.data['media']['address'].toString()
                        ),
                        onPressed: () async {
                          if (await Permission.location.request().isGranted) {
                            await Permission.locationAlways.request();
                          }
                        },
                        child: Text('Encender Ubicación')),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget recharge(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon(Icons.emoji_transportation, 300, Colors.grey),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 40),
          child: textPoppins(
              'Para poder trabajar con Canario, realiza una recarga', 17),
        ),
        SizedBox(
            width: 200,
            height: 40,
            child: buton(() {
              Navigator.pushNamed(context, '/transaction');
            }, 'Recargar', ColorFondo.PRIMARY)),
      ],
    ));
  }

  Widget search(String billterea, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: icon(Icons.wifi_tethering, 300, Colors.grey),
            /* child: Image.asset(
              'assets/images/splash_servi_gas.png',
              height: 400,
            ), */
          ),
          textSans('Esperando pedido \n \nSaldo actual: \$ $billterea', 20),
        ],
      ),
    );
  }

  void showMaterialDialog(context, String title, String subtitle,
      Function() onpressedYes, Function() onpressedNo) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(subtitle),
            actions: <Widget>[
              TextButton(onPressed: onpressedNo, child: const Text('No')),
              TextButton(
                onPressed: onpressedYes,
                child: const Text('Si'),
              )
            ],
          );
        });
  }

  void showMaterialDialogImage(BuildContext context, String url) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //title: const Text('Salir'),
            content: Image.network(
              url,
              fit: BoxFit.contain,
            ),
            actions: <Widget>[
              Center(
                child: SizedBox(
                  height: 35,
                  width: 150,
                  child: buton(() {
                    Navigator.pop(context);
                  }, 'Salir', Colors.orange),
                ),
              )
            ],
          );
        });
  }

  Widget cash(BuildContext context, String type, String cash) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: ColorFondo.PRIMARY,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: ColorFondo.PRIMARY,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: textPoppins(type, 18, color: Colors.white),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: textPoppins('\$ $cash', 18, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}


  // Widget order() {
  //   return GestureDetector(
  //     onTap: () {
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.only(top: 5, bottom: 5),
  //       child: CouponCard(
  //         backgroundColor: Colors.white,
  //         height: 240,
  //         curvePosition: 160,
  //         curveRadius: 30,
  //         firstChild: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Expanded(flex: 1, child: wp.riderOrder()),
  //             Expanded(
  //                 flex: 2,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     wp.rowOrder('Origen'),
  //                     wp.rowOrder('Destino'),
  //                     wp.textPoppins('Nota', 16)
  //                   ],
  //                 ))
  //           ],
  //         ),
  //         secondChild: Container(
  //             width: double.maxFinite,
  //             decoration: DottedDecoration(
  //                 shape: Shape.line, linePosition: LinePosition.top),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               children: [
  //                 wp.icon(Icons.route_sharp, 20, Colors.red),
  //                 wp.textPoppins('Distance 500 m', 13, color: Colors.grey),
  //                 wp.icon(Icons.access_time, 20, Colors.black),
  //                 wp.textPoppins('Time 30 min', 13, color: Colors.grey),
  //                 Container(
  //                   height: 40,
  //                   width: 60,
  //                   decoration: BoxDecoration(
  //                       color: Colors.grey.shade300,
  //                       borderRadius: BorderRadius.all(Radius.circular(10))),
  //                   child: Center(child: wp.textPoppinsBold('\$10.00', 15)),
  //                 ),
  //               ],
  //             )),
  //       ),
  //     ),
  //   );
  // }
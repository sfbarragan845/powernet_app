import 'package:flutter/material.dart';
import 'package:powernet/app/clases/cConfig_UI.dart';
import 'package:powernet/app/pages/public/home/screens/home.dart';

class ActionScreens extends StatefulWidget {
  final String message;
  final String type;

  const ActionScreens({Key? key, required this.message, required this.type})
      : super(key: key);

  @override
  State<ActionScreens> createState() => _ActionScreensState();
}

class _ActionScreensState extends State<ActionScreens> {
  @override
  Widget build(BuildContext context) {
    double vwidth = MediaQuery.of(context).size.width;
    double vheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 16),
            height: vheight / 5,
            width: vwidth,
            color: ColorFondo.PRIMARY,
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 16),
            height: vheight / 1.8,
            width: vwidth,
            child: widget.type == 'SUCCESS'
                ? Container(
                    height: 200,
                    child: Image.asset('assets/icons/success_icon.png'))
                : Container(
                    height: 200,
                    child: Image.asset('assets/icons/error_icon.png')),
          ),
        ],
      ),
      Positioned(
        left: vwidth / 6,
        top: vheight / 7,
        child: Container(
          alignment: Alignment.center,
          width: vwidth / 1.5,
          height: vheight / 8,
          decoration: BoxDecoration(
            color: ColorFondo.BLANCO,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0, // Spread of the shadow
                offset: Offset(0, 5), // Offset in the x and y directions
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/logos/logo_PowerNet.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        child: Container(
            alignment: Alignment.center,
            width: vwidth,
            height: vheight / 3.5,
            decoration: BoxDecoration(
              color: ColorFondo.BTNUBI,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10.0, // Spread of the shadow
                  offset: Offset(0, 5), // Offset in the x and y directions
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  alignment: Alignment.center,
                  width: vwidth / 2,
                  height: 3,
                  color: ColorFondo.AUXILIAR,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  height: 80,
                  child: Text(
                    widget.message,
                    style: TextStyle(color: ColorFondo.BLANCO, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // Background color
                      foregroundColor:
                          Color.fromARGB(141, 27, 20, 100), // Text color
                      padding: EdgeInsets.all(
                          16.0), // Padding around the button content
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // Border radius
                      ),
                    ),
                    onPressed: () {
                      if (widget.type == 'SUCCESS') {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeApp()));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                        width: vwidth / 2,
                        height: 30,
                        alignment: Alignment.center,
                        child: Text(
                          'Aceptar',
                          style: TextStyle(
                              color: Color.fromARGB(186, 15, 15, 15),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )))
              ],
            )),
      ),
    ]));
  }
}

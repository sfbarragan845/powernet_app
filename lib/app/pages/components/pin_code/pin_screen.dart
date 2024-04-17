/*
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_redux/flutter_redux.dart';

class PinCodeScreen extends StatefulWidget {
  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  final pincodeController = TextEditingController(text: "");
  String currentText = "";
  final formKey = GlobalKey<FormState>();
  // StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB1FDC0),
              Color(0xFFE6FD99),
              Color(0xFFFEFD86),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .5,
              width: MediaQuery.of(context).size.height * .5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/pincode_logo.png',
                          width: 71,
                          height: 61,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Ingrese su Codigo",
                          style: TextStyle(
                            fontSize: 25,
                            color: Color(0xFF575757),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StoreConnector<AppState, LockScreenViewModel>(
                          converter: LockScreenViewModel.fromStore,
                          builder: (_, viewModel) => Form(
                            key: formKey,
                            child: Container(
                              width: 250,
                              child: PinCodeTextField(
                                backgroundColor: Colors.transparent,
                                length: 6,
                                showCursor: false,
                                autoFocus: true,
                                appContext: context,
                                enableActiveFill: true,
                                obscureText: true,
                                enablePinAutofill: false,
                                keyboardType: TextInputType.numberWithOptions(
                                  signed: false,
                                  decimal: false,
                                ),
                                animationType: AnimationType.fade,
                                controller: pincodeController,
                                // errorAnimationController: errorController,
                                validator: (String? value) =>
                                    value!.length != 6 &&
                                            value == viewModel.pincode
                                        ? "Codigo Invalido"
                                        : null,
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF575757),
                                  fontWeight: FontWeight.bold,
                                ),
                                pinTheme: PinTheme(
                                  borderRadius: BorderRadius.circular(5),
                                  borderWidth: 4,
                                  fieldWidth: 35,
                                  shape: PinCodeFieldShape.underline,
                                  inactiveColor: Color(0xFF575757),
                                  selectedColor: Color(0xFF575757),
                                  activeColor: Color(0xFF575757),
                                  inactiveFillColor: Colors.transparent,
                                  selectedFillColor: Colors.transparent,
                                  disabledColor: Colors.transparent,
                                  activeFillColor: Colors.transparent,
                                ),
                                onCompleted: (value) {
                                  if (viewModel.pincode == value) {
                                    Segment.track(
                                      eventName:
                                          'Session Start: Authentication success',
                                    );
                                    context.router.replaceAll([MainScreen()]);
                                    pincodeController.clear();
                                  } else {
                                    flush = Flushbar<bool>(
                                      title: "Pin invalido",
                                      message: "Autenticación Fallida",
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      mainButton: TextButton(
                                        onPressed: () async {
                                        //  flush.dismiss(true);
                                        },
                                        child: Text("Intente de Nuevo",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                        ),
                                      ),
                                    )..show(context).then(
                                        (result) async {
                                          if (result == true) {
                                            pincodeController.clear();
                                            WidgetsBinding.instance!
                                                .focusManager.primaryFocus
                                                ?.previousFocus();
                                          }
                                        },
                                      );
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    currentText = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
*/
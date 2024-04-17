import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

//**PARA RANGOS DE MEDIDAS ...... PERSONALIZACIÓN EXTREMA EN DISEÑOS COMPLEJOS /
  static bool isMobile_pequenio(BuildContext context) => MediaQuery.of(context).size.width >= 0 && MediaQuery.of(context).size.width <= 357;
  static bool isMobile_mediano(BuildContext context) => MediaQuery.of(context).size.width >= 358 && MediaQuery.of(context).size.width <= 378;
  static bool isMobile_grande(BuildContext context) => MediaQuery.of(context).size.width >= 379 && MediaQuery.of(context).size.width <= 388.5;
  static bool isMobile_extragrande(BuildContext context) => MediaQuery.of(context).size.width >= 389 && MediaQuery.of(context).size.width <= 405;
  static bool isMobile_extragrande2(BuildContext context) => MediaQuery.of(context).size.width >= 406 && MediaQuery.of(context).size.width <= 415;
  static bool isMobile_extragrande3(BuildContext context) => MediaQuery.of(context).size.width >= 416 && MediaQuery.of(context).size.width <= 426;
  static bool isTablet_pequenio(BuildContext context) => MediaQuery.of(context).size.width >= 427 && MediaQuery.of(context).size.width <= 771;
  static bool isTablet_mediano(BuildContext context) => MediaQuery.of(context).size.width >= 772 && MediaQuery.of(context).size.width <= 992;
  static bool isTablet_grande(BuildContext context) => MediaQuery.of(context).size.width >= 993 && MediaQuery.of(context).size.width <= 1024;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1025;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (_size.width >= 1100) {
      return desktop;
    }
    // If width it less then 1100 and more then 850 we consider it as tablet
    else if (_size.width >= 850 && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }

  static isLargeDevice(BuildContext context) {}
}

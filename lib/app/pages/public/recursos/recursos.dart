import 'package:flutter/material.dart';

Widget sombra(Widget objeto) {
  return Container(
    child: objeto,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(11),
      boxShadow: const [
        BoxShadow(
          color: Color(0x3f000000),
          blurRadius: 5,
          offset: Offset(0.0, 5.0),
          // spreadRadius: ,
        ),
      ],
      color: Colors.white,
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressDialog {
  final BuildContext context;
  ProgressDialog(this.context);

  void show() {
    showDialog(
      builder: (context) => Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white.withOpacity(0.7),
        child: const CupertinoActivityIndicator(
          radius: 15,
        ),
      ),
      context: context,
    );
  }

  void dismiss() {
    Navigator.pop(context);
  }
}

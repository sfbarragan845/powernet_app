import 'package:flutter/material.dart';

import '../../../../clases/cConfig_UI.dart';

class FormInputField extends StatelessWidget {
  const FormInputField({
    Key? key,
    required TextEditingController itemController,
    required this.hintText,
    required this.validateMessage,
    required this.keyboardType,
    //required this.heigth,
  })  : _controller = itemController,
        super(key: key);

  final TextEditingController _controller;
  final String hintText;
  final String validateMessage;
  final TextInputType keyboardType;
  //final double heigth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white, //blue
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            hintText: hintText,
            /*border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
            ),*/
            suffixIcon: IconButton(
              onPressed: () => _controller.clear(),
              icon: Icon(Icons.clear),
            )),
        validator: (value) {
          if (value!.isEmpty) {
            return validateMessage;
          }
          return null;
        },
      ),
    );
  }
}

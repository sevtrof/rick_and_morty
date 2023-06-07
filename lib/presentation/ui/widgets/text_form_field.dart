import 'package:flutter/material.dart';

TextFormField textFormField(
  TextEditingController controller,
  String hintText,
) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
    ),
  );
}

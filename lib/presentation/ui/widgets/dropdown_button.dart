import 'package:flutter/material.dart';

Widget dropdownButton<T>(
  T value,
  void Function(T?) onChanged,
  List<DropdownMenuItem<T>> items,
  List<Widget> Function(BuildContext) selectedItemBuilder,
) {
  return InputDecorator(
    decoration: const InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        items: items,
        selectedItemBuilder: selectedItemBuilder,
      ),
    ),
  );
}

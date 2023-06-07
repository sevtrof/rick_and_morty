import 'package:flutter/material.dart';

class DropdownFormField<T> extends StatelessWidget {
  final T? value;
  final void Function(T?) onChanged;
  final List<DropdownMenuItem<T>> items;
  final String hintText;

  const DropdownFormField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      onChanged: onChanged,
      items: items,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}

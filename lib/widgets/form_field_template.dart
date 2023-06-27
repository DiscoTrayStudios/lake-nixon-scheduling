import 'package:flutter/material.dart';

/// A template for the formfields used in the add event dialog.
class FormFieldTemplate extends StatelessWidget {
  /// A template for the formfields used in the add event dialog.
  ///
  /// The text editing controller, decoration, and formkey are required, but
  /// keyboardType is only necessary if you don't want a typical text keyboard.
  const FormFieldTemplate(
      {super.key,
      required this.controller,
      required this.decoration,
      required this.formkey,
      this.keyboardType});

  /// The key for the field.
  final String formkey;

  /// The controller for the textfield.
  final TextEditingController controller;

  /// The hint text for the formfield.
  final String decoration;

  /// The type of keyboard to display.
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        key: Key(formkey),
        controller: controller,
        decoration: InputDecoration(hintText: decoration),
        keyboardType: keyboardType);
  }
}

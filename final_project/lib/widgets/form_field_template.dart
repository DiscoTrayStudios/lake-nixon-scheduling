import 'package:flutter/material.dart';

class FormFieldTemplate extends StatelessWidget {
  const FormFieldTemplate(
      {super.key,
      required this.controller,
      required this.decoration,
      required this.formkey});

  // key for field, controller, and string decoration
  final String formkey;
  final TextEditingController controller;
  final String decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(formkey),
      controller: controller,
      decoration: InputDecoration(hintText: decoration),
    );
  }
}

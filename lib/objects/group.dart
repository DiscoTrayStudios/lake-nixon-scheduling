import 'package:flutter/material.dart';

class Group {
  const Group({required this.name, required this.color, required this.age});

  final String name;
  final Color color;
  final int age;

  //bool selected = false;

  String abbrev() {
    return name.substring(0, 1);
  }
}

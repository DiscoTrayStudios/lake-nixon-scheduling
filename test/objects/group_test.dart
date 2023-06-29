import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/objects/group.dart';

void main() {
  test('Group abbreviation works', () {
    Group test = const Group(name: "Test", color: Color(0xFF0F8644), age: 1);

    expect(test.abbrev(), 'T');
  });
}

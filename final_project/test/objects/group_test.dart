import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/objects/group.dart';

void main() {
  test('Group abbreviation works', () {
    Group test = const Group(name: "Test", color: Color(0xFF0F8644), age: 1);

    expect(test.abbrev(), 'T');
  });
  testWidgets('GroupItem has name', (tester) async {
    Group test = const Group(name: "Test", color: Color(0xFF0F8644), age: 1);

    await tester.pumpWidget(
        MaterialApp(home: GroupItem(group: test, onTap: ((group) {}))));

    final nameFinder = find.text(test.name);

    expect(nameFinder, findsOneWidget);
  });
  testWidgets('GroupItem has Icon abbrev', (tester) async {
    Group test = const Group(name: "Test", color: Color(0xFF0F8644), age: 1);

    await tester.pumpWidget(
        MaterialApp(home: GroupItem(group: test, onTap: ((group) {}))));

    final nameFinder = find.text(test.abbrev());

    expect(nameFinder, findsOneWidget);
  });
  testWidgets('GroupItem calls onTap callback', (tester) async {
    Group test = const Group(name: "Test", color: Color(0xFF0F8644), age: 1);

    await tester.pumpWidget(MaterialApp(
        home: GroupItem(
            group: test,
            onTap: ((group) {
              expect(group, test);
            }))));

    await tester.tap(find.byType(ListTile));
  });
}

import 'package:final_project/objects/group.dart';
import 'package:final_project/widgets/appt_editor_group_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('widget displays text \'Assign Groups\'', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
      children: [
        GroupSelector(const [
          Group(name: 'Group 1', age: 10, color: Colors.white),
          Group(name: 'Group 2', age: 10, color: Colors.green),
        ], const [], (_) {})
      ],
    ))));

    expect(find.text('Assign Groups'), findsOneWidget);
  });
  testWidgets('widget displays selected groups', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
      children: [
        GroupSelector(const [
          Group(name: 'Group 1', age: 10, color: Colors.white),
          Group(name: 'Group 2', age: 10, color: Colors.green),
          Group(name: 'Group 3', age: 10, color: Colors.blue),
        ], const [
          Group(name: 'Group 2', age: 10, color: Colors.green),
          Group(name: 'Group 3', age: 10, color: Colors.blue),
        ], (_) {})
      ],
    ))));

    expect(find.text('Group 2'), findsOneWidget);

    expect(find.text('Group 3'), findsOneWidget);

    expect(find.text('Group 1'), findsNothing);
  });
  testWidgets('selecting changes displayed widgets', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
      children: [
        GroupSelector(const [
          Group(name: 'Group 1', age: 10, color: Colors.white),
          Group(name: 'Group 2', age: 10, color: Colors.green),
          Group(name: 'Group 3', age: 10, color: Colors.blue),
        ], const [
          Group(name: 'Group 2', age: 10, color: Colors.green),
          Group(name: 'Group 3', age: 10, color: Colors.blue),
        ], (_) {})
      ],
    ))));

    expect(find.text('Group 2'), findsOneWidget);

    expect(find.text('Group 3'), findsOneWidget);

    expect(find.text('Group 1'), findsNothing);

    await tester.tap(find.text('Assign Groups'));
    await tester.pump();
    await tester.tap(find.text('Group 1'));
    await tester.pump();
    await tester.tap(find.text('Group 2').last);
    await tester.pump();
    await tester.tap(find.text('Ok'));
    await tester.pump();

    expect(find.text('Group 2'), findsNothing);

    expect(find.text('Group 3'), findsOneWidget);

    expect(find.text('Group 1'), findsOneWidget);
  });
  testWidgets('onChangedcallback is called', (tester) async {
    bool hasChanged = false;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
      children: [
        GroupSelector(const [
          Group(name: 'Group 1', age: 10, color: Colors.white),
          Group(name: 'Group 2', age: 10, color: Colors.green),
          Group(name: 'Group 3', age: 10, color: Colors.blue),
        ], const [], (_) {
          hasChanged = true;
        })
      ],
    ))));

    await tester.tap(find.text('Assign Groups'));
    await tester.pump();
    await tester.tap(find.text('Group 1'));
    await tester.pump();
    await tester.tap(find.text('Ok'));
    await tester.pump();

    expect(hasChanged, true);
  });
}

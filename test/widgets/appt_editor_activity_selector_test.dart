import 'package:lake_nixon_scheduling/objects/activity.dart';
import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/widgets/appt_editor_activity_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockAppState extends Mock implements AppState {
  @override
  List<Activity> get activities {
    return const [
      Activity(name: 'Lunch', ageMin: 100, groupMax: 10, desc: 'Lunch'),
      Activity(name: 'Fishing', ageMin: 34, groupMax: 16, desc: 'Fishing')
    ];
  }

  @override
  String getCurrentAmount(String activity, dynamic startTime) {
    return '$activity $startTime';
  }
}

void main() {
  testWidgets('text "Activities" is displayed on widget', (tester) async {
    await tester.pumpWidget(ChangeNotifierProvider<AppState>(
        create: (context) => MockAppState(),
        child: MaterialApp(
            home: Scaffold(
          body: ListView(children: [
            ActivitySelector(
                DateTime.utc(1969, 7, 20, 20, 18, 04), (_) {}, 'Lunch')
          ]),
        ))));

    expect(find.text('Activities'), findsOneWidget);
  });
  testWidgets('First item text is displayed on widget', (tester) async {
    await tester.pumpWidget(ChangeNotifierProvider<AppState>(
        create: (context) => MockAppState(),
        child: MaterialApp(
            home: Scaffold(
          body: ListView(children: [
            ActivitySelector(
                DateTime.utc(1969, 7, 20, 20, 18, 04), (_) {}, 'Lunch')
          ]),
        ))));

    expect(find.text('Lunch  Lunch ${DateTime.utc(1969, 7, 20, 20, 18, 04)}'),
        findsOneWidget);
  });
  testWidgets('On changed callback fires when clicked', (tester) async {
    bool wasChanged = false;

    await tester.pumpWidget(ChangeNotifierProvider<AppState>(
        create: (context) => MockAppState(),
        child: MaterialApp(
            home: Scaffold(
          body: ListView(children: [
            ActivitySelector(DateTime.utc(1969, 7, 20, 20, 18, 04), (_) {
              wasChanged = true;
            }, 'Lunch')
          ]),
        ))));

    await tester.tap(
        find.text('Lunch  Lunch ${DateTime.utc(1969, 7, 20, 20, 18, 04)}'));

    await tester.pumpAndSettle();

    await tester.tap(
        find.text('Fishing  Fishing ${DateTime.utc(1969, 7, 20, 20, 18, 04)}'));

    await tester.pump();

    expect(wasChanged, true);
  });
}

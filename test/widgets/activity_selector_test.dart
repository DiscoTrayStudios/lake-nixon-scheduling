import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:lake_nixon_scheduling/objects/activity.dart';
import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/widgets/activity_selector_item.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
      'ActivitySelectorItem displays only displays name when not selected',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ActivitySelectorItem(
          const Activity(
              name: 'Herping',
              ageMin: 15,
              groupMax: 2,
              desc: 'Looking for snakes.'),
          false,
          0,
          (_) {},
          (context, activity, appstate) {}),
    ));

    expect(find.text('Herping'), findsOneWidget);

    expect(find.text('Looking for snakes.'), findsNothing);
  });
  testWidgets('ActivitySelectorItem displays full description when selected',
      (tester) async {
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) =>
          AppState(FakeFirebaseFirestore(), MockFirebaseAuth()),
      child: MaterialApp(
        home: ListView(children: [
          ActivitySelectorItem(
              const Activity(
                  name: 'Herping',
                  ageMin: 15,
                  groupMax: 2,
                  desc: 'Looking for snakes.'),
              true,
              0,
              (_) {},
              (context, activity, appstate) {})
        ]),
      ),
    ));

    expect(find.text('Herping'), findsOneWidget);

    expect(find.text('- Age 15+'), findsOneWidget);

    expect(find.text('- No more than 2 groups'), findsOneWidget);

    expect(find.text('Looking for snakes.'), findsOneWidget);
  });
  testWidgets('ActivitySelectorItem delete button calls callback',
      (tester) async {
    bool deleteButtonPressed = false;

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) =>
          AppState(FakeFirebaseFirestore(), MockFirebaseAuth()),
      child: MaterialApp(
        home: ListView(children: [
          ActivitySelectorItem(
              const Activity(
                  name: 'Herping',
                  ageMin: 15,
                  groupMax: 2,
                  desc: 'Looking for snakes.'),
              true,
              0,
              (_) {}, (context, activity, appstate) {
            deleteButtonPressed = true;
          })
        ]),
      ),
    ));

    await tester.tap(find.text('Delete'));

    await tester.pump();

    expect(deleteButtonPressed, true);
  });
  testWidgets('ActivitySelectorItem taping widget calls select callback',
      (tester) async {
    bool selectPressed = false;

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) =>
          AppState(FakeFirebaseFirestore(), MockFirebaseAuth()),
      child: MaterialApp(
        home: ListView(children: [
          ActivitySelectorItem(
              const Activity(
                  name: 'Herping',
                  ageMin: 15,
                  groupMax: 2,
                  desc: 'Looking for snakes.'),
              false,
              0, (_) {
            selectPressed = true;
          }, (context, activity, appstate) {})
        ]),
      ),
    ));

    await tester.tap(find.byType(ActivitySelectorItem));

    await tester.pump();

    expect(selectPressed, true);
  });
}

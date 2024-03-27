import 'package:lake_nixon_scheduling/widgets/appt_editor_time_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('widget displays starting test', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(children: [
      TimeSelector(
          DateTime.utc(1969, 7, 20, 13),
          DateTime.utc(1969, 7, 20, 14),
          () {},
          (_) {},
          (_) {},
          const TimeOfDay(hour: 7, minute: 0),
          const TimeOfDay(hour: 18, minute: 0))
    ]))));

    expect(
        find.text(DateFormat('EEE, MMM dd yyyy')
            .format(DateTime.utc(1969, 7, 20, 20))),
        findsOneWidget);

    expect(find.text('01:00 PM'), findsOneWidget);

    expect(find.text('02:00 PM'), findsOneWidget);
  });
  testWidgets('datePicked callback is called', (tester) async {
    bool datePicked = false;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(children: [
      TimeSelector(DateTime.utc(1969, 7, 20, 13), DateTime.utc(1969, 7, 20, 14),
          () {
        datePicked = true;
      }, (_) {}, (_) {}, const TimeOfDay(hour: 7, minute: 0),
          const TimeOfDay(hour: 18, minute: 0))
    ]))));

    await tester.tap(find.text(
        DateFormat('EEE, MMM dd yyyy').format(DateTime.utc(1969, 7, 20, 20))));

    await tester.pump();

    expect(datePicked, true);
  });
  testWidgets('timeChange callbacks are passed through', (tester) async {
    bool startTimePicked = false;
    bool endTimePicked = false;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(children: [
      TimeSelector(
          DateTime.utc(1969, 7, 20, 13), DateTime.utc(1969, 7, 20, 14), () {},
          (_) {
        debugPrint('startclicked');
        startTimePicked = true;
      }, (_) {
        debugPrint('endclicked');
        endTimePicked = true;
      }, const TimeOfDay(hour: 7, minute: 0),
          const TimeOfDay(hour: 18, minute: 0))
    ]))));

    await tester.tap(find.text('01:00 PM'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12:00 PM'));
    await tester.pumpAndSettle();

    expect(startTimePicked, true);

    await tester.tap(find.text('02:00 PM'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('04:00 PM'));
    await tester.pumpAndSettle();

    expect(endTimePicked, true);
  });
}

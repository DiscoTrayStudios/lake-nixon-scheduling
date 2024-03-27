import 'package:lake_nixon_scheduling/widgets/time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('onTimePickedCallback is called on a time being picked',
      (tester) async {
    bool timePicked = false;

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: TimeSelectorDropdown(
                startTime: const TimeOfDay(hour: 7, minute: 0),
                endTime: const TimeOfDay(hour: 18, minute: 0),
                initialTime: const TimeOfDay(hour: 11, minute: 0),
                onTimePicked: (TimeOfDay time) {
                  timePicked = true;
                  expect(time, const TimeOfDay(hour: 14, minute: 0));
                }))));

    await tester.tap(find.text('11:00 AM'));

    await tester.pumpAndSettle();

    await tester.tap(find.text('02:00 PM'));

    await tester.pump();

    expect(timePicked, true);
  });
}

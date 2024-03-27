import 'package:lake_nixon_scheduling/objects/lake_appointment.dart';
import 'package:lake_nixon_scheduling/widgets/appt_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'appt_selector_item_test.mocks.dart';

void main() {
  testWidgets('widget displays appointment info', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
      children: [
        ApptSelectorItem(
            LakeAppointment(
                startTime: DateTime.utc(1969, 7, 20, 20),
                endTime: DateTime.utc(1969, 7, 21, 20),
                group: 'Group 1',
                color: Colors.green,
                notes: '',
                subject: 'Herping'),
            DateTime.utc(1969, 7, 20, 20))
      ],
    ))));

    expect(find.text('Group 1'), findsOneWidget);
    expect(find.text('Herping'), findsOneWidget);
  });
  testWidgets('widget navigates when clicked', (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();

    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ListView(
          children: [
            ApptSelectorItem(
                LakeAppointment(
                    startTime: DateTime.utc(1969, 7, 20, 20),
                    endTime: DateTime.utc(1969, 7, 21, 20),
                    group: 'Group 1',
                    color: Colors.green,
                    notes: '',
                    subject: 'Herping'),
                DateTime.utc(1969, 7, 20, 20))
          ],
        )),
        navigatorObservers: [
          mockObserver
        ],
        routes: {
          '/appointmentEditorPage': (context) =>
              const Text('Appointment Editor')
        }));

    await tester.tap(find.byType(ApptSelectorItem));

    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
    expect(find.text('Appointment Editor'), findsOneWidget);
  });
}

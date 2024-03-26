import 'package:lake_nixon_scheduling/widgets/confirm_popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('popup has correct title and subtitle', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));

    NavigatorState navigator = tester.state(find.byType(Navigator));

    confirmNavPopup(
        navigator.context, 'Test Popup', 'This popup is a test', (_) async {});

    await tester.pumpAndSettle();

    expect(find.text('Test Popup'), findsOneWidget);
    expect(find.text('This popup is a test'), findsOneWidget);
  });
  testWidgets('yes button calls nav callback', (tester) async {
    bool hasNavigated = false;

    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Container())));

    NavigatorState navigator = tester.state(find.byType(Navigator));

    confirmNavPopup(navigator.context, 'Test Popup', 'This popup is a test',
        (_) async {
      hasNavigated = true;
    });

    await tester.pumpAndSettle();

    await tester.tap(find.text('Yes'));

    await tester.pump();

    expect(hasNavigated, true);
  });
}

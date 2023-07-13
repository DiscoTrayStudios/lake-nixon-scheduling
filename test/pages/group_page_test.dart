import 'package:final_project/objects/screen_arguments.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:final_project/pages/group_page.dart';
import 'package:final_project/objects/app_state.dart';

import 'group_page_test.mocks.dart';

void main() {
  testWidgets('GroupPage has appBar title', (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
          create: ((context) => AppState(firestore, auth)),
          child: const GroupPage(title: 'List of Groups')),
      navigatorObservers: [mockObserver],
    ));

    final appBarTitleFinder = find.text('List of Groups');

    expect(appBarTitleFinder, findsOneWidget);
  });
  testWidgets('GroupPage displays groups', (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();

    await firestore
        .collection('groups')
        .doc('Test Group')
        .set({"age": 100, "color": "Color(0xff000000)", "name": "Test Group"});

    await firestore.collection('groups').doc('Test Group 2').set(
        {"age": 100, "color": "Color(0xff000000)", "name": "Test Group 2"});

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierProvider(
          create: ((context) => AppState(firestore, auth)),
          child: const GroupPage(title: 'List of Groups')),
      navigatorObservers: [mockObserver],
    ));

    await tester.pump();

    expect(find.text('Test Group'), findsOneWidget);
    expect(find.text('Test Group 2'), findsOneWidget);
  });
  testWidgets('GroupPage navigates to correct calendar route when logged in',
      (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();

    await firestore
        .collection('groups')
        .doc('Test Group')
        .set({"age": 100, "color": "Color(0xff000000)", "name": "Test Group"});

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({'admin': true});

    await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: ((context) => AppState(firestore, auth)),
            child: const GroupPage(title: 'List of Groups')),
        navigatorObservers: [
          mockObserver
        ],
        routes: {
          '/calendarPage': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as CalendarArguments;
            return Text(args.isUser.toString());
          },
        }));

    await tester.pump();

    await tester.tap(find.text('Test Group'));

    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    expect(find.text("false"), findsOneWidget);
  });
  testWidgets('GroupPage navigates to correct calendar route when logged out',
      (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();

    await firestore
        .collection('groups')
        .doc('Test Group')
        .set({"age": 100, "color": "Color(0xff000000)", "name": "Test Group"});

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({'admin': false});

    await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: ((context) => AppState(firestore, auth)),
            child: const GroupPage(title: 'List of Groups')),
        navigatorObservers: [
          mockObserver
        ],
        routes: {
          '/calendarPage': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as CalendarArguments;
            return Text(args.isUser.toString());
          },
        }));

    await tester.pump();

    await tester.tap(find.text('Test Group'));

    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    expect(find.text("true"), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:final_project/pages/admin_home_page.dart';
import 'package:final_project/objects/app_state.dart';

import 'start_page_test.mocks.dart';

void main() {
  testWidgets('StartPage has appBar and page title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AdminHomePage()));

    final appBarTitleFinder = find.text('Action Page');
    final pageTitleFinder = find.text('Lake Nixon Admin');

    expect(appBarTitleFinder, findsOneWidget);
    expect(pageTitleFinder, findsOneWidget);
  });
  testWidgets('Groups button pushes named groups route', (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth();

    await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: ((context) => AppState(firestore, auth)),
            child: const AdminHomePage()),
        navigatorObservers: [
          mockObserver
        ],
        routes: {
          '/groupsPage': (context) => const Text('Groups Page'),
        }));

    expect(find.byKey(const Key('groupsNavButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('groupsNavButton')));

    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
    expect(find.text('Groups Page'), findsOneWidget);
  });
  testWidgets('Master Calendar button pushes named master calendar route',
      (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth();

    await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: ((context) => AppState(firestore, auth)),
            child: const AdminHomePage()),
        navigatorObservers: [
          mockObserver
        ],
        routes: {
          '/masterCalendarPage': (context) =>
              const Text('Master Calendar Page'),
        }));

    expect(find.byKey(const Key('masterCalendarNavButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('masterCalendarNavButton')));

    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
    expect(find.text('Master Calendar Page'), findsOneWidget);
  });
  testWidgets('Log out button logs out, removes all pages, and pushes login',
      (tester) async {
    MockNavigatorObserver mockObserver = MockNavigatorObserver();
    FakeFirebaseFirestore firestore = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    await tester.pumpWidget(MaterialApp(
        home: ChangeNotifierProvider(
            create: ((context) => AppState(firestore, auth)),
            child: const AdminHomePage()),
        navigatorObservers: [
          mockObserver
        ],
        routes: {
          '/loginPage': (context) => const Text('Login Page'),
        }));

    expect(find.byKey(const Key('logOutNavButton')), findsOneWidget);

    await tester.tap(find.byKey(const Key('logOutNavButton')));

    await tester.pumpAndSettle();

    verify(mockObserver.didReplace(
      oldRoute: anyNamed('oldRoute'),
      newRoute: anyNamed('newRoute'),
    ));
    expect(auth.currentUser, null);
    expect(find.text('Login Page'), findsOneWidget);
    expect(find.byType(AdminHomePage), findsNothing);
  });
}

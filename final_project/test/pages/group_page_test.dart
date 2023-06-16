import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'package:final_project/pages/group_page.dart';
import 'package:final_project/objects/app_state.dart';

@GenerateNiceMocks([MockSpec<NavigatorObserver>()])
import 'group_page_test.mocks.dart';

void main() {
  testWidgets('StartPage has appBar and page title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GroupPage()));

    final appBarTitleFinder = find.text('Action Page');
    final pageTitleFinder = find.text('Lake Nixon Admin');

    expect(appBarTitleFinder, findsOneWidget);
    expect(pageTitleFinder, findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:final_project/pages/start_page.dart';
import 'package:final_project/pages/login_page.dart';

import 'package:final_project/main.dart';

void main() {
  test('checkLogin should return LoginScreen when signed out', () {
    final auth = MockFirebaseAuth(signedIn: false);

    Widget nextPage = checkLogin(auth);

    expect(nextPage, isInstanceOf<LoginScreen>());
  });
  test('checkLogin should return StartPage when signed in', () {
    final auth = MockFirebaseAuth(signedIn: true);

    Widget nextPage = checkLogin(auth);

    expect(nextPage, isInstanceOf<StartPage>());
  });
}

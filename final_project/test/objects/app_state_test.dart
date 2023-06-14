import 'package:final_project/objects/group.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:final_project/objects/app_state.dart';

Future<AppState> initializeAppStateTests(
    FakeFirebaseFirestore instance, MockFirebaseAuth auth) async {
  AppState appState = AppState(instance, auth);

  await auth.currentUser!.reload();

  await instance.collection('events').doc('Test Event').set(
      {"name": "Test", "ageMin": 1, "groupMax": 6, "desc": "Test Description"});

  await instance.collection('appointments').doc('Test Appointment').set({
    "start_time": DateTime.utc(1969, 7, 20, 20),
    "end_time": DateTime.utc(1969, 7, 20, 20, 30),
    "color": "Color(0xff2471a3)",
    "notes": "Test Notes",
    "subject": "Test Subject",
    "group": "Test Group",
    "start_hour": "20"
  });

  await instance
      .collection('groups')
      .doc('Test Group')
      .set({"age": 100, "color": "Color(0xff000000)", "name": "Test Group"});

  return appState;
}

void main() {
  test('AppState initializer creates listeners', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    expect(appState.events.length, 1);
    expect(appState.appointments.length, 1);
    expect(appState.groups.length, 1);
  });
  test('AppState listeners dont duplicate objects', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    expect(appState.events.length, 1);
    expect(appState.appointments.length, 1);
    expect(appState.groups.length, 1);

    await instance.collection('events').doc('Test Event 2').set({
      "name": "Test",
      "ageMin": 1,
      "groupMax": 6,
      "desc": "Test Description"
    });

    await instance.collection('appointments').doc('Test Appointment 2').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group",
      "start_hour": "20"
    });

    await instance
        .collection('groups')
        .doc('Test Group 2')
        .set({"age": 100, "color": "Color(0xff000000)", "name": "Test Group"});

    expect(appState.events.length, 2);
    expect(appState.appointments.length, 2);
    expect(appState.groups.length, 2);
  });
  test('createCheckboxGroups creates checkbox groups', () async {
    // relies on AppState initializer test

    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    List<MultiSelectItem<Group>> items = appState.createCheckboxGroups();

    expect(items.length, 1);
  });
  test('createCheckboxEvents creates checkbox events', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    List<MultiSelectItem<String>> items = appState.createCheckboxEvents();

    expect(items.length, 1);
  });
  test('appointmentsByGroup returns appointments matching group', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance.collection('appointments').doc('Test Appointment 2').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group",
      "start_hour": "20"
    });

    List<Appointment> appts = appState.appointmentsByGroup("Test Group");
    List<Appointment> appts2 = appState.appointmentsByGroup("Not Test Group");

    expect(appts.length, 2);
    expect(appts2.length, 0);
  });
  test('allAppointments returns all appointments when not fileterd', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance.collection('appointments').doc('Test Appointment 2').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    List<Appointment> appts = appState.allAppointments([], []);

    expect(appts.length, 2);
  });
}

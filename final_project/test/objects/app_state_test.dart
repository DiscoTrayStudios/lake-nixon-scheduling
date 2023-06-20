import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/objects/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/event.dart';

Future<AppState> initializeAppStateTests(
    FakeFirebaseFirestore instance, MockFirebaseAuth auth) async {
  AppState appState = AppState(instance, auth);

  await auth.currentUser!.reload();

  await instance.collection('events').doc('Test Event').set({
    "name": "Test Subject",
    "ageMin": 1,
    "groupMax": 6,
    "desc": "Test Description"
  });

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
      "subject": "Test Subject 2",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    List<Appointment> appts = appState.allAppointments([], []);

    expect(appts.length, 2);
    expect(appts[0].subject, "Test Subject");
    expect(appts[1].subject, "Test Subject 2");
  });
  test(
      'allAppointments returns only matching appointments when filtered by event',
      () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance.collection('appointments').doc('Test Appointment 2').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject 2",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    List<Appointment> appts = appState.allAppointments([], ["Test Subject"]);

    expect(appts.length, 2);
    expect(appts[0].subject, "Test Subject");
    expect(appts[1].subject, "Test Subject");
  });
  test(
      'allAppointments returns only matching appointments when filtered by group',
      () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance.collection('appointments').doc('Test Appointment 2').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject 2",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    List<Appointment> appts = appState.allAppointments(
        [const Group(age: 1, color: Color(0xff000000), name: "Test Group 2")],
        []);

    expect(appts.length, 2);
    expect(appts[0].subject, "Test Subject 2");
    expect(appts[1].subject, "Test Subject");
  });
  test('addAppointments adds appointments to firebase', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance
        .collection('appointments')
        .count()
        .get()
        .then((value) => expect(value.count, 1));

    await appState.addAppointments({
      'appt 1': {
        "start_time": DateTime.utc(1969, 7, 20, 20),
        "end_time": DateTime.utc(1969, 7, 20, 20, 30),
        "color": "Color(0xff2471a3)",
        "notes": "Test Notes",
        "subject": "Test Subject",
        "group": "Test Group 2",
        "start_hour": "20"
      },
      'appt 2': {
        "start_time": DateTime.utc(1969, 7, 20, 20),
        "end_time": DateTime.utc(1969, 7, 20, 20, 30),
        "color": "Color(0xff2471a3)",
        "notes": "Test Notes",
        "subject": "Test Subject",
        "group": "Test Group 2",
        "start_hour": "20"
      }
    }, instance);

    await instance
        .collection('appointments')
        .count()
        .get()
        .then((value) => expect(value.count, 3));
    await instance
        .collection('appointments')
        .where("group", isEqualTo: "Test Group 2")
        .count()
        .get()
        .then((value) => expect(value.count, 2));
  });
  test('getCurrentAmount gets gets correct ratio of groups', () async {
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

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject 2",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    expect(
        appState.getCurrentAmount(
            "Test Subject", DateTime.utc(1969, 7, 20, 20)),
        "3/6");
  });
  test('createAppointment creates calendar appointements from firebase',
      () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    Appointment appt = appState.createAppointment(
        DateTime.utc(1969, 7, 20, 20),
        DateTime.utc(1969, 7, 20, 20, 30),
        "Color(0xff2471a3)",
        "Test Subject 2");

    expect(appt.startTime, DateTime.utc(1969, 7, 20, 20));
    expect(appt.endTime, DateTime.utc(1969, 7, 20, 20, 30));
    expect(appt.color, const Color(0xff2471a3));
    expect(appt.subject, "Test Subject 2");
  });
  test('checkEvent correctly identifies if there are too many groups',
      () async {
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

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    await instance.collection('appointments').doc('Test Appointment 4').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    expect(appState.checkEvent("Test Subject", "20", 0), true);
    expect(appState.checkEvent("Test Subject", "20", 1), true);
    expect(appState.checkEvent("Test Subject", "20", 2), true);
    expect(appState.checkEvent("Test Subject", "20", 3), false);
    expect(appState.checkEvent("Test Subject", "20", 15), false);
  });
  test('getApptsAtTime gets right appts', () async {
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

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 19),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "19"
    });

    expect(appState.getApptsAtTime(DateTime.utc(1969, 7, 20, 20)).length, 2);
  });
  test('getGroupsAtTime gets all groups in an event at the given time',
      () async {
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

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 19),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 3",
      "start_hour": "19"
    });

    List<String> groups =
        appState.getGroupsAtTime(DateTime.utc(1969, 7, 20, 20));

    expect(groups.length, 2);
    expect(groups.contains("Test Group 2"), true);
    expect(groups.contains("Test Group"), true);
    expect(groups.contains("Test Group 3"), false);
  });
  test('getGroupsAtTime doesnt add duplicates to list', () async {
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

    await instance.collection('appointments').doc('Test Appointment 3').set({
      "start_time": DateTime.utc(1969, 7, 20, 20),
      "end_time": DateTime.utc(1969, 7, 20, 20, 30),
      "color": "Color(0xff2471a3)",
      "notes": "Test Notes",
      "subject": "Test Subject",
      "group": "Test Group 2",
      "start_hour": "20"
    });

    List<String> groups =
        appState.getGroupsAtTime(DateTime.utc(1969, 7, 20, 20));

    expect(groups.length, 2);
    expect(groups.where((element) => element == "Test Group 2").length, 1);
  });
  test('lookupEventByName gets correct event', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance.collection('events').doc('Test Event 2').set({
      "name": "Test Subject 2",
      "ageMin": 3,
      "groupMax": 9,
      "desc": "Test Description"
    });

    Event event = appState.lookupEventByName("Test Subject 2");

    expect(event.name, "Test Subject 2");
    expect(event.ageMin, 3);
    expect(event.groupMax, 9);
  });
  test('createEvent adds events to firebase', () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance
        .collection('events')
        .count()
        .get()
        .then((value) => expect(value.count, 1));

    await appState.createEvent(
        instance, "Test Event 2", 9, 42, "Test Description");

    await instance
        .collection('events')
        .count()
        .get()
        .then((value) => expect(value.count, 2));
  });
  test('deleteAppointment deletes appointments locally and from firebase',
      () async {
    FakeFirebaseFirestore instance = FakeFirebaseFirestore();
    MockFirebaseAuth auth = MockFirebaseAuth(signedIn: true);

    AppState appState = await initializeAppStateTests(instance, auth);

    await instance
        .collection('appointments')
        .count()
        .get()
        .then((value) => expect(value.count, 1));

    expect(appState.appointments.length, 1);

    await appState.deleteAppt(
        DateTime.utc(1969, 7, 20, 20), "Test Subject", "Test Group");

    debugPrint(instance.dump());

    await instance
        .collection('appointments')
        .count()
        .get()
        .then((value) => expect(value.count, 0));

    expect(appState.appointments.length, 0);
  });
}

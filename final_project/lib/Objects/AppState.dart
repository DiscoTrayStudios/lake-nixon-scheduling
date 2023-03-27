import 'dart:async';
import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Objects/Event.dart';
import 'package:final_project/Objects/LakeAppointment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../Pages/CalendarPage.dart';
import '../firebase_options.dart';
import 'package:final_project/Objects/Group.dart';

/// to do:
/// move colors from globals
/// move groups from globals
/// once groups in firebase -> make getGroups
/// basically move everything from globals -> here, make everything consumer

class AppState extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  List<LakeAppointment> _appointments = [];
  List<LakeAppointment> get appointments => _appointments;

  List<Group> _groups = [];
  List<Group> get groups => _groups;

  AppState() {
    init();
  }

  bool firstSnapshot = true;
  StreamSubscription<QuerySnapshot>? eventSubscription;
  StreamSubscription<QuerySnapshot>? appointmentSubscription;
  StreamSubscription<QuerySnapshot>? groupSubscription;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseAuth.instance.userChanges().listen(
      (user) {
        eventSubscription?.cancel();
        appointmentSubscription?.cancel();
        groupSubscription?.cancel();
        print("starting to listen");
        getEvents();
        getAppointments();
        //createGroups();
        getGroups();
        firstSnapshot = false;
        notifyListeners();
      },
      onError: (error) {
        print(error);
      },
    );
    notifyListeners();
  }

  Future<void> getAppointments() async {
    appointmentSubscription = FirebaseFirestore.instance
        .collection('appointments')
        .snapshots()
        .listen((snapshot) {
      print("in appointment snapshot");
      snapshot.docs.forEach((document) {
        String valueString =
            document.data()['color'].split("(0x")[1].split(")")[0];
        int value = int.parse(valueString, radix: 16);
        Color color = new Color(value);
        Timestamp start = document.data()['start_time'];
        Timestamp end = document.data()['end_time'];
        // print("COLOR : $color");
        // print("start TIME : ${start.toDate()}");
        var lake = LakeAppointment(
            color: color,
            endTime: end.toDate(),
            group: document.data()['group'],
            notes: document.data()['notes'],
            startTime: start.toDate(),
            subject: document.data()['subject'],
            startHour: document.data()['start_hour']);
        print(lake);
        _appointments.add(lake);
      });
    });
  }

  List<Appointment> appointmentsByGroup(String group) {
    List<Appointment> apps = [];
    for (LakeAppointment app in _appointments) {
      if (app.group == group) {
        apps.add(createApp(app.startTime, app.endTime, app.color, app.subject));
      }
    }
    return apps;
  }

  List<Appointment> allAppointments() {
    List<Appointment> apps = [];
    if (_appointments.isNotEmpty) {
      print(_appointments);
      for (LakeAppointment app in _appointments) {
        print(app);
        apps.add(createApp(app.startTime, app.endTime, app.color, app.subject));
      }
    }
    return apps;
  }

  Future<void> addAppointments(Map<String, Map<String, dynamic>> events) async {
    var apps = FirebaseFirestore.instance.collection("appointments");
    for (Map<String, dynamic> app in events.values) {
      apps.doc().set(app);
    }
  }

  Appointment createApp(startTime, endTime, color, subject) {
    if (color.runtimeType == String) {
      String valueString = color.split("(0x")[1].split(")")[0];
      int value = int.parse(valueString, radix: 16);
      color = Color(value);
    }
    print("Create app : ${startTime}");
    return Appointment(
        startTime: startTime, endTime: endTime, color: color, subject: subject);
  }

  bool checkEvent(String event, String start_hour, int groupCount) {
    var current = 0;
    var _event = indexEvents(event);
    for (LakeAppointment app in _appointments) {
      // If the event capacity is not filled up, the current app is this event and they start at the same hour
      if (app.subject == event && app.startHour == start_hour) {
        current += 1;
      }
    }
    if (current + groupCount < _event.groupMax) {
      return true;
    } else {
      return false;
    }
  }

// was getEvents in Calendar Page
  Future<void> getEvents() async {
    eventSubscription = FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .listen((snapshot) {
      print("in event snapshot");
      snapshot.docs.forEach((document) {
        _events.add(Event(
            ageMin: document.data()['ageMin'],
            groupMax: document.data()['groupMax'],
            name: document.data()['name']));
      });
    });
  }

  Future<void> getGroups() async {
    groupSubscription = FirebaseFirestore.instance
        .collection('groups')
        .snapshots()
        .listen((snapshot) {
      print("in groups snapshot");
      snapshot.docs.forEach((document) {
        String valueString =
            document.data()['color'].split("(0x")[1].split(")")[0];
        int value = int.parse(valueString, radix: 16);
        Color color = new Color(value);
        _groups.add(Group(
            name: document.data()['name'],
            color: color,
            age: document.data()['age']));
      });
    });
  }

  // from globals (not sure this is ever called/will be needed after changing database)
  Event indexEvents(String name) {
    //int count = 0;
    for (Event element in _events) {
      if (element.name == name) {
        return element;
      }
      //count++;
    }
    return const Event(name: "error", ageMin: 0, groupMax: 0);
  }
}

// Future<void> createGroups() async {
//   var groups = FirebaseFirestore.instance.collection("groups");
//   for (Group group in _groups) {
//     groups.doc(group.name).set({
//       "name": group.name,
//       "color": group.color.toString(),
//       "age": group.age,
//     });
//   }
// }

// List<Group> _groups = <Group>[
//   const Group(name: "Chipmunks", color: Color(0xFF0F8644), age: 1),
//   const Group(name: "Hummingbirds", color: Color(0xFF8B1FA9), age: 1),
//   const Group(name: "Tadpoles", color: Color(0xFFD20100), age: 1),
//   const Group(name: "Sparrows", color: Color(0xFF5DADE2), age: 1),
//   const Group(name: "Salamanders", color: Color(0xFFDC7633), age: 1),
//   const Group(name: "Robins", color: Color(0xFFDEB6F1), age: 1),
//   const Group(name: "Minks", color: Color(0xFF909497), age: 3),
//   const Group(name: "Otters", color: Color(0xFF117864), age: 3),
//   const Group(name: "Raccoons", color: Color(0xFF2E4053), age: 3),
//   const Group(name: "Kingfishers", color: Color(0xFFF4D03F), age: 3),
//   const Group(name: "Squirrels", color: Color(0xFFEA45E1), age: 3),
//   const Group(name: "Blue Jays", color: Color(0xFF2471A3), age: 3),
//   const Group(name: "Deer", color: Color(0xFF504040), age: 5),
//   const Group(name: "Crows", color: Color(0xFF1C2833), age: 5),
//   const Group(name: "Bears", color: Color(0xFF60EA7A), age: 5),
//   const Group(name: "Foxes", color: Color(0xFFD35400), age: 5),
//   const Group(name: "Herons", color: Color(0xFF456CEA), age: 5),
//   const Group(name: "Wolves", color: Color(0xFF566573), age: 5),
//   const Group(name: "Copperheads", color: Color(0xFFD68910), age: 6),
//   const Group(name: "Timber Rattlers", color: Color(0xFFABEBC6), age: 8),
//   const Group(name: "Admin", color: Color.fromARGB(255, 0, 0, 0), age: 9999)
// ];

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:final_project/objects/event.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/firebase_options.dart';
import 'package:final_project/objects/group.dart';

/// to do:
/// move colors from globals
/// move groups from globals
/// once groups in firebase -> make getGroups
/// basically move everything from globals -> here, make everything consumer

class AppState extends ChangeNotifier {
  final List<Event> _events = [];
  List<Event> get events => _events;

  final List<LakeAppointment> _appointments = [];
  List<LakeAppointment> get appointments => _appointments;

  final List<Group> _groups = [];
  List<Group> get groups => _groups;

  FirebaseFirestore firestore;

  FirebaseAuth auth;

  AppState(this.firestore, this.auth) {
    init(auth, firestore);
  }

  bool firstSnapshot = true;
  StreamSubscription<QuerySnapshot>? eventSubscription;
  StreamSubscription<QuerySnapshot>? appointmentSubscription;
  StreamSubscription<QuerySnapshot>? groupSubscription;

  List<String> weekDay = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> weekDayPosition = <String>[
    'first',
    'second',
    'third',
    'fourth',
    'last'
  ];
  List<String> mobileRecurrence = <String>['day', 'week', 'month', 'year'];

  Future<void> init(FirebaseAuth auth, FirebaseFirestore firestore) async {
    auth.userChanges().listen(
      (user) {
        eventSubscription?.cancel();
        appointmentSubscription?.cancel();
        groupSubscription?.cancel();
        getEvents(firestore);
        getAppointments(firestore);
        //createGroups();
        getGroups(firestore);
        firstSnapshot = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint(error);
      },
    );
    notifyListeners();
  }

//Used to create the group checkboxes for appointment editor
  List<MultiSelectItem<Group>> createCheckboxGroups() {
    var items = groups
        .map((group) => MultiSelectItem<Group>(group, group.name))
        .toList();
    return items;
  }

//Used to create the checkbox events for the appointment editor
  List<MultiSelectItem<String>> createCheckboxEvents() {
    var items = events
        .map((event) => MultiSelectItem<String>(event.name, event.name))
        .toList();
    return items;
  }

// Takes the appointments from firebase and turns them into a class called
// LakeAppointment and puts them in a list we can use throughout the program
  Future<void> getAppointments(FirebaseFirestore firestore) async {
    appointmentSubscription =
        firestore.collection('appointments').snapshots().listen((snapshot) {
      _appointments.clear();
      for (var document in snapshot.docs) {
        String valueString =
            document.data()['color'].split("(0x")[1].split(")")[0];
        int value = int.parse(valueString, radix: 16);
        Color color = Color(value);
        Timestamp start = document.data()['start_time'];
        Timestamp end = document.data()['end_time'];
        var lake = LakeAppointment(
            color: color,
            endTime: end.toDate(),
            group: document.data()['group'],
            notes: document.data()['notes'],
            startTime: start.toDate(),
            subject: document.data()['subject'],
            startHour: document.data()['start_hour']);
        _appointments.add(lake);
      }
    });
  }

//Returns a list of appointments for the group you give as a parameter
  List<Appointment> appointmentsByGroup(String group) {
    List<Appointment> apps = [];
    for (LakeAppointment app in _appointments) {
      if (app.group == group) {
        apps.add(createAppointment(
            app.startTime, app.endTime, app.color, app.subject));
      }
    }
    return apps;
  }

//Returns all appointments in a way the calendar can use them
//It also has parameters that allow for the appointments to be filtered by events or groups
  List<Appointment> allAppointments(
      List<Group> selectedGroups, List<String> selectedEvents) {
    List<Appointment> apps = [];
    if (selectedGroups.isEmpty && selectedEvents.isEmpty) {
      if (_appointments.isNotEmpty) {
        for (LakeAppointment app in _appointments) {
          apps.add(createAppointment(
              app.startTime, app.endTime, app.color, app.subject));
        }
      }
    } else if (selectedGroups.isNotEmpty) {
      if (_appointments.isNotEmpty) {
        var groupNames = [];
        for (Group group in selectedGroups) {
          groupNames.add(group.name);
        }
        for (LakeAppointment app in _appointments) {
          if (groupNames.contains(app.group)) {
            apps.add(createAppointment(
                app.startTime, app.endTime, app.color, app.subject));
          }
        }
      }
    } else {
      for (LakeAppointment app in _appointments) {
        if (selectedEvents.contains(app.subject)) {
          apps.add(createAppointment(
              app.startTime, app.endTime, app.color, app.subject));
        }
      }
    }

    return apps;
  }

// This function takes in appointments formatted to be put into firebase and puts them into firebase
  Future<void> addAppointments(Map<String, Map<String, dynamic>> events,
      FirebaseFirestore firestore) async {
    var apps = firestore.collection("appointments");
    for (Map<String, dynamic> app in events.values) {
      apps.doc().set(app);
    }
  }

// Gets the amount of groups in an event at a specific time and returns that as a value that shows how many are in the event
// out of how many can be in the event. This is used in the event dropdown so you can see when selecting how full they are.
  String getCurrentAmount(String event, startTime) {
    var apps = getApptsAtTime(startTime);
    var count = 0;
    var total = lookupEventByName(event).groupMax;
    for (LakeAppointment app in apps) {
      if (app.subject == event) {
        count++;
      }
    }
    return "$count/$total";
  }

  //Move this function to appontment_editor.dart
  //FIX THE START TIME ISSUE AND MAKE IT DAY SPECIFIC NOT TIME SPECIFIC
  //^^ I think this has been fixed but I'll keep that there just to make sure its not forgotten if I didn't fix it
  // This creates the event dropdown with the amount of groups in each event
  List<DropdownMenuItem<String>> createDropdown(
      List<Event> items, DateTime startTime) {
    List<DropdownMenuItem<String>> newItems = [];
    for (Event event in items) {
      var currentAmount = getCurrentAmount(event.name, startTime);
      newItems.add(DropdownMenuItem(
          value: event.name, child: Text("${event.name}  $currentAmount")));
    }
    return newItems;
  }

  //Takes a firebase appointment and turns it into a calendar appointment
  Appointment createAppointment(startTime, endTime, color, subject) {
    if (color.runtimeType == String) {
      String valueString = color.split("(0x")[1].split(")")[0];
      int value = int.parse(valueString, radix: 16);
      color = Color(value);
    }
    return Appointment(
        startTime: startTime, endTime: endTime, color: color, subject: subject);
  }

  //Checks how many groups are in an event and a specific time
  //and then checks to see if the amount the user wanted
  //to add is more than the limit and returns true or false.
  bool checkEvent(String event, String startHour, int groupCount) {
    var current = 0;
    var event0 = lookupEventByName(event);
    for (LakeAppointment app in _appointments) {
      // If the event capacity is not filled up, the current app is this event and they start at the same hour
      if (app.subject == event && app.startHour == startHour) {
        current += 1;
      }
    }
    if (current + groupCount <= event0.groupMax) {
      return true;
    } else {
      return false;
    }
  }

//Returns the appointments happening at a certain time
  List<LakeAppointment> getApptsAtTime(startTime) {
    List<LakeAppointment> apps = [];
    for (LakeAppointment app in _appointments) {
      if (app.startTime!.isAtSameMomentAs(startTime)) {
        apps.add(app);
      }
    }
    return apps;
  }

// Gets the groups in events at certain time
  List<String> getGroupsAtTime(startTime) {
    List<String> groups = [];
    for (LakeAppointment app in _appointments) {
      if (app.startTime!.isAtSameMomentAs(startTime) &&
          !groups.contains(app.group!)) {
        groups.add(app.group!);
      }
    }
    return groups;
  }

// get all of the events from firebase
  Future<void> getEvents(FirebaseFirestore firestore) async {
    eventSubscription =
        firestore.collection('events').snapshots().listen((snapshot) {
      _events.clear();
      for (var document in snapshot.docs) {
        _events.add(Event(
            ageMin: document.data()['ageMin'],
            groupMax: document.data()['groupMax'],
            name: document.data()['name'],
            desc: document.data()['desc']));
      }
    });
  }

//gets all of the groups from firebase
  Future<void> getGroups(FirebaseFirestore firestore) async {
    groupSubscription =
        firestore.collection('groups').snapshots().listen((snapshot) {
      _groups.clear();
      for (var document in snapshot.docs) {
        String valueString =
            document.data()['color'].split("(0x")[1].split(")")[0];
        int value = int.parse(valueString, radix: 16);
        Color color = Color(value);
        _groups.add(Group(
            name: document.data()['name'],
            color: color,
            age: document.data()['age']));
      }
    });
  }

  // give this function an event name and it will give you the index for event in the global list
  //so that you can extract other information
  Event lookupEventByName(String name) {
    //int count = 0;
    for (Event element in _events) {
      if (element.name == name) {
        return element;
      }
      //count++;
    }
    return const Event(name: "error", ageMin: 0, groupMax: 0, desc: "");
  }

  Future<void> createEvent(FirebaseFirestore firestore, String name, int ageMin,
      int groupMax, String desc) async {
    CollectionReference events = firestore.collection("events");
    final snapshot = await events.get();

    int count = snapshot.size;
    events.doc("$count").set(
        {"name": name, "ageMin": ageMin, "groupMax": groupMax, "desc": desc});
  }

  // Future<void> createEvents() async {
  //   var events = FirebaseFirestore.instance.collection("events");
  //   for (Event event in _events) {
  //     events.doc(event.name).set({
  //       "name": event.name,
  //       "ageMin": event.ageMin,
  //       "groupMax": event.groupMax,
  //       "desc": ""
  //     });
  //   }
  // }
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

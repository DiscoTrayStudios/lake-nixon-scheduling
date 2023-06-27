import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:final_project/objects/activity.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/objects/group.dart';

/// The state of the app, containing globally used variables and functions.
///
/// This manages listeners to the Firebase Firestore collections for
/// 'appointments', 'events', and 'groups', and updates corresponding lists of
/// [LakeAppointment], [Activity], and [Group] objects. These lists, and the
/// related methods, are provided to the rest of the app through a
/// [ChangeNotifierProvider].
class AppState extends ChangeNotifier {
  final List<Activity> _activities = [];

  /// The activities currently in the Firestore database.
  List<Activity> get activities => _activities;

  final List<LakeAppointment> _appointments = [];

  /// The appointments currently in the Firestore database.
  List<LakeAppointment> get appointments => _appointments;

  final List<Group> _groups = [];

  /// The groups currently in the Firestore database.
  List<Group> get groups => _groups;

  /// The current instance of Firestore.
  FirebaseFirestore firestore;

  /// The current instance of Firebase Auth.
  FirebaseAuth auth;

  /// The state of the app, containing globally used variables and functions.
  ///
  /// This initializes listeners to the Firebase Firestore collections for
  /// 'appointments', 'events', and 'groups', and updates corresponding lists of
  /// [LakeAppointment], [Activity], and [Group] objects. These lists, and the
  /// related methods, are provided to the rest of the app through a
  /// [ChangeNotifierProvider].
  ///
  /// The listeners are only initialized if the user is signed in to the app.
  ///
  /// The instances of [FirebaseFirestore] and [FirebaseAuth] used by the [AppState]
  /// are exposed as parameters so that they may be mocked for testing purposes.
  AppState(this.firestore, this.auth) {
    init(auth, firestore);
  }

  bool firstSnapshot = true;

  /// A subscription to listen to the Firestore 'events' collection.
  StreamSubscription<QuerySnapshot>? activitySubscription;

  /// A subscription to listen the the Firestore 'appointments' collection.
  StreamSubscription<QuerySnapshot>? appointmentSubscription;

  /// A subscription to listen to the Firestore 'groups' collection.
  StreamSubscription<QuerySnapshot>? groupSubscription;

  /// Used for reccurence, an unimplemented feature.
  List<String> weekDay = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  /// Used for reccurence, an unimplemented feature.
  List<String> weekDayPosition = <String>[
    'first',
    'second',
    'third',
    'fourth',
    'last'
  ];

  /// Used for reccurence, an unimplemented feature.
  List<String> mobileRecurrence = <String>['day', 'week', 'month', 'year'];

  /// Initailizes this class with FireStore listensers and authentication.
  ///
  /// A listener to Firebase Auth is created so that the listeners to the
  /// Firestore database can be created or destroyed when users sign in and out.
  ///
  /// Additionally, if the user is logged in, the local state is updated to match
  /// Firestore on initialization.
  Future<void> init(FirebaseAuth auth, FirebaseFirestore firestore) async {
    if (auth.currentUser != null) {
      QuerySnapshot<Map<String, dynamic>> activityData =
          await firestore.collection('events').get();

      QuerySnapshot<Map<String, dynamic>> appointmentData =
          await firestore.collection('appointments').get();

      QuerySnapshot<Map<String, dynamic>> groupData =
          await firestore.collection('groups').get();

      getActivitiesFromData(activityData);
      getAppointmentsFromData(appointmentData);
      getGroupsFromData(groupData);
    }
    auth.userChanges().listen(
      (user) async {
        activitySubscription?.cancel();
        appointmentSubscription?.cancel();
        groupSubscription?.cancel();
        if (user != null) {
          startActivitiesListener(firestore);
          startAppointmentsListener(firestore);
          startGroupsListener(firestore);
          firstSnapshot = false;

          QuerySnapshot<Map<String, dynamic>> activityData =
              await firestore.collection('events').get();

          QuerySnapshot<Map<String, dynamic>> appointmentData =
              await firestore.collection('appointments').get();

          QuerySnapshot<Map<String, dynamic>> groupData =
              await firestore.collection('groups').get();

          getActivitiesFromData(activityData);
          getAppointmentsFromData(appointmentData);
          getGroupsFromData(groupData);

          notifyListeners();
        }
      },
      onError: (error) {
        debugPrint(error);
      },
    );
    notifyListeners();
  }

  /// Creates a listener to the 'appointments' collection in Firestore.
  ///
  /// This listener updates the local list of [LakeAppointment]s to match the
  /// collection.
  Future<void> startAppointmentsListener(FirebaseFirestore firestore) async {
    appointmentSubscription =
        firestore.collection('appointments').snapshots().listen((snapshot) {
      getAppointmentsFromData(snapshot);
    });
  }

  /// Creates a listener to the 'events' collection in Firestore.
  ///
  /// This listener updates the local list of [Activity]s to match the
  /// collection.
  Future<void> startActivitiesListener(FirebaseFirestore firestore) async {
    activitySubscription =
        firestore.collection('events').snapshots().listen((snapshot) {
      getActivitiesFromData(snapshot);
    });
  }

  /// Creates a listener to the 'groups' collection in Firestore.
  ///
  /// This listener updates the local list of [Group]s to match the
  /// collection.
  Future<void> startGroupsListener(FirebaseFirestore firestore) async {
    groupSubscription =
        firestore.collection('groups').snapshots().listen((snapshot) {
      getGroupsFromData(snapshot);
    });
  }

  /// Updates the list of [Activity]s to match Firestore.
  ///
  /// Takes the documents from the given [QuerySnapshot] of the 'events' collection, and updates
  /// the local list to match.
  void getActivitiesFromData(QuerySnapshot<Map<String, dynamic>> data) {
    _activities.clear();
    for (var document in data.docs) {
      _activities.add(Activity(
          ageMin: document.data()['ageMin'],
          groupMax: document.data()['groupMax'],
          name: document.data()['name'],
          desc: document.data()['desc']));
    }
    notifyListeners();
  }

  /// Updates the list of [LakeAppointment]s to match Firestore.
  ///
  /// Takes the documents from the given [QuerySnapshot] of the 'appointments' collection, and updates
  /// the local list to match.
  void getAppointmentsFromData(QuerySnapshot<Map<String, dynamic>> data) {
    _appointments.clear();
    for (var document in data.docs) {
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
      );
      _appointments.add(lake);
    }
    notifyListeners();
  }

  /// Updates the list of [Group]s to match Firestore.
  ///
  /// Takes the documents from the given [QuerySnapshot] of the 'groups' collection, and updates
  /// the local list to match.
  void getGroupsFromData(QuerySnapshot<Map<String, dynamic>> data) {
    _groups.clear();
    for (var document in data.docs) {
      String valueString =
          document.data()['color'].split("(0x")[1].split(")")[0];
      int value = int.parse(valueString, radix: 16);
      Color color = Color(value);
      _groups.add(Group(
          name: document.data()['name'],
          color: color,
          age: document.data()['age']));
    }
    notifyListeners();
  }

  /// Returns all of the [Appointment]s that the given group is assigned to.
  ///
  /// The group name is taken as a [String]. Note that the returned appointments
  /// are of the [Appointment] type used by the calendar, not the [LakeAppointment]
  /// used elsewhere.
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

  /// Returns the [LakeAppointment]s of the given activity type.
  List<LakeAppointment> lakeAppointmentsByActivity(String activity) {
    List<LakeAppointment> apps = [];
    for (LakeAppointment app in _appointments) {
      if (app.subject == activity) {
        apps.add(app);
      }
    }
    return apps;
  }

  /// Filters [Appointment] by the given [Group]s and [Activity]s.
  ///
  /// If either of the lists of [Activity]s or [Group]s are empty, that filter is
  /// not applied.
  List<Appointment> allAppointments(
      List<Group> selectedGroups, List<String> selectedActivities) {
    List<Appointment> apps = [];
    if (selectedGroups.isEmpty && selectedActivities.isEmpty) {
      if (_appointments.isNotEmpty) {
        for (LakeAppointment app in _appointments) {
          apps.add(createAppointment(
              app.startTime, app.endTime, app.color, app.subject));
        }
      }
    } else if (selectedGroups.isNotEmpty && selectedActivities.isNotEmpty) {
      if (_appointments.isNotEmpty) {
        var groupNames = [];
        for (Group group in selectedGroups) {
          groupNames.add(group.name);
        }
        for (LakeAppointment app in _appointments) {
          if (groupNames.contains(app.group) &&
              selectedActivities.contains(app.subject)) {
            apps.add(createAppointment(
                app.startTime, app.endTime, app.color, app.subject));
          }
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
        if (selectedActivities.contains(app.subject)) {
          apps.add(createAppointment(
              app.startTime, app.endTime, app.color, app.subject));
        }
      }
    }

    return apps;
  }

  /// Places appointments into the Firestore database.
  ///
  /// The [LakeAppointment]s need to be converted to a map first.
  Future<void> addAppointments(Map<String, Map<String, dynamic>> activities,
      FirebaseFirestore firestore) async {
    var apps = firestore.collection("appointments");
    for (Map<String, dynamic> app in activities.values) {
      apps.doc().set(app);
    }
  }

  /// Calculates the ratio of [Group]s in an [Activity] at a time to the total number
  /// allowed.
  ///
  /// The ratio is returned as a string to be displayed on the appointment editor
  /// activity dropdown.
  String getCurrentAmount(String activity, startTime) {
    var count = 0;
    var total = lookupActivityByName(activity).groupMax;
    for (LakeAppointment app in getApptsAtTime(startTime)) {
      if (app.subject == activity) {
        count++;
      }
    }
    return "$count/$total";
  }

  /// Creates an [Appointment] from the relevant data.
  ///
  /// Effectively the same as the [Appointment] constructor, but with additional
  /// logic to convert the color field from a string if necessary.
  Appointment createAppointment(startTime, endTime, color, subject) {
    if (color.runtimeType == String) {
      String valueString = color.split("(0x")[1].split(")")[0];
      int value = int.parse(valueString, radix: 16);
      color = Color(value);
    }
    return Appointment(
        startTime: startTime, endTime: endTime, color: color, subject: subject);
  }

  /// Checks if adding [Group]s to an [Activity] would exceed its capacity.
  ///
  /// Checks if the given [activity] would exceed its capacity in all of the
  /// timeslots between [startTime] and [endTime] if [groupCount] groups were added
  /// to it.
  ///
  /// [originalStartTime] and [originalEndTime] are only used if an [Appointment] is
  /// being moved instead of added. In that case, it is necessary to account for the
  /// appointment already existing in the timeslots between [originalStartTime]
  /// and [originalEndTime]. In those time slots, 1 is subtracted from the current
  /// number of groups for the appointment being moved.
  ///
  /// Returns true if no limits are exceeded.
  bool checkActivity(
      String activity, DateTime startTime, DateTime endTime, int groupCount,
      [DateTime? originalStartTime, DateTime? originalEndTime]) {
    Activity activity0 = lookupActivityByName(activity);
    for (DateTime time = startTime;
        time.isBefore(endTime);
        time = time.add(const Duration(hours: 1))) {
      int current = 0;
      // If the activity capacity is not filled up, the current app is this activity and they start at the same hour
      for (LakeAppointment app in getApptsAtTime(time)) {
        if (app.subject == activity) {
          current += 1;
        }
      }
      if ((originalStartTime == null || originalEndTime == null) &&
          current + groupCount > activity0.groupMax) {
        return false;
      } else if (originalStartTime != null && originalEndTime != null) {
        if (((originalStartTime.isBefore(time) ||
                    originalStartTime.isAtSameMomentAs(time)) &&
                originalEndTime.isAfter(time)) &&
            current + groupCount - 1 > activity0.groupMax) {
          return false;
        } else if ((originalStartTime.isAfter(time) ||
                (originalEndTime.isBefore(time) ||
                    originalEndTime.isAtSameMomentAs(time))) &&
            current + groupCount > activity0.groupMax) {
          return false;
        }
      }
    }
    return true;
  }

  /// Checks if a group is already in an appointment.
  ///
  /// Checks if the [group] is not in any appointments between [startTime] and
  /// [endTime].
  ///
  /// [originalStartTime] and [originalEndTime] are only used if an appointment
  /// is being moved instead of added. In that case, it is necessary to ignore
  /// the original appointment that was scheduled between [originalStartTime] and
  /// [originalEndTime]
  bool checkGroupTime(
      {required String group,
      required DateTime startTime,
      required DateTime endTime,
      DateTime? originalStartTime,
      DateTime? originalEndTime}) {
    for (DateTime time = startTime;
        time.isBefore(endTime);
        time = time.add(const Duration(hours: 1))) {
      for (LakeAppointment app in getApptsAtTime(time)) {
        if ((originalStartTime == null || originalEndTime == null) &&
            app.group == group) {
          return false;
        } else if (originalStartTime != null && originalEndTime != null) {
          if ((originalStartTime.isAfter(time) ||
                  (originalEndTime.isBefore(time) ||
                      originalEndTime.isAtSameMomentAs(time))) &&
              app.group == group) {
            return false;
          }
        }
      }
    }
    return true;
  }

  /// Deletes an appointment from firebase and updates to local database.
  ///
  /// Finds the appointment that matches the [startTime], [subject], and [group]
  /// and deletes it. Due to the app design, there should never be more than one
  /// appointment that matches these criteria.
  Future<void> deleteAppt(
      {required DateTime startTime,
      required String subject,
      required String group}) async {
    QuerySnapshot<Map<String, dynamic>> query = await firestore
        .collection('appointments')
        .where('start_time', isEqualTo: startTime)
        .where('subject', isEqualTo: subject)
        .where('group', isEqualTo: group)
        .get();

    await firestore.runTransaction((Transaction transaction) async =>
        transaction.delete(query.docs[0].reference));

    QuerySnapshot<Map<String, dynamic>> appointmentData =
        await firestore.collection('appointments').get();

    getAppointmentsFromData(appointmentData);

    notifyListeners();
  }

  /// Updates an appointment in firebase.
  ///
  /// Finds the appointment using the old [startTime], [subject], and [group],
  /// and updates it with the new [data].
  Future<void> editAppt(
      {required DateTime startTime,
      required String subject,
      required String group,
      required Map<String, dynamic> data}) async {
    QuerySnapshot<Map<String, dynamic>> query = await firestore
        .collection('appointments')
        .where('start_time', isEqualTo: startTime)
        .where('subject', isEqualTo: subject)
        .where('group', isEqualTo: group)
        .get();

    await firestore.runTransaction((Transaction transaction) async =>
        transaction.update(query.docs[0].reference, data));
  }

  /// Finds all appointments that are happening at [startTime].
  List<LakeAppointment> getApptsAtTime(DateTime startTime) {
    List<LakeAppointment> apps = [];
    for (LakeAppointment app in _appointments) {
      if (app.startTime!.isAtSameMomentAs(startTime) ||
          (app.startTime!.isBefore(startTime) &&
              app.endTime!.isAfter(startTime))) {
        apps.add(app);
      }
    }
    return apps;
  }

  /// Finds all groups that are in an appointment at [startTime]
  List<String> getGroupsAtTime(startTime) {
    List<String> groups = [];
    for (LakeAppointment app in getApptsAtTime(startTime)) {
      if (!groups.contains(app.group!)) {
        groups.add(app.group!);
      }
    }
    return groups;
  }

  /// Looks up and activity with the given [name].
  ///
  /// Returns an activity with the name "error" if there is no activity called
  /// [name]. Avoid using this in a context where it may be passed the name of
  /// a non-existant activity.
  Activity lookupActivityByName(String name) {
    //int count = 0;
    for (Activity element in _activities) {
      if (element.name == name) {
        return element;
      }
      //count++;
    }
    return const Activity(name: "error", ageMin: 0, groupMax: 0, desc: "");
  }

  /// Adds an activity to Firestore with the given parameters.
  Future<void> createActivity(FirebaseFirestore firestore, String name,
      int ageMin, int groupMax, String desc) async {
    CollectionReference activities = firestore.collection("events");

    activities.doc().set(
        {"name": name, "ageMin": ageMin, "groupMax": groupMax, "desc": desc});
  }

  /// Deletes the activity matching [activity] from firebase and updates the local
  /// database.
  Future<void> deleteActivity(Activity activity) async {
    QuerySnapshot<Map<String, dynamic>> query = await firestore
        .collection('events')
        .where('ageMin', isEqualTo: activity.ageMin)
        .where('desc', isEqualTo: activity.desc)
        .where('groupMax', isEqualTo: activity.groupMax)
        .where('name', isEqualTo: activity.name)
        .get();

    await firestore.runTransaction((Transaction transaction) async =>
        transaction.delete(query.docs[0].reference));

    QuerySnapshot<Map<String, dynamic>> activityData =
        await firestore.collection('events').get();

    getActivitiesFromData(activityData);

    notifyListeners();
  }

  /// Checks if there is an activity named [name].
  bool nameInActivities(String name) {
    for (Activity activity in _activities) {
      if (name == activity.name) {
        return true;
      }
    }
    return false;
  }

  /// Filters out all groups younger than [age] from [groups].
  List<Group> filterGroupsByAge(int age, List<Group> groups) {
    List<Group> outGroups = [];

    for (Group group in groups) {
      if (age <= group.age) {
        outGroups.add(group);
      }
    }

    return outGroups;
  }

  /// Filters out groups currently in an appointment.
  ///
  /// Removes all groups in an appointment between [startTime] and [endTime] from
  /// [groups].
  List<Group> filterGroupsByTime(
      DateTime startTime, DateTime endTime, List<Group> groups) {
    List<String> excludedGroups = [];
    for (DateTime time = startTime;
        time.isBefore(endTime);
        time = time.add(const Duration(hours: 1))) {
      excludedGroups.addAll(getGroupsAtTime(startTime));
    }

    excludedGroups = [
      ...{...excludedGroups}
    ];
    List<Group> showGroups = [];
    for (Group group in groups) {
      if (!excludedGroups.contains(group.name)) {
        showGroups.add(group);
      }
    }
    return showGroups;
  }
}

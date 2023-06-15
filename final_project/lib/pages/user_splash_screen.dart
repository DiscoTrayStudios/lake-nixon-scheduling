import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:final_project/objects/group.dart';
import 'package:final_project/pages/group_page.dart';
import 'package:final_project/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // for (Group g in groups) {
    //   createGroup(g);
    // }
    // getSavedEvents();
    super.initState();
  }

  // Future<void> getSavedEvents() async {
  //   CollectionReference schedules =
  //       FirebaseFirestore.instance.collection("schedules");
  //   final snapshot = await schedules.get();
  //   if (snapshot.size > 0) {
  //     List<QueryDocumentSnapshot<Object?>> data = snapshot.docs;
  //     for (var element in data) {
  //       var event = element.data() as Map;
  //       Map apps = event["appointments"];

  //       apps.forEach((key, value) {
  //         for (var appt in value) {
  //           var app = appt["appointment"];
  //           var test = app[2];
  //           String valueString = test.split('(0x')[1].split(')')[0];
  //           int value = int.parse(valueString, radix: 16);
  //           Color color = Color(value);
  //           debugPrint(app[6]);
  //           Appointment tmp = Appointment(
  //               startTime: app[0].toDate(),
  //               endTime: app[1].toDate(),
  //               color: color,
  //               startTimeZone: app[3],
  //               endTimeZone: app[4],
  //               notes: app[5],
  //               isAllDay: app[6],
  //               subject: app[7],
  //               resourceIds: app[8],
  //               recurrenceRule: app[9]);
  //           var group = indexGroups(key);
  //           events[group]!.add(tmp);
  //         }
  //       });
  //     }
  //   } else {
  //     debugPrint('No data available.');
  //   }
  // }

  Future<void> groupPagePush() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const GroupPage(title: "List of groups"),
      ),
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> logoutScreenPush() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Welcome to Lake Nixon!",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize),
            )),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                const Image(
                  image: AssetImage('images/lakenixonlogo.png'),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 80,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.secondary)),
                        child: Text(
                          'Select Group',
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .fontSize,
                              color: Theme.of(context).colorScheme.onSecondary),
                        ),
                        onPressed: () {
                          groupPagePush();
                        },
                      ),
                    )),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.tertiary)),
                    child: Text(
                      "Logout",
                      style: TextStyle(
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize,
                          color: Theme.of(context).colorScheme.onTertiary),
                    ),
                    onPressed: () {
                      logout();
                      logoutScreenPush();
                    },
                  ),
                ),
              ],
            )));
  }
}

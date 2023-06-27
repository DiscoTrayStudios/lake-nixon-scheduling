import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:final_project/objects/app_state.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    // for (Group g in groups) {
    //   createGroup(g);
    // }
    // getSavedActivities(appState.firestore);
    super.initState();
  }

  // Future<void> getSavedActivities(FirebaseFirestore firebase) async {
  //   CollectionReference schedules = firebase.collection("schedules");
  //   final snapshot = await schedules.get();
  //   if (snapshot.size > 0) {
  //     List<QueryDocumentSnapshot<Object?>> data = snapshot.docs;
  //     for (var element in data) {
  //       var activity = element.data() as Map;
  //       Map apps = activity["appointments"];

  //       apps.forEach((key, value) {
  //         for (var appt in value) {
  //           var app = appt["appointment"];
  //           var test = app[2];
  //           String valueString = test.split('(0x')[1].split(')')[0];
  //           int value = int.parse(valueString, radix: 16);
  //           Color color = Color(value);
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
  //           activities[group]!.add(tmp);
  //         }
  //       });
  //     }
  //   } else {
  //     debugPrint('No data available.2');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Action Page",
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Lake Nixon Admin',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .fontSize),
                    )),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 80,
                      child: ElevatedButton(
                        key: const Key('groupsNavButton'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.secondary)),
                        child: Text("Groups",
                            style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .fontSize)),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/groupsPage');
                        },
                      ),
                    )),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    key: const Key('masterCalendarNavButton'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.secondary)),
                    child: Text("Master Calendar",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .fontSize)),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/masterPage');
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: ElevatedButton(
                    key: const Key('logOutNavButton'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.tertiary)),
                    child: Text("Log Out",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onTertiary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .fontSize)),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .auth
                          .signOut();
                      Navigator.of(context).pushReplacementNamed('/loginPage');
                    },
                  ),
                ),
              ],
            )));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/pages/activity_editor.dart';
import 'package:flutter/material.dart';
import "package:syncfusion_flutter_calendar/calendar.dart";
import 'package:provider/provider.dart';

import 'package:final_project/objects/group.dart';
import 'package:final_project/pages/calendar_page.dart';

import 'package:final_project/objects/app_state.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({Key? key}) : super(key: key);

  @override
  State<MasterPage> createState() => _MasterPageState();
}

final List<CalendarView> _allowedViews = <CalendarView>[
  CalendarView.workWeek,
  CalendarView.day
];

class _MasterPageState extends State<MasterPage> {
  Future<void> masterPush() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => const CalendarPage(
                group:
                    Group(name: "Admin", color: Color(0xFFFFFFFF), age: 99999),
                title: "Master",
                isUser: true,
                master: true,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text("Master Calendar",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    height: 80,
                    child: Text(
                      'Lake Nixon',
                      style: TextStyle(
                          //nixonblue
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 80,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.secondary)),
                    child: Text(
                      "View Activities",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ActivityEditor()),
                      );
                      ;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 80,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.secondary)),
                    child: Text("View Master Calendar",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .fontSize)),
                    onPressed: () {
                      masterPush();
                    },
                  ),
                ),
              ],
            )));
  }
}

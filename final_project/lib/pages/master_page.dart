import 'package:final_project/objects/screen_arguments.dart';
import 'package:flutter/material.dart';

import 'package:final_project/objects/group.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({Key? key}) : super(key: key);

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  Future<void> masterPush() async {
    await Navigator.pushNamed(context, '/calendarPage',
        arguments: CalendarArguments(
          group:
              const Group(name: "Admin", color: Color(0xFFFFFFFF), age: 99999),
          title: "Master",
          isUser: true,
          master: true,
        ));
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
                      Navigator.pushNamed(context, '/activityEditorPage');
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

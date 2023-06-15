import 'package:cloud_firestore/cloud_firestore.dart';
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
  var eventController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descController = TextEditingController();

  Future<void> _eventInfoPopupForm(BuildContext context) async {
    final provider = Provider.of<AppState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Add Event',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 200,
              width: 200,
              child: Column(
                children: [
                  // call FormFieldTemplate for each
                  // will allow for easier universal use for future code iterations
                  FormFieldTemplate(
                      controller: eventController,
                      decoration: 'Event',
                      formkey: "EventField"),
                  FormFieldTemplate(
                      controller: ageLimitController,
                      decoration: 'Age Limit',
                      formkey: "MarkField"),
                  FormFieldTemplate(
                      controller: groupSizeController,
                      decoration: 'Group Size',
                      formkey: "YearField"),
                  FormFieldTemplate(
                      controller: descController,
                      decoration: 'Description',
                      formkey: "DescField")
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const Key("OKButton"),
              onPressed: () async {
                // This is how you get the database from Firebase

                provider.createEvent(
                    provider.firestore,
                    eventController.text,
                    int.parse(ageLimitController.text),
                    int.parse(groupSizeController.text),
                    descController.text);

                eventController.clear();
                ageLimitController.clear();
                groupSizeController.clear();
                descController.clear();
                Navigator.pop(context);
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

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
                      "Add event",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize),
                    ),
                    onPressed: () {
                      _eventInfoPopupForm(context);
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

class FormFieldTemplate extends StatelessWidget {
  const FormFieldTemplate(
      {super.key,
      required this.controller,
      required this.decoration,
      required this.formkey});

  // key for field, controller, and string decoration
  final String formkey;
  final TextEditingController controller;
  final String decoration;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key(formkey),
      controller: controller,
      decoration: InputDecoration(hintText: decoration),
    );
  }
}

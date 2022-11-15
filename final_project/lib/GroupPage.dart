import 'package:flutter/material.dart';
import 'Group.dart';
import 'calender_page.dart';
import "globals.dart";
import 'package:firebase_database/firebase_database.dart';
import "create_event.dart" as Event;

List<Group> groups = <Group>[
  const Group(name: "Bears"),
  const Group(name: "Koalas"),
  const Group(name: "Kangaroos")
];

class GroupPage extends StatefulWidget {
  GroupPage({super.key, required this.title});

  final String title;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  var eventController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descriptionController = TextEditingController();
  Future<void> _handleCalendar(Group group) async {
    print("Chat");
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarPage(title: group.name, group: group),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('List of groups'),
        ),
        body: Column(
          // padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: groups.map((Group) {
            return GroupItem(
              group: Group,
              onListChanged: _handleCalendar,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              _EventInfoPopupForm(context);
            }));
  }

  Future<void> _EventInfoPopupForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Event'),
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
                      controller: descriptionController,
                      decoration: 'Description',
                      formkey: "MeetField"),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              key: const Key("OKButton"),
              onPressed: () async {
                int count = 0;
                DatabaseReference test = FirebaseDatabase.instance.ref();
                final snapshot = await test.child("events").get();
                if (snapshot.exists) {
                  Map? test = snapshot.value as Map?;
                  test?.forEach((key, value) {
                    count++;
                  });
                } else {
                  print('No data available.');
                }
                DatabaseReference ref = FirebaseDatabase.instance.ref("events");
                await ref.update({
                  "$count": {
                    "name": eventController.text,
                    "age_limit": ageLimitController.text,
                    "group_limit": groupSizeController.text,
                    "desc": descriptionController.text
                  }
                });
                Navigator.pop(context);
              },
              child: Text('Send'),
            ),
          ],
        );
      },
    );
  }
}

// standard template for FormFields when adding events
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

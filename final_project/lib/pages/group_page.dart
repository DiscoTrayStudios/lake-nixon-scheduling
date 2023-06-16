import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/objects/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:final_project/pages/user_calendar_page.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/pages/calendar_page.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.title});

  final String title;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool admin = false;
  var eventController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descriptionController = TextEditingController();

  Future<void> userPush(Group group) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => UserCalendarPage(
                title: group.name,
                group: group,
                isUser: true,
                master: false,
              )),
    );
    //await Navigator.of(context).push(
    //MaterialPageRoute(builder: (context) => const StartPage()),
    //);
  }

  Future<void> adminPush(Group group) async {
    //await Navigator.of(context).push(
    // MaterialPageRoute(builder: (context) => const SplashScreen()),
    //);

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CalendarPage(
          title: group.name,
          group: group,
          isUser: false,
          master: false,
        ),
      ),
    );
    //await Navigator.of(context).push(
    //MaterialPageRoute(builder: (context) => const StartPage()),
    //);
  }

  void _checkAuth(Group group) async {
    User? user = FirebaseAuth.instance.currentUser;

    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();

    setState(() {
      admin = snap['admin'];
    });

    if (admin) {
      adminPush(group);
    } else {
      userPush(group);
    }
  }

  Future<void> _handleCalendar(Group group) async {
    debugPrint("Chat");

    _checkAuth(group);
    //await Navigator.of(context).push(
    //MaterialPageRoute(
    //builder: (context) => CalendarPage(title: group.name, group: group),
    //),
    //);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of Groups"),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 40, 0),
          child: ListView(
            // padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: Provider.of<AppState>(context).groups.map((group) {
              return GroupItem(
                group: group,
                onTap: _handleCalendar,
              );
            }).toList(),
          )),
      // floatingActionButton: FloatingActionButton(
      //     child: const Icon(Icons.add),
      //     onPressed: () async {
      //       //_EventInfoPopupForm(context);
      //     })
    );
  }

  Future<void> _eventInfoPopupForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Event'),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              key: const Key("OKButton"),
              onPressed: () async {
                // This is how you get the database from Firebase
                CollectionReference events =
                    FirebaseFirestore.instance.collection("events");
                final snapshot = await events.get();

                // Example of reading in a collection and getting each doc

                // if (snapshot.size > 0) {
                //   List<QueryDocumentSnapshot<Object?>> data = snapshot.docs;
                //   data.forEach((element) {
                //     debugPrint(element.data());
                //   });
                // } else {
                //   debugPrint('No data available.');
                // }

                //This is where we write database, specfically to the event collection. You can change collection just up a couple lines
                int count = snapshot.size;
                events.doc("$count").set({
                  "name": eventController.text,
                  "ageMin": int.parse(ageLimitController.text),
                  "groupMax": int.parse(groupSizeController.text)
                });
                eventController.clear();
                ageLimitController.clear();
                groupSizeController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              },
              child: const Text('Send'),
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

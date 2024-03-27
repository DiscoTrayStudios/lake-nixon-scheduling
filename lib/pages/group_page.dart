import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/objects/screen_arguments.dart';
import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:lake_nixon_scheduling/widgets/group_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:lake_nixon_scheduling/objects/group.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key, required this.title});

  final String title;

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool admin = false;
  var activityController = TextEditingController();
  var ageLimitController = TextEditingController();
  var groupSizeController = TextEditingController();
  var descriptionController = TextEditingController();

  Future<void> userPush(Group group) async {
    await Navigator.pushNamed(context, '/calendarPage',
        arguments:
            CalendarArguments(title: group.name, group: group, isUser: true));
  }

  Future<void> adminPush(Group group) async {
    await Navigator.pushNamed(context, '/calendarPage',
        arguments:
            CalendarArguments(title: group.name, group: group, isUser: false));
  }

  void _checkAuth(Group group) async {
    User? user = Provider.of<AppState>(context, listen: false).auth.currentUser;

    final DocumentSnapshot snap =
        await Provider.of<AppState>(context, listen: false)
            .firestore
            .collection("users")
            .doc(user?.uid)
            .get();

    try {
      admin = snap['admin'];
      if (admin) {
        adminPush(group);
      } else {
        userPush(group);
      }
    } on StateError catch (_) {
      userPush(group);
    }
  }

  Future<void> _handleCalendar(Group group) async {
    debugPrint("Chat");

    _checkAuth(group);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of Groups",
            style: Theme.of(context).textTheme.appBarTitle),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: ListView(
            // padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: Provider.of<AppState>(context).groups.map((group) {
              return GroupItem(
                group: group,
                onTap: _handleCalendar,
              );
            }).toList(),
          )),
    );
  }
}

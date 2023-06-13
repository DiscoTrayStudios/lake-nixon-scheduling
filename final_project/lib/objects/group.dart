import 'package:flutter/material.dart';

import 'package:final_project/objects/globals.dart';

class Group {
  const Group({required this.name, required this.color, required this.age});

  final String name;
  final Color color;
  final int age;

  //bool selected = false;

  String abbrev() {
    return name.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(Group group);
//typedef ToDoListRemovedCallback = Function(Car car);

class GroupItem extends StatelessWidget {
  GroupItem(
      { //required this.completed,
      required this.onListChanged,
      required this.group})
      : super(key: ObjectKey(group));

  //final bool completed;
  final ToDoListChangedCallback onListChanged;
  final Group group;

  // _detailCounter(BuildContext)

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: ListTile(
        //group.color
        tileColor: nixonyellow,
        iconColor: nixonblue,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        onTap: () {
          onListChanged(group);
        },
        leading: CircleAvatar(
          backgroundColor: nixonblue,
          child: Text(group.abbrev(),
              style: TextStyle(
                  color: nixonbrown, fontFamily: 'Fruit', fontSize: 30)),
        ),
        title: Text(
          group.name,
          style: TextStyle(color: nixonbrown),
        ),
      ),
    );
  }
}

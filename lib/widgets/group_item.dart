import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/theme.dart';
import 'package:flutter/material.dart';

typedef TileTappedCallback = Function(Group group);

class GroupItem extends StatelessWidget {
  GroupItem(
      { //required this.completed,
      required this.onTap,
      required this.group})
      : super(key: ObjectKey(group));

  //final bool completed;
  final TileTappedCallback onTap;
  final Group group;

  // _detailCounter(BuildContext)

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      child: ListTile(
        //group.color
        tileColor: group.color,
        iconColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Theme.of(context).colorScheme.outline, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        onTap: () {
          onTap(group);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(group.abbrev(),
              style: Theme.of(context).textTheme.pageHeader),
        ),
        title: Text(
          group.name,
          style: TextStyle(
              color: group.color.computeLuminance() < 0.5
                  ? Colors.white
                  : Colors.black,
              fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize),
        ),
      ),
    );
  }
}

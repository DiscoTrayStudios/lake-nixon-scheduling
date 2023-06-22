import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/activity.dart';
import 'package:final_project/objects/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActivitySelector extends StatefulWidget {
  const ActivitySelector(this.selectedDate, this.onChanged, this.dropdownValue,
      {super.key});

  final DateTime selectedDate;

  final OnChangedCallBack onChanged;

  final String dropdownValue;

  @override
  State<ActivitySelector> createState() => _ActivitySelectorState();
}

typedef OnChangedCallBack = Function(String?);

class _ActivitySelectorState extends State<ActivitySelector> {
  List<DropdownMenuItem<String>> createDropdown(
      List<Activity> items, DateTime startTime) {
    List<DropdownMenuItem<String>> newItems = [];
    for (Activity event in items) {
      var currentAmount = Provider.of<AppState>(context)
          .getCurrentAmount(event.name, startTime);
      newItems.add(DropdownMenuItem(
          value: event.name, child: Text("${event.name}  $currentAmount")));
    }
    return newItems;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      leading: Text("Activities",
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
              color: Theme.of(context).colorScheme.secondary)),
      //This is the groups dropdown button
      //A current issue is that for the group filtering to work we have to click within this box to
      //get the filtering to work.
      title: Align(
        alignment: Alignment.centerRight,
        child: DropdownButton(
          iconEnabledColor: Theme.of(context).colorScheme.tertiary,
          style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontStyle: Theme.of(context).textTheme.titleMedium!.fontStyle,
              fontFamily: "Fruit"),
          value: widget.dropdownValue,
          items: createDropdown(
              Provider.of<AppState>(context).activities, widget.selectedDate),
          onChanged: (String? newValue) => widget.onChanged(newValue),
        ),
      ),
    );
  }
}

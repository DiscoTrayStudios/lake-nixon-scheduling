import 'package:final_project/objects/group.dart';
import 'package:flutter/material.dart';

class EventSelector extends StatefulWidget {
  const EventSelector(this.firebaseEvents, this.onChanged, this.dropdownValue,
      {super.key});

  final List<DropdownMenuItem<String>> firebaseEvents;

  final OnChangedCallBack onChanged;

  final String dropdownValue;

  @override
  State<EventSelector> createState() => _EventSelectorState();
}

typedef OnChangedCallBack = Function(String?);

class _EventSelectorState extends State<EventSelector> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      leading: Text("Events",
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
          items: widget.firebaseEvents,
          onChanged: (String? newValue) => widget.onChanged(newValue),
        ),
      ),
    );
  }
}

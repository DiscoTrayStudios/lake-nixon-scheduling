import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/event.dart';
import 'package:final_project/objects/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventSelector extends StatefulWidget {
  const EventSelector(this.selectedDate, this.onChanged, this.dropdownValue,
      {super.key});

  final DateTime selectedDate;

  final OnChangedCallBack onChanged;

  final String dropdownValue;

  @override
  State<EventSelector> createState() => _EventSelectorState();
}

typedef OnChangedCallBack = Function(String?);

class _EventSelectorState extends State<EventSelector> {
  List<DropdownMenuItem<String>> createDropdown(
      List<Event> items, DateTime startTime) {
    List<DropdownMenuItem<String>> newItems = [];
    for (Event event in items) {
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
          items: createDropdown(
              Provider.of<AppState>(context).events, widget.selectedDate),
          onChanged: (String? newValue) => widget.onChanged(newValue),
        ),
      ),
    );
  }
}

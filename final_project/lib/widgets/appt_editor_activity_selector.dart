import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/activity.dart';
import 'package:final_project/objects/group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Could be stateless

/// A dropdown to select the activity for an appointment.
///
/// Displays the activity name and the ratio of groups in the activty at the
/// selected time to total allowed.
class ActivitySelector extends StatefulWidget {
  /// A dropdown to select the activity for an appointment.
  ///
  /// Displays the activity name and the ratio of groups in the activty at the
  /// selected time to total allowed. Takes [this.selectedDate], the date and time
  /// of the appointment, [this.onChanged], a callback for when the dropdown is
  /// changed, and [this.dropdownValue], the default value for the dropdown.
  const ActivitySelector(this.selectedDate, this.onChanged, this.dropdownValue,
      {super.key});

  /// The date and time the appointment is scheduled for.
  final DateTime selectedDate;

  /// The function callback for changing the dropdown.
  final OnChangedCallBack onChanged;

  /// The default value of the dropdown
  final String dropdownValue;

  @override
  State<ActivitySelector> createState() => _ActivitySelectorState();
}

typedef OnChangedCallBack = Function(String?);

class _ActivitySelectorState extends State<ActivitySelector> {
  /// Creates the [DropdownMenuItem]s with the ratio of current groups in the
  /// to total capacity.
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

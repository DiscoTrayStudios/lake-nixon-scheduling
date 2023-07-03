import 'package:final_project/objects/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A widget to select a time from a range of times.
class TimeSelectorDropdown extends StatefulWidget {
  /// A widget to select a time from a range of times.
  ///
  /// [startTime] and [endTime] are the start and end of the range. [onTimePicked]
  /// is called when a time is selected. [initialTime] is the default time selection.
  const TimeSelectorDropdown(
      {required this.startTime,
      required this.endTime,
      required this.onTimePicked,
      required this.initialTime,
      super.key});

  /// The start of the range of options.
  final TimeOfDay startTime;

  /// The end of the range of options.
  final TimeOfDay endTime;

  /// The default setting for the dropdown.
  final TimeOfDay initialTime;

  /// Called when a time is picked.
  final OnTimePickedCallback onTimePicked;

  @override
  State<TimeSelectorDropdown> createState() => _TimeSelectorDropdownState();
}

typedef OnTimePickedCallback = Function(TimeOfDay);

class _TimeSelectorDropdownState extends State<TimeSelectorDropdown> {
  final List<DropdownMenuItem<TimeOfDay>> _dropdownItems = [];

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _dropdownItems.clear();
    for (TimeOfDay time = widget.startTime;
        time.hour <= widget.endTime.hour;
        time = time.replacing(hour: time.hour + 1)) {
      _dropdownItems.add(DropdownMenuItem(
          value: time,
          child: Text(
              DateFormat('hh:mm a').format(DateTime(1, 1, 1, time.hour)),
              style: Theme.of(context).textTheme.bodyMedium)));
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        style: Theme.of(context).textTheme.bodyMedium,
        value: widget.initialTime,
        items: _dropdownItems,
        icon: Icon(Icons.access_time,
            color: Theme.of(context).colorScheme.nixonBrown),
        onChanged: (value) {
          widget.onTimePicked(value!);
        },
      ),
    );
  }
}

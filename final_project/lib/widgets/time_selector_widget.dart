import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSelectorDropdown extends StatefulWidget {
  const TimeSelectorDropdown(
      {required this.startTime,
      required this.endTime,
      required this.onTimePicked,
      required this.initialTime,
      super.key});

  final TimeOfDay startTime;

  final TimeOfDay endTime;

  final TimeOfDay initialTime;

  final OnTimePickedCallback onTimePicked;

  @override
  State<TimeSelectorDropdown> createState() => _TimeSelectorDropdownState();
}

typedef OnTimePickedCallback = Function(TimeOfDay);

class _TimeSelectorDropdownState extends State<TimeSelectorDropdown> {
  final List<DropdownMenuItem<TimeOfDay>> _dropdownItems = [];

  @override
  initState() {
    for (TimeOfDay time = widget.startTime;
        time.hour <= widget.endTime.hour;
        time = time.replacing(hour: time.hour + 1)) {
      _dropdownItems.add(DropdownMenuItem(
          value: time,
          child: Text(
              DateFormat('hh:mm a').format(DateTime(1, 1, 1, time.hour)))));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: widget.initialTime,
        items: _dropdownItems,
        icon: const Icon(Icons.access_time),
        onChanged: (value) {
          widget.onTimePicked(value!);
        },
      ),
    );
  }
}

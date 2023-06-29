import 'package:final_project/widgets/time_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Should be stateless.

/// A widget to select the date and start and end time for an appointment.
class TimeSelector extends StatefulWidget {
  /// A widget to select the date and start and end time for an appointment.
  ///
  /// Takes a default [this.startDate] and [this.endDate], as well as callbacks
  /// for when the date, and start and end times are picked.
  ///
  /// [this.rangeStartTime] and [this.rangeEndTime] are should be the start and
  /// end of the interval displayed in the time selector dropdowns.
  const TimeSelector(
      // this.isAllDay,
      // this.onAllDay,
      this.startDate,
      this.endDate,
      this.onStartDatePicked,
      this.onStartTimePicked,
      this.onEndTimePicked,
      this.rangeStartTime,
      this.rangeEndTime,
      {super.key});

  // final bool isAllDay;

  // final OnAllDaySwitcCallback onAllDay;

  /// The start date and time for the appointment.
  final DateTime startDate;

  /// The end date and time for the appointment.
  final DateTime endDate;

  /// A function callback called when a the date selector button is clicked.
  final OnTapCallback onStartDatePicked;

  /// A function callback called when a startTime is picked.
  final OnTimePickedCallback onStartTimePicked;

  /// A function callback called when a endTime is picked.
  final OnTimePickedCallback onEndTimePicked;

  /// The start of the range of time options.
  final TimeOfDay rangeStartTime;

  /// The end of the range of time options.
  final TimeOfDay rangeEndTime;

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

// typedef OnAllDaySwitcCallback = void Function(bool);
typedef OnTapCallback = void Function();
typedef OnTimePickedCallback = void Function(TimeOfDay);

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(children: <Widget>[
              Expanded(
                flex: 7,
                child: GestureDetector(
                  onTap: () async => widget.onStartDatePicked(),
                  child: Text(
                      DateFormat('EEE, MMM dd yyyy').format(widget.startDate),
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: TimeSelectorDropdown(
                      startTime: widget.rangeStartTime,
                      endTime: TimeOfDay(
                          hour: widget.rangeEndTime.hour - 1, minute: 0),
                      initialTime:
                          TimeOfDay(hour: widget.startDate.hour, minute: 0),
                      onTimePicked: widget.onStartTimePicked)),
            ])),
        ListTile(
            contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
            leading: const Text(''),
            title: Row(children: <Widget>[
              const Spacer(flex: 7),
              Expanded(
                  flex: 3,
                  child: TimeSelectorDropdown(
                      startTime: TimeOfDay(
                          hour: widget.rangeStartTime.hour + 1, minute: 0),
                      endTime: widget.rangeEndTime,
                      initialTime:
                          TimeOfDay(hour: widget.endDate.hour, minute: 0),
                      onTimePicked: widget.onEndTimePicked)),
            ])),
      ],
    );
  }
}

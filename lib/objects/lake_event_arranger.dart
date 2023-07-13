import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

class LakeEventArranger<T extends Object?> extends EventArranger<T> {
  /// This class will provide method that will arrange
  /// all the events side by side.
  const LakeEventArranger();

  @override
  List<OrganizedCalendarEventData<T>> arrange({
    required List<CalendarEventData<T>> events,
    required double height,
    required double width,
    required double heightPerMinute,
  }) {
    final arrangedEvents = <OrganizedCalendarEventData<T>>[];
    final groups = <String>[];
    final lakeEvents = <_LakeEventData<T>>[];

    for (final CalendarEventData<T> event in events) {
      if (!groups.contains(event.color.toString())) {
        groups.add(event.color.toString());
      }
      lakeEvents.add(_LakeEventData(
          column: groups.indexOf(event.color.toString()) + 1, event: event));
    }

    final slotWidth = width / groups.length;

    for (final sideEvent in lakeEvents) {
      if (sideEvent.event.startTime == null ||
          sideEvent.event.endTime == null) {
        assert(() {
          try {
            debugPrint("Start time or end time of an event can not be null. "
                "This ${sideEvent.event} will be ignored.");
          } catch (e) {
            // Suppress exceptions.
          }

          return true;
        }(), "Can not add event in the list.");

        continue;
      }

      final startTime = sideEvent.event.startTime!;
      final endTime = sideEvent.event.endTime!;
      final bottom = height -
          (endTime.getTotalMinutes == 0 ? 1440 : endTime.getTotalMinutes) *
              heightPerMinute;
      arrangedEvents.add(OrganizedCalendarEventData<T>(
        left: slotWidth * (sideEvent.column - 1),
        right: slotWidth * (groups.length - sideEvent.column),
        top: startTime.getTotalMinutes * heightPerMinute,
        bottom: bottom,
        startDuration: startTime,
        endDuration: endTime,
        events: [sideEvent.event],
      ));
    }

    return arrangedEvents;
  }
}

class _LakeEventData<T> {
  final int column;
  final CalendarEventData<T> event;

  const _LakeEventData({
    required this.column,
    required this.event,
  });
}

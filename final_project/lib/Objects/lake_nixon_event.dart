import 'dart:ui';

import 'package:final_project/Objects/group.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class LakeNixonEvent extends Appointment {
  LakeNixonEvent(
      {required super.startTime,
      required super.endTime,
      int? age,
      int? groupSize,
      String? notes,
      Color? color,
      String? startTimeZone,
      String? endTimeZone,
      required bool isAllDay,
      required String subject,
      List<Group>? groups,
      List<DateTime>? recurrenceExceptionDates,
      List<Object>? resourceIds,
      Object? id,
      Object? recurrenceId,
      String? recurrenceRule});
}

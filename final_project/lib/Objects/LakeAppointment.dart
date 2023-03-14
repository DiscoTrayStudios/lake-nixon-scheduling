import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:final_project/Objects/Group.dart';

// this is basically LakeNixonEvent but with only the stuff in Firebase
class LakeAppointment extends Appointment {
  LakeAppointment(
      {required super.startTime,
      required super.endTime,
      Color? color,
      Group? group,
      String? notes,
      int? startHour, //do we need this?
      String? subject});
}

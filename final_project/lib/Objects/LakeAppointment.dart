import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:final_project/Objects/Group.dart';

// this is basically LakeNixonEvent but with only the stuff in Firebase
class LakeAppointment {
  DateTime? startTime;
  DateTime? endTime;
  Color? color;
  Group? group;
  String? notes;
  int? startHour; //do we need this?
  String? subject;

  LakeAppointment(
      {required startTime,
      required endTime,
      Color? color,
      String? group,
      String? notes,
      String? startHour, //do we need this?
      String? subject});
}

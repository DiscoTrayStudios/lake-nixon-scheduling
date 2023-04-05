import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:final_project/Objects/Group.dart';

// this is basically LakeNixonEvent but with only the stuff in Firebase
class LakeAppointment {
  LakeAppointment(
      {required this.startTime,
      required this.endTime,
      Color? this.color,
      String? this.group,
      String? this.notes,
      String? this.startHour, //do we need this?
      String? this.subject});

  DateTime? startTime;
  DateTime? endTime;
  Color? color;
  String? group;
  String? notes;
  String? startHour; //do we need this?
  String? subject;

  @override
  String toString() {
    return "Start time : $startTime \n End time : $endTime \n Color : $color \n group : $group \n Start hour : $startHour \n Subject : $subject \n";
  }
}

import 'dart:ui';


// this is basically LakeNixonEvent but with only the stuff in Firebase
class LakeAppointment {
  LakeAppointment(
      {required this.startTime,
      required this.endTime,
      this.color,
      this.group,
      this.notes,
      this.startHour, //do we need this?
      this.subject});

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

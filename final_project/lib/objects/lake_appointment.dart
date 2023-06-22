import 'dart:ui';

// this is basically LakeNixonActivity but with only the stuff in Firebase
class LakeAppointment {
  LakeAppointment(
      {required this.startTime,
      required this.endTime,
      this.color,
      this.group,
      this.notes,
      this.subject});

  DateTime? startTime;
  DateTime? endTime;
  Color? color;
  String? group;
  String? notes;
  String? subject;

  @override
  String toString() {
    return "Start time : $startTime \n End time : $endTime \n Color : $color \n group : $group \n Subject : $subject \n";
  }
}

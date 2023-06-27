import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/lake_appointment.dart';

/// A class to store arguments for the appointment editor screen.
class AppointmentEditorArguments {
  final LakeAppointment? appointment;
  final DateTime selectedDate;

  AppointmentEditorArguments({this.appointment, required this.selectedDate});
}

/// A class to store arguments for the appointment selector screen.
class AppointmentSelectorArguments {
  final DateTime selectedDate;
  final List<Group>? selectedGroups;
  final List<String>? selectedActivities;

  AppointmentSelectorArguments(
      {required this.selectedDate,
      this.selectedGroups,
      this.selectedActivities});
}

/// A class to store arguments for the calendar screen.
class CalendarArguments {
  final String title;
  final Group group;
  final bool isUser;
  final bool master;

  CalendarArguments(
      {required this.title,
      required this.group,
      required this.isUser,
      required this.master});
}

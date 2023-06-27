import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/objects/screen_arguments.dart';
import 'package:flutter/material.dart';

/// A widget used to display an appointment in the appointment selector screen.
class ApptSelectorItem extends StatelessWidget {
  /// A widget used to display an appointment in the appointment selector screen.
  ///
  /// Tapping on this will send the user to the appointment editor to edit
  /// [this.appointment]
  const ApptSelectorItem(this.appointment, this.selectedDate, {super.key});

  /// The appointment that the widget displays.
  final LakeAppointment appointment;

  /// The day that the user selected on the calendar.
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appointment.subject!),
      subtitle: Text(appointment.group!),
      tileColor: appointment.color!,
      onTap: () {
        Navigator.pushNamed(context, '/appointmentEditorPage',
            arguments: AppointmentEditorArguments(
                appointment: appointment, selectedDate: selectedDate));
      },
    );
  }
}

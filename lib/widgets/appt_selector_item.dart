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
    return Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Color.lerp(appointment.color!, Colors.black, 0.3)!,
              width: 3),
          borderRadius: BorderRadius.circular(40),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Color.lerp(appointment.color!, Colors.black, 0.3)!,
                width: 3),
            borderRadius: BorderRadius.circular(40),
          ),
          title: Text(appointment.subject!,
              style: Theme.of(context).textTheme.titleLarge),
          subtitle: Text(appointment.group!,
              style: Theme.of(context).textTheme.titleMedium),
          tileColor: appointment.color!,
          onTap: () {
            Navigator.pushNamed(context, '/appointmentEditorPage',
                arguments: AppointmentEditorArguments(
                    appointment: appointment, selectedDate: selectedDate));
          },
        ));
  }
}

import 'package:final_project/objects/lake_appointment.dart';
import 'package:flutter/material.dart';

class ApptSelectorItem extends StatelessWidget {
  const ApptSelectorItem(this.appointment, {super.key});

  final LakeAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(appointment.subject!),
      subtitle: Text(appointment.group!),
      tileColor: appointment.color!,
      onTap: () {},
    );
  }
}

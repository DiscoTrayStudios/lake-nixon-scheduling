import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/widgets/appt_selector_item.dart';
import 'package:flutter/material.dart';

class AppointmentSelector extends StatelessWidget {
  const AppointmentSelector(this.appointments, {super.key});

  final List<LakeAppointment> appointments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Select Appointment')),
        body: ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (BuildContext context, int index) {
            return ApptSelectorItem(appointments[index]);
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {}, child: const Icon(Icons.add)));
  }
}

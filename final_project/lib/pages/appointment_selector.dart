import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/appointment_data_source.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/pages/appointment_editor.dart';
import 'package:final_project/widgets/appt_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentSelector extends StatefulWidget {
  const AppointmentSelector(this.dataSource, this.selectedDate, {super.key});

  final AppointmentDataSource dataSource;

  final DateTime selectedDate;

  @override
  State<AppointmentSelector> createState() => _AppointmentSelectorState();
}

class _AppointmentSelectorState extends State<AppointmentSelector> {
  _AppointmentSelectorState();

  late List<LakeAppointment> _appointments;

  @override
  void initState() {
    super.initState();
  }

  void appointmentUpdateCallback() {
    setState(() {
      _appointments = Provider.of<AppState>(context, listen: false)
          .getApptsAtTime(widget.selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    _appointments =
        Provider.of<AppState>(context).getApptsAtTime(widget.selectedDate);

    return Scaffold(
        appBar: AppBar(title: const Text('Select Appointment')),
        body: ListView.builder(
          itemCount: _appointments.length,
          itemBuilder: (BuildContext context, int index) {
            return ApptSelectorItem(_appointments[index], widget.dataSource,
                widget.selectedDate, appointmentUpdateCallback);
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentEditor(
                          widget.dataSource,
                          null,
                          widget.selectedDate,
                          appointmentUpdateCallback)));
            },
            child: const Icon(Icons.add)));
  }
}

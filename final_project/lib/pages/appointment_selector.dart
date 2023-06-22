import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/appointment_data_source.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/pages/appointment_editor.dart';
import 'package:final_project/widgets/appt_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentSelector extends StatefulWidget {
  const AppointmentSelector(this.dataSource, this.selectedDate,
      {this.selectedGroups, this.selectedEvents, super.key});

  final AppointmentDataSource dataSource;

  final DateTime selectedDate;

  final List<Group>? selectedGroups;

  final List<String>? selectedEvents;

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

  @override
  Widget build(BuildContext context) {
    _appointments =
        Provider.of<AppState>(context).getApptsAtTime(widget.selectedDate);

    if (widget.selectedGroups != null || widget.selectedEvents != null) {
      Set<LakeAppointment> appsToRemove = {};
      for (LakeAppointment app in _appointments) {
        if (widget.selectedGroups != null) {
          bool remove = true;
          for (Group group in widget.selectedGroups!) {
            if (app.group! == group.name) {
              remove = false;
              break;
            }
          }
          if (remove) {
            appsToRemove.add(app);
          }
        }
        if (widget.selectedEvents != null) {
          bool remove = true;
          for (String event in widget.selectedEvents!) {
            if (app.subject! == event) {
              remove = false;
              break;
            }
          }
          if (remove) {
            appsToRemove.add(app);
          }
        }
      }
      for (LakeAppointment app in appsToRemove) {
        _appointments.remove(app);
      }
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Select Appointment')),
        body: ListView.builder(
          itemCount: _appointments.length,
          itemBuilder: (BuildContext context, int index) {
            return ApptSelectorItem(
                _appointments[index], widget.dataSource, widget.selectedDate);
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppointmentEditor(
                          widget.dataSource, null, widget.selectedDate)));
            },
            child: const Icon(Icons.add)));
  }
}

import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/objects/group.dart';
import 'package:lake_nixon_scheduling/objects/lake_appointment.dart';
import 'package:lake_nixon_scheduling/objects/screen_arguments.dart';
import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:lake_nixon_scheduling/widgets/appt_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A page to select appointment from a list or create new appointments.
///
/// Used when a user clicks on a timeslot with appointments on the calendar.
/// Displays all the appointments in that timeslot and includes a button to
/// create a new appointment. Follows any filters selected on the calendar page.
class AppointmentSelector extends StatefulWidget {
  /// A page to select appointment from a list or create new appointments.
  ///
  /// Used when a user clicks on a timeslot with appointments on the calendar.
  /// Displays all the appointments in that timeslot and includes a button to
  /// create a new appointment. Follows any filters selected on the calendar page.
  const AppointmentSelector(this.selectedDate,
      {this.selectedGroups, this.selectedActivities, super.key});

  /// The date and time selected on the calendar.
  final DateTime selectedDate;

  /// The groups that the calendar filter was set to.
  final List<Group>? selectedGroups;

  /// The activities that the calendar filter was set to.
  final List<String>? selectedActivities;

  @override
  State<AppointmentSelector> createState() => _AppointmentSelectorState();
}

class _AppointmentSelectorState extends State<AppointmentSelector> {
  _AppointmentSelectorState();

  ///The appointments listed on the screen.
  late List<LakeAppointment> _appointments;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _appointments =
        Provider.of<AppState>(context).getApptsAtTime(widget.selectedDate);

    if (widget.selectedGroups != null || widget.selectedActivities != null) {
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
        if (widget.selectedActivities != null) {
          bool remove = true;
          for (String activity in widget.selectedActivities!) {
            if (app.subject! == activity) {
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
        appBar: AppBar(
            title: Text('Select Appointment',
                style: Theme.of(context).textTheme.appBarTitle)),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: _appointments.length,
            itemBuilder: (BuildContext context, int index) {
              return ApptSelectorItem(
                  _appointments[index], widget.selectedDate);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              final args =
                  AppointmentEditorArguments(selectedDate: widget.selectedDate);
              Navigator.pushNamed(context, '/appointmentEditorPage',
                  arguments: args);
            },
            backgroundColor: Theme.of(context).colorScheme.nixonGreen,
            child: Icon(Icons.add,
                color: Theme.of(context).colorScheme.onPrimary)));
  }
}

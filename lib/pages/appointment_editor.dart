import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/widgets/appt_editor_activity_selector.dart';
import 'package:final_project/widgets/appt_editor_group_selector.dart';
import 'package:final_project/widgets/appt_editor_time_selector.dart';
import 'package:final_project/widgets/confirm_popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/theme.dart';

Color theme = const Color(0xffffffff);

/// A page that allows the user to create, delete, and edit appointments.
///
/// Allows the user to either batch create new appointments with multiple groups,
/// or edit the an appointment if one was selected.
class AppointmentEditor extends StatefulWidget {
  /// Creates a page to create, edit, and delete appointments.
  ///
  /// If [this.selectedAppointment] is null, then the user can batch create
  /// appointments for multiple groups. Otherwise, the user can edit or delete
  /// the selected appointment.
  ///
  /// [this.selectedDate] is the date selected on the calendar.
  const AppointmentEditor(this.selectedAppointment, this.selectedDate,
      {super.key});

  /// The appointment selected from the calendar, if present.
  final LakeAppointment? selectedAppointment;

  /// The start of the timeslot selected on the calendar.
  final DateTime selectedDate;

  @override
  State<AppointmentEditor> createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  /// The selected start date and time of the appointment.
  late DateTime _startDate;

  /// The selected start time of the appointment.
  late TimeOfDay _startTime;

  /// The selected end date and time of the appointment.
  late DateTime _endDate;

  /// The selected end time of the appointment.
  late TimeOfDay _endTime;

  String? _notes;

  /// The selected value for the activity dropdown.
  ///
  /// Defaults to "Lunch" if there is no value selected.
  String dropdownValue = "Lunch";

  /// The activity selected for the appointment.
  late String _subject;

  /// The orignial start date and time of the appointment.
  ///
  /// Only used if there was an appointment selected from the calendar.
  late DateTime _originalStartDate;

  /// The original subject of the appointemnt.
  ///
  /// Only used if there was an appointment selected from the calendar.
  late String _originalSubject;

  /// The original group of the appointment.
  ///
  /// Only used if there was an appointment selected from the calendar.
  late String _originalGroup;

  /// The start of the range in which times can be selected.
  final TimeOfDay _timeSelectorStartTime = const TimeOfDay(hour: 7, minute: 0);

  /// The end of the range in which times can be selected.
  final TimeOfDay _timeSelectorEndTime = const TimeOfDay(hour: 18, minute: 0);

  /// Sets the [dropdownValue] and [_subject] to the new value picked by the
  /// activity selector.
  ///
  /// A callback function used by the [ActivitySelector] to change the editor state.
  void onActivitySelectorChanged(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
      _subject = newValue;
    });
  }

  /// Sets the [_selectedGroups] to the new values picked by the group selector.
  ///
  /// A callback function used by the [GroupSelector] to change the editor state.
  void onGroupSelectorConfirmed(List<Group> results) {
    setState(() {
      _selectedGroups = results;
      //assignments[widget.group] = _selectedGroups;
    });
  }

  /// Creates a datepicker, and sets the [_startDate] to the result of the picker.
  ///
  /// Also adjusts the [_endDate] so that they are the same.
  ///
  /// A callback funtion called by the [TimeSelector] to select the date.
  void onStartDatePicked() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _startDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        selectableDayPredicate: (DateTime val) =>
            val.weekday != DateTime.sunday && val.weekday != DateTime.saturday,
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context),
            child: child!,
          );
        });

    if (date != null && date != _startDate) {
      setState(() {
        _startDate = DateTime(date.year, date.month, date.day, _startTime.hour,
            _startTime.minute);
        _endDate = DateTime(
            date.year, date.month, date.day, _endTime.hour, _endTime.minute);
      });
    }
  }

  /// Sets the [_startTime] to the result of the start time dropdown.
  ///
  /// Also adjusts the [_endTime] to maintain the interval of time between them.
  /// Has checks to prevent the [_endTime] from being set outside of the
  /// [_timeSelectorEndTime]
  ///
  /// A callback function used by the [TimeSelector] to change the editor state.
  void onStartTimePicked(TimeOfDay time) async {
    if (time != _startTime) {
      setState(() {
        _startTime = time;
        final Duration difference = _endDate.difference(_startDate);
        _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day,
            _startTime.hour, _startTime.minute);
        _endDate = _startDate.add(difference);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);

        if (_endTime.hour > _timeSelectorEndTime.hour) {
          _endTime = _timeSelectorEndTime;
        }
        _startDate = DateTime(
            _startDate.year, _startDate.month, _startDate.day, _startTime.hour);
        _endDate = DateTime(
            _endDate.year, _endDate.month, _endDate.day, _endTime.hour);
      });
    }
  }

  /// Sets the [_endTime] to the time picked by the end time dropdown.
  ///
  /// If the new [_endTime] is at the same time as or before the old [_startTime],
  /// the [_startTime] is also adjusted to maintain the interval. Checks are in
  /// place to prevent the [_startTime] from being before [_timeSelectorStartTime].
  ///
  /// A callback function used by the [TimeSelector] to change the editor state.
  void onEndTimePicked(TimeOfDay time) async {
    if (time != _endTime) {
      setState(() {
        _endTime = time;
        final Duration difference = _endDate.difference(_startDate);
        _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day,
            _endTime.hour, _endTime.minute);
        if (!_endDate.isAfter(_startDate)) {
          _startDate = _endDate.subtract(difference);
          _startTime =
              TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        }
        if (_startTime.hour < _timeSelectorStartTime.hour) {
          _startTime = _timeSelectorStartTime;
        }
        _startDate = DateTime(
            _startDate.year, _startDate.month, _startDate.day, _startTime.hour);
        _endDate = DateTime(
            _endDate.year, _endDate.month, _endDate.day, _endTime.hour);
      });
    }
  }

  /// The groups selected by the dropdown.
  List<Group> _selectedGroups = [];

  /// Initializes the editor state.
  ///
  /// If there is a selected appointment, it sets the default settings to the
  /// appointment settings, otherwise defaults to no selected groups and the
  /// time selected from the calendar.
  @override
  void initState() {
    _updateAppointmentProperties();
    _selectedGroups;
    //getActivities();
    if (widget.selectedAppointment != null) {
      dropdownValue = widget.selectedAppointment!.subject!;
    } else {}
    _subject = dropdownValue;
    super.initState();
  }

  /// Updates the editor fields with the selected appointment if there was one
  /// selected.
  ///
  /// Only called on initialization.
  void _updateAppointmentProperties() {
    if (widget.selectedAppointment != null) {
      _startDate = widget.selectedAppointment!.startTime!;
      _endDate = widget.selectedAppointment!.endTime!;

      _subject = widget.selectedAppointment!.subject!;
      _notes = widget.selectedAppointment!.notes;

      _originalStartDate = widget.selectedAppointment!.startTime!;
      _originalSubject = widget.selectedAppointment!.subject!;
      _originalGroup = widget.selectedAppointment!.group!;

      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    } else {
      _subject = '';
      _notes = '';

      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));

      _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
      _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      _selectedGroups = appState.filterGroupsByAge(
          appState.lookupActivityByName(_subject).ageMin,
          appState.filterGroupsByTime(_startDate, _endDate, _selectedGroups));
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.nixonGreen,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                if (widget.selectedAppointment != null) {
                  if (_subject != widget.selectedAppointment!.subject ||
                      _startDate != widget.selectedAppointment!.startTime ||
                      _endDate != widget.selectedAppointment!.endTime) {
                    confirmNavPopup(
                        context, 'Close editor?', 'All changes will be lost.',
                        (context) async {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  } else {
                    Navigator.pop(context);
                  }
                } else {
                  confirmNavPopup(
                      context, 'Close editor?', 'All changes will be lost.',
                      (context) async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
              },
            ),
            actions: <Widget>[
              IconButton(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  icon: Icon(
                    Icons.done,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    //updateDropdown();
                    if (widget.selectedAppointment != null) {
                      if (appState.checkActivity(
                              _subject,
                              _startDate,
                              _endDate,
                              1,
                              widget.selectedAppointment!.startTime!,
                              widget.selectedAppointment!.endTime!) &&
                          appState.checkGroupTime(
                              group: widget.selectedAppointment!.group!,
                              startTime: _startDate,
                              endTime: _endDate,
                              originalStartTime:
                                  widget.selectedAppointment!.startTime,
                              originalEndTime:
                                  widget.selectedAppointment!.endTime)) {
                        Map<String, dynamic> data = {
                          "start_time": _startDate,
                          "end_time": _endDate,
                          "color":
                              widget.selectedAppointment!.color!.toString(),
                          "notes": _notes,
                          "subject": _subject,
                          "group": widget.selectedAppointment!.group!,
                        };

                        appState.editAppt(
                            startTime: _originalStartDate,
                            subject: _originalSubject,
                            group: _originalGroup,
                            data: data);
                        Navigator.popUntil(
                            context, ModalRoute.withName('/calendarPage'));
                      } else {
                        Fluttertoast.showToast(
                            msg: "CANT ADD EVENT DUE TO RESTRICTIONS",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      bool groupsOccupied = true;

                      Map<String, Map<String, dynamic>> groupToApp = {};
                      for (Group g in _selectedGroups) {
                        //Turning the already created appointment into something we can put into firebase
                        Map<String, dynamic> appMap = {
                          "start_time": _startDate,
                          "end_time": _endDate,
                          "color": g.color.toString(),
                          "notes": _notes,
                          "subject": _subject,
                          "group": g.name,
                        };
                        //associating a group with a specific appointment
                        groupToApp[g.name] = appMap;

                        if (!appState.checkGroupTime(
                            group: g.name,
                            startTime: _startDate,
                            endTime: _endDate)) {
                          groupsOccupied = false;
                        }
                      }
                      //appState.addAppointments(groupToApp);

                      int groupAmount = _selectedGroups.length;
                      //Now we check if the amounts of groups trying to be added exceeds the limits set in pace
                      //If it does, it takes us to the else statement
                      if (appState.checkActivity(
                              _subject, _startDate, _endDate, groupAmount) &&
                          groupsOccupied) {
                        //If it doesnt we come in here and we add the appoinments to the app state
                        appState.addAppointments(
                            groupToApp, appState.firestore);

                        Navigator.popUntil(
                            context, ModalRoute.withName('/calendarPage'));
                      } else {
                        Fluttertoast.showToast(
                            msg: "CANT ADD EVENT DUE TO RESTRICTIONS",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    }
                  })
            ],
          ),
          body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ActivitySelector(widget.selectedDate,
                      onActivitySelectorChanged, dropdownValue),
                  if (widget.selectedAppointment == null)
                    GroupSelector(
                        appState.filterGroupsByAge(
                            appState.lookupActivityByName(_subject).ageMin,
                            appState.filterGroupsByTime(
                                _startDate, _endDate, appState.groups)),
                        _selectedGroups,
                        onGroupSelectorConfirmed)
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 10),
                      child: Center(
                          child: Text(
                        widget.selectedAppointment!.group!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                    ),
                  Divider(
                      height: 1.0,
                      thickness: 3,
                      color: Color.lerp(
                          Theme.of(context).colorScheme.nixonBrown,
                          Colors.white,
                          0.5)),
                  TimeSelector(
                      _startDate,
                      _endDate,
                      onStartDatePicked,
                      onStartTimePicked,
                      onEndTimePicked,
                      _timeSelectorStartTime,
                      _timeSelectorEndTime),
                  Divider(
                      height: 1.0,
                      thickness: 3,
                      color: Color.lerp(
                          Theme.of(context).colorScheme.nixonBrown,
                          Colors.white,
                          0.5)),
                  ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    leading: const Icon(
                      Icons.subject,
                    ),
                    title: Text(
                      appState.lookupActivityByName(_subject).desc,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              )),
          floatingActionButton: widget.selectedAppointment == null
              ? null
              : FloatingActionButton(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete_forever, color: Colors.white),
                  onPressed: () {
                    confirmNavPopup(context, 'Delete Appointment?',
                        "Deleted appointments can't be recovered.",
                        (context) async {
                      appState.deleteAppt(
                          startTime: _originalStartDate,
                          subject: _originalSubject,
                          group: _originalGroup);

                      Navigator.popUntil(
                          context, ModalRoute.withName('/calendarPage'));
                    });
                  }));
    });
  }
}

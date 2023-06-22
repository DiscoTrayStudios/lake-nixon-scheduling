import 'package:final_project/objects/appointment_data_source.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/widgets/appt_editor_event_selector.dart';
import 'package:final_project/widgets/appt_editor_group_selector.dart';
import 'package:final_project/widgets/appt_editor_time_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/group.dart';

Color theme = const Color(0xffffffff);

// *** line 848 is now line 764

class AppointmentEditor extends StatefulWidget {
  /// Holds the value of appointment editor
  const AppointmentEditor(
      this.events, this.selectedAppointment, this.selectedDate,
      {super.key});

  /// Selected appointment
  final LakeAppointment? selectedAppointment;

  final DateTime selectedDate;

  final AppointmentDataSource events;

  @override
  State<AppointmentEditor> createState() => _AppointmentEditorState();
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  bool _isAllDay = false;

  String? _notes;
  String dropdownValue = "Lunch";
  late String _subject;

  late DateTime _originalStartDate;
  late String _originalSubject;
  late String _originalGroup;

  final TimeOfDay _timeSelectorStartTime = const TimeOfDay(hour: 7, minute: 0);
  final TimeOfDay _timeSelectorEndTime = const TimeOfDay(hour: 18, minute: 0);

  // RecurrenceProperties? _recurrenceProperties;
  // late RecurrenceType _recurrenceType;
  // RecurrenceRange? _recurrenceRange;
  // late int _interval;

  // SelectRule? _rule = SelectRule.doesNotRepeat;

  void onEventSelectorChanged(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
      _subject = newValue;
    });
  }

  void onGroupSelectorConfirmed(List<Group> results) {
    setState(() {
      _selectedGroups = results;
      //assignments[widget.group] = _selectedGroups;
    });
  }

  void onAllDaySwitchFlipped(bool value) {
    setState(() {
      _isAllDay = value;
    });
  }

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

  // void onSelectRuleTapped() async {
  //   final dynamic properties = await showDialog<dynamic>(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //             onWillPop: () async {
  //               return true;
  //             },
  //             child: SelectRuleDialog(
  //               _recurrenceProperties,
  //               widget.colorCollection[_selectedColorIndex],
  //               widget.events,
  //               selectedAppointment: widget.selectedAppointment ??
  //                   Appointment(
  //                     startTime: _startDate,
  //                     endTime: _endDate,
  //                     isAllDay: _isAllDay,
  //                     subject: _subject == '' ? '(No title)' : _subject,
  //                   ),
  //               onChanged: (PickerChangedDetails details) {
  //                 setState(() {
  //                   _rule = details.selectedRule;
  //                 });
  //               },
  //             ));
  //       });
  //   _recurrenceProperties = properties as RecurrenceProperties?;
  // }

  List<Group> _selectedGroups = [];

  @override
  void initState() {
    _updateAppointmentProperties();
    _selectedGroups;
    //getEvents();
    if (widget.selectedAppointment != null) {
      dropdownValue = widget.selectedAppointment!.subject!;
    } else {}
    _subject = dropdownValue;
    super.initState();
  }

  /// Updates the required editor's default field
  void _updateAppointmentProperties() {
    if (widget.selectedAppointment != null) {
      _startDate = widget.selectedAppointment!.startTime!;
      _endDate = widget.selectedAppointment!.endTime!;

      // _isAllDay = widget.selectedAppointment!.isAllDay;

      //_selectedGroups = widget.selectedAppointment!.;

      _subject = widget.selectedAppointment!.subject!;
      _notes = widget.selectedAppointment!.notes;

      //_location = widget.selectedAppointment!.location;
      // _recurrenceProperties =
      //     widget.selectedAppointment!.recurrenceRule != null &&
      //             widget.selectedAppointment!.recurrenceRule!.isNotEmpty
      //         ? SfCalendar.parseRRule(
      //             widget.selectedAppointment!.recurrenceRule!, _startDate)
      //         : null;
      // if (_recurrenceProperties == null) {
      //   _rule = SelectRule.doesNotRepeat;
      // } else {
      //   _updateMobileRecurrenceProperties();
      // }

      _originalStartDate = widget.selectedAppointment!.startTime!;
      _originalSubject = widget.selectedAppointment!.subject!;
      _originalGroup = widget.selectedAppointment!.group!;
    } else {
      // _isAllDay = widget.targetElement == CalendarElement.allDayPanel;

      _subject = '';
      _notes = '';
      //_location = '';

      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      // _rule = SelectRule.doesNotRepeat;
      // _recurrenceProperties = null;
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
  }

  // void _updateMobileRecurrenceProperties() {
  //   _recurrenceType = _recurrenceProperties!.recurrenceType;
  //   _recurrenceRange = _recurrenceProperties!.recurrenceRange;
  //   _interval = _recurrenceProperties!.interval;
  //   if (_interval == 1 && _recurrenceRange == RecurrenceRange.noEndDate) {
  //     switch (_recurrenceType) {
  //       case RecurrenceType.daily:
  //         _rule = SelectRule.everyDay;
  //         break;
  //       case RecurrenceType.weekly:
  //         if (_recurrenceProperties!.weekDays.length == 1) {
  //           _rule = SelectRule.everyWeek;
  //         } else {
  //           _rule = SelectRule.custom;
  //         }
  //         break;
  //       case RecurrenceType.monthly:
  //         _rule = SelectRule.everyMonth;
  //         break;
  //       case RecurrenceType.yearly:
  //         _rule = SelectRule.everyYear;
  //         break;
  //     }
  //   } else {
  //     _rule = SelectRule.custom;
  //   }
  // }

  // Widget _getAppointmentEditor(
  //     BuildContext context, Color backgroundColor, Color defaultColor) {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      _selectedGroups = appState.filterGroupsByAge(
          appState.lookupEventByName(_subject).ageMin,
          appState.filterGroupsByTime(_startDate, _endDate, _selectedGroups));
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Navigator.pop(context);
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
                      if (appState.checkEvent(
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
                          "start_hour": "${_startDate.hour}"
                        };

                        appState.editAppt(
                            startTime: _originalStartDate,
                            subject: _originalSubject,
                            group: _originalGroup,
                            data: data);
                        Navigator.pop(context);
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
                      final List<Appointment> appointments = <Appointment>[];

                      bool groupsOccupied = true;

                      Map<String, Map<String, dynamic>> groupToApp = {};
                      for (Group g in _selectedGroups) {
                        Appointment tmpApp = Appointment(
                          startTime: _startDate,
                          endTime: _endDate,
                          color: g.color,
                          notes: _notes,
                          isAllDay: _isAllDay,
                          subject: _subject,
                        );
                        //Turning the already created appointment into something we can put into firebase
                        Map<String, dynamic> appMap = {
                          "start_time": tmpApp.startTime,
                          "end_time": tmpApp.endTime,
                          "color": tmpApp.color.toString(),
                          "notes": tmpApp.notes,
                          "subject": tmpApp.subject,
                          "group": g.name,
                          "start_hour": "${tmpApp.startTime.hour}"
                        };
                        //associating a group with a specific appointment
                        groupToApp[g.name] = appMap;
                        //adding here it what actually puts in on the calendar
                        appointments.add(tmpApp);

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
                      if (appState.checkEvent(
                              _subject, _startDate, _endDate, groupAmount) &&
                          groupsOccupied) {
                        //If it doesnt we come in here and we add the appoinments to the app state
                        appState.addAppointments(
                            groupToApp, appState.firestore);
                        //This for loop adds all of the appointments to the calendar backend which separate from ours.
                        for (Map<String, dynamic> app in groupToApp.values) {
                          widget.events
                              .notifyListeners(CalendarDataSourceAction.add, [
                            appState.createAppointment(app["start_time"],
                                app["end_time"], app["color"], app["subject"])
                          ]);
                        }
                        Navigator.pop(context);
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
                  EventSelector(widget.selectedDate, onEventSelectorChanged,
                      dropdownValue),
                  if (widget.selectedAppointment == null)
                    GroupSelector(
                        appState.filterGroupsByAge(
                            appState.lookupEventByName(_subject).ageMin,
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
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .fontSize,
                            color: widget.selectedAppointment!.color!),
                      )),
                    ),
                  Divider(
                      height: 1.0,
                      thickness: 3,
                      color: Color.lerp(Theme.of(context).colorScheme.tertiary,
                          Colors.white, 0.5)),
                  TimeSelector(
                      // _isAllDay,
                      // onAllDaySwitchFlipped,
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
                      color: Color.lerp(Theme.of(context).colorScheme.tertiary,
                          Colors.white, 0.5)),
                  ListTile(
                    contentPadding: const EdgeInsets.all(5),
                    leading: const Icon(
                      Icons.subject,
                    ),
                    title: Text(
                      appState.lookupEventByName(_subject).desc,
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ],
              )),
          floatingActionButton: widget.selectedAppointment == null
              ? null
              : FloatingActionButton(
                  child: const Icon(Icons.delete_forever),
                  onPressed: () {
                    appState.deleteAppt(
                        startTime: _originalStartDate,
                        subject: _originalSubject,
                        group: _originalGroup);

                    widget.events
                        .notifyListeners(CalendarDataSourceAction.remove, [
                      appState.createAppointment(
                          widget.selectedAppointment!.startTime!,
                          widget.selectedAppointment!.endTime!,
                          widget.selectedAppointment!.color,
                          widget.selectedAppointment!.subject!)
                    ]);

                    Navigator.pop(context);
                  }));
    });
  }
}

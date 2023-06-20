import 'package:final_project/objects/appointment_data_source.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/widgets/appt_editor_event_selector.dart';
import 'package:final_project/widgets/appt_editor_group_selector.dart';
import 'package:final_project/widgets/appt_editor_time_selector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:final_project/widgets/appt_editor_custom_rule.dart';
import 'package:final_project/widgets/appt_editor_edit_dialog.dart';
import 'package:final_project/widgets/appt_editor_select_rule_dialog.dart';
import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/pages/calendar_page.dart';

Color theme = const Color(0xffffffff);

// *** line 848 is now line 764

class AppointmentEditor extends StatefulWidget {
  /// Holds the value of appointment editor
  const AppointmentEditor(this.events, this.selectedAppointment,
      this.selectedDate, this.onAppointmentEdited,
      {super.key});

  /// Selected appointment
  final LakeAppointment? selectedAppointment;

  final DateTime selectedDate;

  final AppointmentDataSource events;

  final AppointmentEditedCallback onAppointmentEdited;

  @override
  State<AppointmentEditor> createState() => _AppointmentEditorState();
}

typedef AppointmentEditedCallback = Function();

class _AppointmentEditorState extends State<AppointmentEditor> {
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  bool _isAllDay = false;

  String? _notes;
  String dropdownValue = "Lunch";
  late String _subject;

  // RecurrenceProperties? _recurrenceProperties;
  // late RecurrenceType _recurrenceType;
  // RecurrenceRange? _recurrenceRange;
  // late int _interval;

  // SelectRule? _rule = SelectRule.doesNotRepeat;

  late List<MultiSelectItem<Group>> _items;

  void onEventSelectorChanged(String? newValue) {
    setState(() {
      dropdownValue = newValue!;
      _subject = newValue;
    });
    var excludedGroups = Provider.of<AppState>(context, listen: false)
        .getGroupsAtTime(_startDate);
    List<Group> showGroups = [];
    for (Group group in Provider.of<AppState>(context, listen: false).groups) {
      if (excludedGroups.contains(group.name)) {
      } else {
        showGroups.add(group);
      }
    }
    createItems(showGroups);
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
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context),
            child: child!,
          );
        });

    if (date != null && date != _startDate) {
      setState(() {
        final Duration difference = _endDate.difference(_startDate);
        _startDate = DateTime(date.year, date.month, date.day, _startTime.hour,
            _startTime.minute);
        _endDate = _startDate.add(difference);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
      });
    }
  }

  void onStartTimePicked() async {
    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: _startTime.hour, minute: _startTime.minute),
        builder: (BuildContext context, Widget? child) {
          return child!;
        });

    if (time != null && time != _startTime) {
      setState(() {
        _startTime = time;
        final Duration difference = _endDate.difference(_startDate);
        _startDate = DateTime(_startDate.year, _startDate.month, _startDate.day,
            _startTime.hour, _startTime.minute);
        _endDate = _startDate.add(difference);
        _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
      });
    }
  }

  void onEndDatePicked() async {
    final DateTime? date = await showDatePicker(
        context: context,
        initialDate: _endDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (BuildContext context, Widget? child) {
          return child!;
        });

    if (date != null && date != _endDate) {
      setState(() {
        final Duration difference = _endDate.difference(_startDate);
        _endDate = DateTime(
            date.year, date.month, date.day, _endTime.hour, _endTime.minute);
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate.subtract(difference);
          _startTime =
              TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        }
      });
    }
  }

  void onEndTimePicked() async {
    final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _endTime.hour, minute: _endTime.minute),
        builder: (BuildContext context, Widget? child) {
          return child!;
        });

    if (time != null && time != _endTime) {
      setState(() {
        _endTime = time;
        final Duration difference = _endDate.difference(_startDate);
        _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day,
            _endTime.hour, _endTime.minute);
        if (_endDate.isBefore(_startDate)) {
          _startDate = _endDate.subtract(difference);
          _startTime =
              TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
        }
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

  void createItems(List<Group> groups) {
    _items = groups
        .map((group) => MultiSelectItem<Group>(group, group.name))
        .toList();
  }

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
    updateDropdown();
  }

  @override
  void didUpdateWidget(AppointmentEditor oldWidget) {
    _updateAppointmentProperties();
    super.didUpdateWidget(oldWidget);
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

  void updateDropdown() {}

  // Widget _getAppointmentEditor(
  //     BuildContext context, Color backgroundColor, Color defaultColor) {
  //   return
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      createItems(appState.groups);
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
                    // if (widget.selectedAppointment!.appointmentType !=
                    //     AppointmentType.normal) {
                    //   final Appointment newAppointment = Appointment(
                    //     startTime: _startDate,
                    //     endTime: _endDate,
                    //     color: widget.colorCollection[_selectedColorIndex],
                    //     notes: _notes,
                    //     isAllDay: _isAllDay,
                    //     subject: _subject == '' ? '(No title)' : _subject,
                    //     // recurrenceExceptionDates: widget
                    //     //     .selectedAppointment!.recurrenceExceptionDates,
                    //     id: widget.selectedAppointment!.id,
                    //     // recurrenceId: widget.selectedAppointment!.recurrenceId,
                    //     recurrenceRule: _recurrenceProperties == null
                    //         ? null
                    //         : SfCalendar.generateRRule(
                    //             _recurrenceProperties!, _startDate, _endDate),
                    //   );

                    //   showDialog<Widget>(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return WillPopScope(
                    //             onWillPop: () async {
                    //               return true;
                    //             },
                    //             child: EditDialog(
                    //                 newAppointment,
                    //                 widget.selectedAppointment!,
                    //                 _recurrenceProperties,
                    //                 widget.events));
                    //       });
                    // } else {
                    //   final List<Appointment> appointment = <Appointment>[];
                    //   if (widget.selectedAppointment != null) {
                    //     widget.events.appointments!.removeAt(widget
                    //         .events.appointments!
                    //         .indexOf(widget.selectedAppointment));
                    //     widget.events.notifyListeners(
                    //         CalendarDataSourceAction.remove,
                    //         <Appointment>[widget.selectedAppointment!]);
                    //   }
                    //   appointment.add(Appointment(
                    //     startTime: _startDate,
                    //     endTime: _endDate,
                    //     color: widget.colorCollection[_selectedColorIndex],
                    //     notes: _notes,
                    //     isAllDay: _isAllDay,
                    //     subject: _subject == '' ? '(No title)' : _subject,
                    //     id: widget.selectedAppointment!.id,
                    //     recurrenceRule: _recurrenceProperties == null
                    //         ? null
                    //         : SfCalendar.generateRRule(
                    //             _recurrenceProperties!, _startDate, _endDate),
                    //   ));
                    //   widget.events.appointments!.add(appointment[0]);

                    //   widget.events.notifyListeners(
                    //       CalendarDataSourceAction.add, appointment);
                    //   Navigator.pop(context);
                    // }
                  } else {
                    final List<Appointment> appointments = <Appointment>[];

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
                    }
                    //appState.addAppointments(groupToApp);

                    int groupAmount = _selectedGroups.length;
                    //Now we check if the amounts of groups trying to be added exceeds the limits set in pace
                    //If it does, it takes us to the else statement
                    if (appState.checkEvent(
                        _subject, _startTime.hour.toString(), groupAmount)) {
                      //If it doesnt we come in here and we add the appoinments to the app state
                      appState.addAppointments(groupToApp, appState.firestore);
                      //This for loop adds all of the appointments to the calendar backend which separate from ours.
                      for (Map<String, dynamic> app in groupToApp.values) {
                        widget.events
                            .notifyListeners(CalendarDataSourceAction.add, [
                          appState.createAppointment(app["start_time"],
                              app["end_time"], app["color"], app["subject"])
                        ]);
                      }
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
                  widget.onAppointmentEdited();
                  Navigator.pop(context);
                })
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                EventSelector(
                    widget.selectedDate, onEventSelectorChanged, dropdownValue),
                GroupSelector(
                    appState.groups, _selectedGroups, onGroupSelectorConfirmed),
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
                    onEndDatePicked,
                    onEndTimePicked),
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
      );
    });
  }
}

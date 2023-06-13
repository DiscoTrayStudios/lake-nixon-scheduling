import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Objects/group.dart';
import 'package:final_project/Pages/calendar_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../Objects/app_state.dart';
import 'calendar_time_zone_picker.dart';
import 'delete_dialog.dart';
import 'edit_dialog.dart';
import 'resource_picker.dart';
import 'select_rule_dialog.dart';
import '../Objects/globals.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

Color theme = const Color(0xffffffff);

// *** line 848 is now line 764

class AppointmentEditor extends StatefulWidget {
  /// Holds the value of appointment editor
  const AppointmentEditor(
      this.selectedAppointment,
      this.targetElement,
      this.selectedDate,
      this.colorCollection,
      this.colorNames,
      this.events,
      this.timeZoneCollection,
      this.group,
      this.firebaseEvents,
      {this.selectedResource,
      super.key});

  /// Selected appointment
  final Appointment? selectedAppointment;

  //final LakeNixonEvent? selectedAppointment;

  /// Calendar element
  final CalendarElement targetElement;

  /// Seelcted date value
  final DateTime selectedDate;

  /// Collection of colors
  final List<Color> colorCollection;

  /// List of colors name
  final List<String> colorNames;

  /// Holds the events value
  final AppointmentDataSource events;

  /// Collection of time zone values
  final List<String> timeZoneCollection;

  /// Selected calendar resource
  final CalendarResource? selectedResource;

  final Group group;

  final List<DropdownMenuItem<String>> firebaseEvents;
  @override
  State<AppointmentEditor> createState() => _AppointmentEditorState();
}

Future<List<DropdownMenuItem<String>>> createDropdown() async {
  List<DropdownMenuItem<String>> menuItems = [
    const DropdownMenuItem(value: "Swimming", child: Text("Swimming"))
  ];
  const DropdownMenuItem(value: "Swimming", child: Text("Swimming"));
  DatabaseReference test = FirebaseDatabase.instance.ref();
  final snapshot = await test.child("events").get();
  if (snapshot.exists) {
    Map? test = snapshot.value as Map?;
    test?.forEach((key, value) {
      menuItems.add(DropdownMenuItem(value: value, child: Text("$value")));
    });
  }
  return menuItems;
}

class _AppointmentEditorState extends State<AppointmentEditor> {
  int _selectedColorIndex = 0;
  int _selectedTimeZoneIndex = 0;
  late DateTime _startDate;
  late TimeOfDay _startTime;
  late DateTime _endDate;
  late TimeOfDay _endTime;
  bool _isAllDay = false;

  String? _notes;
  //String? _location;
  List<Object>? _resourceIds;
  List<CalendarResource> _selectedResources = <CalendarResource>[];
  List<CalendarResource> _unSelectedResources = <CalendarResource>[];
  String dropdownValue = "Lunch";
  late String _subject;

  RecurrenceProperties? _recurrenceProperties;
  late RecurrenceType _recurrenceType;
  RecurrenceRange? _recurrenceRange;
  late int _interval;

  SelectRule? _rule = SelectRule.doesNotRepeat;

  var _items =
      groups.map((group) => MultiSelectItem<Group>(group, group.name)).toList();

  void createItems(List<Group> groups) {
    _items = groups
        .map((group) => MultiSelectItem<Group>(group, group.name))
        .toList();
  }

  List<Group> _selectedGroups = [];

  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    _updateAppointmentProperties();
    _selectedGroups;
    //getEvents();
    if (widget.selectedAppointment != null) {
      dropdownValue = widget.selectedAppointment!.subject;
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
      _startDate = widget.selectedAppointment!.startTime;
      _endDate = widget.selectedAppointment!.endTime;
      _isAllDay = widget.selectedAppointment!.isAllDay;

      //_selectedGroups = widget.selectedAppointment!.;

      _selectedColorIndex =
          widget.colorCollection.indexOf(widget.selectedAppointment!.color);
      _selectedTimeZoneIndex =
          widget.selectedAppointment!.startTimeZone == null ||
                  widget.selectedAppointment!.startTimeZone == ''
              ? 0
              : widget.timeZoneCollection
                  .indexOf(widget.selectedAppointment!.startTimeZone!);
      _subject = widget.selectedAppointment!.subject == '(No title)'
          ? ''
          : widget.selectedAppointment!.subject;
      _notes = widget.selectedAppointment!.notes;
      //_location = widget.selectedAppointment!.location;
      _resourceIds = widget.selectedAppointment!.resourceIds?.sublist(0);
      _recurrenceProperties =
          widget.selectedAppointment!.recurrenceRule != null &&
                  widget.selectedAppointment!.recurrenceRule!.isNotEmpty
              ? SfCalendar.parseRRule(
                  widget.selectedAppointment!.recurrenceRule!, _startDate)
              : null;
      if (_recurrenceProperties == null) {
        _rule = SelectRule.doesNotRepeat;
      } else {
        _updateMobileRecurrenceProperties();
      }
    } else {
      _isAllDay = widget.targetElement == CalendarElement.allDayPanel;
      _selectedColorIndex = 0;
      _selectedTimeZoneIndex = 0;
      _subject = '';
      _notes = '';
      //_location = '';

      final DateTime date = widget.selectedDate;
      _startDate = date;
      _endDate = date.add(const Duration(hours: 1));
      if (widget.selectedResource != null) {
        _resourceIds = <Object>[widget.selectedResource!.id];
      }
      _rule = SelectRule.doesNotRepeat;
      _recurrenceProperties = null;
    }

    _startTime = TimeOfDay(hour: _startDate.hour, minute: _startDate.minute);
    _endTime = TimeOfDay(hour: _endDate.hour, minute: _endDate.minute);
    _selectedResources =
        _getSelectedResources(_resourceIds, widget.events.resources);
    _unSelectedResources =
        _getUnSelectedResources(_selectedResources, widget.events.resources);
  }

  void _updateMobileRecurrenceProperties() {
    _recurrenceType = _recurrenceProperties!.recurrenceType;
    _recurrenceRange = _recurrenceProperties!.recurrenceRange;
    _interval = _recurrenceProperties!.interval;
    if (_interval == 1 && _recurrenceRange == RecurrenceRange.noEndDate) {
      switch (_recurrenceType) {
        case RecurrenceType.daily:
          _rule = SelectRule.everyDay;
          break;
        case RecurrenceType.weekly:
          if (_recurrenceProperties!.weekDays.length == 1) {
            _rule = SelectRule.everyWeek;
          } else {
            _rule = SelectRule.custom;
          }
          break;
        case RecurrenceType.monthly:
          _rule = SelectRule.everyMonth;
          break;
        case RecurrenceType.yearly:
          _rule = SelectRule.everyYear;
          break;
      }
    } else {
      _rule = SelectRule.custom;
    }
  }

  void updateDropdown() {}

  Widget _getAppointmentEditor(
      BuildContext context, Color backgroundColor, Color defaultColor) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Container(
          color: backgroundColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                leading: const Text("Events"),
                //This is the groups dropdown button
                //A current issue is that for the group filtering to work we have to click within this box to
                //get the filtering to work.
                title: DropdownButton(
                  value: dropdownValue,
                  items: appState.createDropdown(
                      widget.firebaseEvents, _startDate),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                      _subject = newValue;
                    });
                    var excludedGroups = appState.getGroupsAtTime(_startDate);
                    List<Group> showGroups = [];
                    for (Group group in appState.groups) {
                      if (excludedGroups.contains(group.name)) {
                      } else {
                        showGroups.add(group);
                      }
                    }
                    createItems(showGroups);
                  },
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                leading: const Text("Assign Groups"),
                //This is where the group select field is
                title: MultiSelectDialogField(
                  items: _items,
                  initialValue: _selectedGroups,
                  onConfirm: (results) {
                    setState(() {
                      _selectedGroups = results;
                      //assignments[widget.group] = _selectedGroups;
                    });
                  },
                ),
              ),
              const Divider(
                height: 1.0,
                thickness: 1,
              ),
              ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  leading: Icon(
                    Icons.access_time,
                    color: defaultColor,
                  ),
                  title: Row(children: <Widget>[
                    const Expanded(
                      child: Text('All-day'),
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Switch(
                              value: _isAllDay,
                              onChanged: (bool value) {
                                setState(() {
                                  _isAllDay = value;
                                });
                              },
                            ))),
                  ])),
              ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  leading: const Text(''),
                  title: Row(children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: GestureDetector(
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _startDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    brightness: Brightness.light,
                                    colorScheme: ColorScheme.fromSwatch(
                                      backgroundColor: theme,
                                    ),
                                  ),
                                  child: child!,
                                );
                              });

                          if (date != null && date != _startDate) {
                            setState(() {
                              final Duration difference =
                                  _endDate.difference(_startDate);
                              _startDate = DateTime(date.year, date.month,
                                  date.day, _startTime.hour, _startTime.minute);
                              _endDate = _startDate.add(difference);
                              _endTime = TimeOfDay(
                                  hour: _endDate.hour, minute: _endDate.minute);
                            });
                          }
                        },
                        child: Text(
                            DateFormat('EEE, MMM dd yyyy').format(_startDate),
                            textAlign: TextAlign.left),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: _isAllDay
                            ? const Text('')
                            : GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: _startTime.hour,
                                          minute: _startTime.minute),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData(
                                            brightness: Brightness.light,
                                            colorScheme: ColorScheme.fromSwatch(
                                              backgroundColor:
                                                  const Color(0xff4169e1),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      });

                                  if (time != null && time != _startTime) {
                                    setState(() {
                                      _startTime = time;
                                      final Duration difference =
                                          _endDate.difference(_startDate);
                                      _startDate = DateTime(
                                          _startDate.year,
                                          _startDate.month,
                                          _startDate.day,
                                          _startTime.hour,
                                          _startTime.minute);
                                      _endDate = _startDate.add(difference);
                                      _endTime = TimeOfDay(
                                          hour: _endDate.hour,
                                          minute: _endDate.minute);
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('hh:mm a').format(_startDate),
                                  textAlign: TextAlign.right,
                                ),
                              )),
                  ])),
              ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  leading: const Text(''),
                  title: Row(children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: GestureDetector(
                        onTap: () async {
                          final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: _endDate,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    brightness: Brightness.light,
                                    colorScheme: ColorScheme.fromSwatch(
                                      backgroundColor: const Color(0xff4169e1),
                                    ),
                                  ),
                                  child: child!,
                                );
                              });

                          if (date != null && date != _endDate) {
                            setState(() {
                              final Duration difference =
                                  _endDate.difference(_startDate);
                              _endDate = DateTime(date.year, date.month,
                                  date.day, _endTime.hour, _endTime.minute);
                              if (_endDate.isBefore(_startDate)) {
                                _startDate = _endDate.subtract(difference);
                                _startTime = TimeOfDay(
                                    hour: _startDate.hour,
                                    minute: _startDate.minute);
                              }
                            });
                          }
                        },
                        child: Text(
                          DateFormat('EEE, MMM dd yyyy').format(_endDate),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: _isAllDay
                            ? const Text('')
                            : GestureDetector(
                                onTap: () async {
                                  final TimeOfDay? time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                          hour: _endTime.hour,
                                          minute: _endTime.minute),
                                      builder: (BuildContext context,
                                          Widget? child) {
                                        return Theme(
                                          data: ThemeData(
                                            brightness: Brightness.light,
                                            colorScheme: ColorScheme.fromSwatch(
                                              backgroundColor:
                                                  const Color(0xff4169e1),
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      });

                                  if (time != null && time != _endTime) {
                                    setState(() {
                                      _endTime = time;
                                      final Duration difference =
                                          _endDate.difference(_startDate);
                                      _endDate = DateTime(
                                          _endDate.year,
                                          _endDate.month,
                                          _endDate.day,
                                          _endTime.hour,
                                          _endTime.minute);
                                      if (_endDate.isBefore(_startDate)) {
                                        _startDate =
                                            _endDate.subtract(difference);
                                        _startTime = TimeOfDay(
                                            hour: _startDate.hour,
                                            minute: _startDate.minute);
                                      }
                                    });
                                  }
                                },
                                child: Text(
                                  DateFormat('hh:mm a').format(_endDate),
                                  textAlign: TextAlign.right,
                                ),
                              )),
                  ])),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.public,
                  color: defaultColor,
                ),
                title: Text(widget.timeZoneCollection[_selectedTimeZoneIndex]),
                onTap: () {
                  showDialog<Widget>(
                    context: context,
                    builder: (BuildContext context) {
                      return CalendarTimeZonePicker(
                        const Color(0xff4169e1),
                        widget.timeZoneCollection,
                        _selectedTimeZoneIndex,
                        onChanged: (PickerChangedDetails details) {
                          _selectedTimeZoneIndex = details.index;
                        },
                      );
                    },
                  ).then((dynamic value) => setState(() {
                        /// update the time zone changes
                      }));
                },
              ),
              ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: Icon(
                  Icons.refresh,
                  color: defaultColor,
                ),
                title: Text(_rule == SelectRule.doesNotRepeat
                    ? 'Does not repeat'
                    : _rule == SelectRule.everyDay
                        ? 'Every day'
                        : _rule == SelectRule.everyWeek
                            ? 'Every week'
                            : _rule == SelectRule.everyMonth
                                ? 'Every month'
                                : _rule == SelectRule.everyYear
                                    ? 'Every year'
                                    : 'Custom'),
                onTap: () async {
                  final dynamic properties = await showDialog<dynamic>(
                      context: context,
                      builder: (BuildContext context) {
                        return WillPopScope(
                            onWillPop: () async {
                              return true;
                            },
                            child: Theme(
                              data: ThemeData(
                                  brightness: Brightness.light,
                                  colorScheme: ColorScheme.fromSwatch(
                                    backgroundColor: const Color(0xff4169e1),
                                  )),
                              // ignore: prefer_const_literals_to_create_immutables
                              child: SelectRuleDialog(
                                _recurrenceProperties,
                                widget.colorCollection[_selectedColorIndex],
                                widget.events,
                                selectedAppointment:
                                    widget.selectedAppointment ??
                                        Appointment(
                                          startTime: _startDate,
                                          endTime: _endDate,
                                          isAllDay: _isAllDay,
                                          subject: _subject == ''
                                              ? '(No title)'
                                              : _subject,
                                        ),
                                onChanged: (PickerChangedDetails details) {
                                  setState(() {
                                    _rule = details.selectedRule;
                                  });
                                },
                              ),
                            ));
                      });
                  _recurrenceProperties = properties as RecurrenceProperties?;
                },
              ),
              if (widget.events.resources == null ||
                  widget.events.resources!.isEmpty)
                Container()
              else
                ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                  leading: Icon(Icons.people, color: defaultColor),
                  title: _getResourceEditor(TextStyle(
                      fontSize: 18,
                      color: defaultColor,
                      fontWeight: FontWeight.w300)),
                  onTap: () {
                    showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return ResourcePicker(
                          _unSelectedResources,
                          onChanged: (PickerChangedDetails details) {
                            _resourceIds = _resourceIds == null
                                ? <Object>[details.resourceId!]
                                : (_resourceIds!.sublist(0)
                                  ..add(details.resourceId!));
                            _selectedResources = _getSelectedResources(
                                _resourceIds, widget.events.resources);
                            _unSelectedResources = _getUnSelectedResources(
                                _selectedResources, widget.events.resources);
                          },
                        );
                      },
                    ).then((dynamic value) => setState(() {
                          /// update the color picker changes
                        }));
                  },
                ),
              const Divider(
                height: 1.0,
                thickness: 1,
              ),
              const Divider(
                height: 1.0,
                thickness: 1,
              ),
              Container(),
              Container(),
              ListTile(
                contentPadding: const EdgeInsets.all(5),
                leading: Icon(
                  Icons.subject,
                  color: defaultColor,
                ),
                title: Text(
                  appState.indexEvents(_subject).desc,
                  style: TextStyle(
                      fontSize: 18,
                      color: defaultColor,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Theme(
          data: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSwatch(
              backgroundColor: const Color(0xff4169e1),
            ),
          ),
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: widget.colorCollection[_selectedColorIndex],
                leading: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: <Widget>[
                  IconButton(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        //updateDropdown();
                        if (widget.selectedAppointment != null) {
                          if (widget.selectedAppointment!.appointmentType !=
                              AppointmentType.normal) {
                            final Appointment newAppointment = Appointment(
                              startTime: _startDate,
                              endTime: _endDate,
                              color:
                                  widget.colorCollection[_selectedColorIndex],
                              startTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : widget.timeZoneCollection[
                                      _selectedTimeZoneIndex],
                              endTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : widget.timeZoneCollection[
                                      _selectedTimeZoneIndex],
                              notes: _notes,
                              isAllDay: _isAllDay,
                              subject: _subject == '' ? '(No title)' : _subject,
                              recurrenceExceptionDates: widget
                                  .selectedAppointment!
                                  .recurrenceExceptionDates,
                              resourceIds: _resourceIds,
                              id: widget.selectedAppointment!.id,
                              recurrenceId:
                                  widget.selectedAppointment!.recurrenceId,
                              recurrenceRule: _recurrenceProperties == null
                                  ? null
                                  : SfCalendar.generateRRule(
                                      _recurrenceProperties!,
                                      _startDate,
                                      _endDate),
                            );

                            showDialog<Widget>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async {
                                        return true;
                                      },
                                      child: Theme(
                                        data: ThemeData(
                                          brightness: Brightness.light,
                                          colorScheme: ColorScheme.fromSwatch(
                                            backgroundColor:
                                                const Color(0xff4169e1),
                                          ),
                                        ),
                                        child: EditDialog(
                                            newAppointment,
                                            widget.selectedAppointment!,
                                            _recurrenceProperties,
                                            widget.events),
                                      ));
                                });
                          } else {
                            final List<Appointment> appointment =
                                <Appointment>[];
                            if (widget.selectedAppointment != null) {
                              widget.events.appointments!.removeAt(widget
                                  .events.appointments!
                                  .indexOf(widget.selectedAppointment));
                              widget.events.notifyListeners(
                                  CalendarDataSourceAction.remove,
                                  <Appointment>[widget.selectedAppointment!]);
                            }
                            appointment.add(Appointment(
                              startTime: _startDate,
                              endTime: _endDate,
                              color:
                                  widget.colorCollection[_selectedColorIndex],
                              startTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : widget.timeZoneCollection[
                                      _selectedTimeZoneIndex],
                              endTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : widget.timeZoneCollection[
                                      _selectedTimeZoneIndex],
                              notes: _notes,
                              isAllDay: _isAllDay,
                              subject: _subject == '' ? '(No title)' : _subject,
                              resourceIds: _resourceIds,
                              id: widget.selectedAppointment!.id,
                              recurrenceRule: _recurrenceProperties == null
                                  ? null
                                  : SfCalendar.generateRRule(
                                      _recurrenceProperties!,
                                      _startDate,
                                      _endDate),
                            ));
                            widget.events.appointments!.add(appointment[0]);

                            widget.events.notifyListeners(
                                CalendarDataSourceAction.add, appointment);
                            Navigator.pop(context);
                          }
                        } else {
                          final List<Appointment> appointment = <Appointment>[];
                          if (widget.selectedAppointment != null) {
                            widget.events.appointments!.removeAt(widget
                                .events.appointments!
                                .indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment!]);
                          }

                          Appointment app = Appointment(
                            startTime: _startDate,
                            endTime: _endDate,
                            color: widget.colorCollection[_selectedColorIndex],
                            startTimeZone: _selectedTimeZoneIndex == 0
                                ? ''
                                : widget
                                    .timeZoneCollection[_selectedTimeZoneIndex],
                            endTimeZone: _selectedTimeZoneIndex == 0
                                ? ''
                                : widget
                                    .timeZoneCollection[_selectedTimeZoneIndex],
                            notes: _notes,
                            isAllDay: _isAllDay,
                            subject: _subject == '' ? '(No title)' : _subject,
                            resourceIds: _resourceIds,
                            recurrenceRule: _rule == SelectRule.doesNotRepeat ||
                                    _recurrenceProperties == null
                                ? null
                                : SfCalendar.generateRRule(
                                    _recurrenceProperties!,
                                    _startDate,
                                    _endDate),
                          );

                          ///WE ARE WORKING HERE
                          Map<String, Map<String, dynamic>> groupToApp = {};
                          for (Group g in _selectedGroups) {
                            Appointment tmpApp = Appointment(
                              startTime: _startDate,
                              endTime: _endDate,
                              color: g.color,
                              startTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : widget.timeZoneCollection[
                                      _selectedTimeZoneIndex],
                              endTimeZone: _selectedTimeZoneIndex == 0
                                  ? ''
                                  : widget.timeZoneCollection[
                                      _selectedTimeZoneIndex],
                              notes: _notes,
                              isAllDay: _isAllDay,
                              subject: _subject == '' ? '(No title)' : _subject,
                              resourceIds: _resourceIds,
                              recurrenceRule:
                                  _rule == SelectRule.doesNotRepeat ||
                                          _recurrenceProperties == null
                                      ? null
                                      : SfCalendar.generateRRule(
                                          _recurrenceProperties!,
                                          _startDate,
                                          _endDate),
                            );
                            //Turning the already created appointment into something we can put into firebase
                            var startTime = tmpApp.startTime;
                            Map<String, dynamic> appMap = {
                              "start_time": startTime,
                              "end_time": tmpApp.endTime,
                              "color": tmpApp.color.toString(),
                              "notes": tmpApp.notes,
                              "subject": tmpApp.subject,
                              "group": g.name,
                              "start_hour": "${startTime.hour}"
                            };
                            //associating a group with a specific appointment
                            groupToApp[g.name] = appMap;
                            //adding here it what actually puts in on the calendar
                            appointment.add(tmpApp);
                          }
                          //appState.addAppointments(groupToApp);

                          var time = app.startTime;
                          String hour = "${time.hour}";
                          var name = app.subject;

                          //Checking if we have groups to look through
                          if (_selectedGroups.iterator.moveNext()) {
                            int groupAmount = _selectedGroups.length;
                            //Now we check if the amounts of groups trying to be added exceeds the limits set in pace
                            //If it does, it takes us to the else statement
                            if (appState.checkEvent(name, hour, groupAmount)) {
                              //If it doesnt we come in here and we add the appoinments to the app state
                              appState.addAppointments(groupToApp);
                              //This for loop adds all of the appointments to the calendar backend which separate from ours.
                              for (Map<String, dynamic> app
                                  in groupToApp.values) {
                                widget.events.notifyListeners(
                                    CalendarDataSourceAction.add, [
                                  appState.createApp(
                                      app["start_time"],
                                      app["end_time"],
                                      app["color"],
                                      app["subject"])
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

                          Navigator.pop(context);
                        }
                      })
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Stack(
                  children: <Widget>[
                    _getAppointmentEditor(
                        context, (Colors.white), Colors.black87)
                  ],
                ),
              ),
              floatingActionButton: widget.selectedAppointment == null
                  ? const Text('')
                  : FloatingActionButton(
                      onPressed: () {
                        if (widget.selectedAppointment != null) {
                          if (widget.selectedAppointment!.appointmentType ==
                              AppointmentType.normal) {
                            //Another Potential Fix?
                            //THIS ALL CAN MOST LIKELY BE DELETED
                            //WAS CODE FROM OLD DB
                            //MIGHT HAVE SOME HELPFUL FEATURES FOR DELETION
                            Map<String, dynamic> appMap = {
                              "appointment": [
                                widget.selectedAppointment?.startTime,
                                widget.selectedAppointment?.endTime,
                                widget.selectedAppointment?.color.toString(),
                                widget.selectedAppointment?.startTimeZone,
                                widget.selectedAppointment?.endTimeZone,
                                widget.selectedAppointment?.notes,
                                widget.selectedAppointment?.isAllDay,
                                widget.selectedAppointment?.subject,
                                widget.selectedAppointment?.resourceIds,
                                widget.selectedAppointment?.recurrenceRule
                              ]
                            };

                            var time = widget.selectedAppointment?.startTime;
                            var hour = "${time?.hour}";
                            var name = widget.selectedAppointment?.subject;
                            DateFormat formatter = DateFormat("MM-dd-yy");
                            var docName = formatter.format(time!);

                            db.collection("schedules").doc(docName).update({
                              "appointments.${widget.group.name}":
                                  FieldValue.arrayRemove([appMap])
                            });

                            db.collection("schedules").doc(docName).update({
                              "$name.$hour":
                                  FieldValue.arrayRemove([widget.group.name])
                            });

                            widget.events.appointments?.removeAt(widget
                                .events.appointments!
                                .indexOf(widget.selectedAppointment));
                            widget.events.notifyListeners(
                                CalendarDataSourceAction.remove,
                                <Appointment>[widget.selectedAppointment!]);
                            Navigator.pop(context);
                          } else {
                            showDialog<Widget>(
                                context: context,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async {
                                        return true;
                                      },
                                      child: Theme(
                                        data: ThemeData(
                                          brightness: Brightness.light,
                                          colorScheme: ColorScheme.fromSwatch(
                                            backgroundColor:
                                                const Color(0xff4169e1),
                                          ),
                                        ),
                                        // ignore: prefer_const_literals_to_create_immutables
                                        child: DeleteDialog(
                                            widget.selectedAppointment!,
                                            widget.events),
                                      ));
                                });
                          }
                        }
                      },
                      backgroundColor: const Color(0xff4169e1),
                      child:
                          const Icon(Icons.delete_outline, color: Colors.white),
                    )));
    });
  }

  Widget _getResourceEditor(TextStyle hintTextStyle) {
    if (_selectedResources.isEmpty) {
      return Text('Add people', style: hintTextStyle);
    }

    final List<Widget> chipWidgets = <Widget>[];
    for (int i = 0; i < _selectedResources.length; i++) {
      final CalendarResource selectedResource = _selectedResources[i];
      chipWidgets.add(Chip(
        padding: EdgeInsets.zero,
        avatar: CircleAvatar(
          backgroundColor: const Color(0xff4169e1),
          backgroundImage: selectedResource.image,
          child: selectedResource.image == null
              ? Text(selectedResource.displayName[0])
              : null,
        ),
        label: Text(selectedResource.displayName),
        onDeleted: () {
          _selectedResources.removeAt(i);
          _resourceIds!.removeAt(i);
          _unSelectedResources = _getUnSelectedResources(
              _selectedResources, widget.events.resources);
          setState(() {});
        },
      ));
    }

    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: chipWidgets,
    );
  }
}

List<CalendarResource> _getSelectedResources(
    List<Object>? resourceIds, List<CalendarResource>? resourceCollection) {
  final List<CalendarResource> selectedResources = <CalendarResource>[];
  if (resourceIds == null ||
      resourceIds.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return selectedResources;
  }

  for (int i = 0; i < resourceIds.length; i++) {
    final CalendarResource resourceName =
        _getResourceFromId(resourceIds[i], resourceCollection);
    selectedResources.add(resourceName);
  }

  return selectedResources;
}

/// Returns the available resource, by filtering the resource collection from
/// the selected resource collection.
List<CalendarResource> _getUnSelectedResources(
    List<CalendarResource>? selectedResources,
    List<CalendarResource>? resourceCollection) {
  if (selectedResources == null ||
      selectedResources.isEmpty ||
      resourceCollection == null ||
      resourceCollection.isEmpty) {
    return resourceCollection ?? <CalendarResource>[];
  }

  final List<CalendarResource> collection = resourceCollection.sublist(0);
  for (int i = 0; i < resourceCollection.length; i++) {
    final CalendarResource resource = resourceCollection[i];
    for (int j = 0; j < selectedResources.length; j++) {
      final CalendarResource selectedResource = selectedResources[j];
      if (resource.id == selectedResource.id) {
        collection.remove(resource);
      }
    }
  }

  return collection;
}

CalendarResource _getResourceFromId(
    Object resourceId, List<CalendarResource> resourceCollection) {
  return resourceCollection
      .firstWhere((CalendarResource resource) => resource.id == resourceId);
}

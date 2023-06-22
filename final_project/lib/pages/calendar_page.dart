import 'package:final_project/objects/appointment_data_source.dart';
import 'package:final_project/objects/multi_select_dialog_helpers.dart';
import 'package:final_project/pages/appointment_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:final_project/pages/appointment_editor.dart';
import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/lake_nixon_event.dart';

List<LakeNixonEvent> appointments = <LakeNixonEvent>[];

//late bool isUser;

class CalendarPage extends StatefulWidget {
  const CalendarPage(
      {super.key,
      required this.title,
      required this.group,
      required this.isUser,
      required this.master});

  final String title;
  final Group group;
  final bool isUser;
  final bool master;
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

final List<CalendarView> _allowedViews = <CalendarView>[
  CalendarView.workWeek,
  //CalendarView.week,
  CalendarView.day,
  //CalendarView.month,
  CalendarView.timelineDay,
  //CalendarView.timelineWeek,
  CalendarView.timelineWorkWeek,
  //CalendarView.timelineMonth,
];

class _CalendarPageState extends State<CalendarPage> {
  _CalendarPageState();

  //AppointmentDataSource _events = AppointmentDataSource(<Appointment>[]);
  late CalendarView _currentView;

  //bool isUser = true;
  //var isUser;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();
  final CalendarController _calendarController = CalendarController();
  //LakeNixonEvent? _selectedAppointment;
  Appointment? _selectedAppointment;
  List<DropdownMenuItem<String>> firebaseEvents = [];
  List<Appointment> savedEvents = [];
  List<Group> _selectedGroups = [];
  List<String> _selectedEvents = [];

  //bool get user => widget.isUser;
  //bool user = widget.isUser;
  @override
  void initState() {
    _currentView = CalendarView.workWeek;
    _calendarController.view = _currentView;
    bool user = widget.isUser;
    //_checkAuth();
    // getEvents();
    //getSavedEvents();
    // _events = AppointmentDataSource(_getDataSource(widget.group));

    super.initState();
  }

//This is what handles changing the calendar view
  void _onViewChanged(ViewChangedDetails viewChangedDetails) {
    if (_currentView != CalendarView.month &&
        _calendarController.view != CalendarView.month) {
      _currentView = _calendarController.view!;
      return;
    }

    _currentView = _calendarController.view!;
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      setState(() {
        // Update the scroll view when view changes.
      });
    });
  }

// Handles when you click calendar events
  void _onCalendarTapped(CalendarTapDetails calendarTapDetails) {
    /// Condition added to open the editor, when the calendar elements tapped
    /// other than the header.
    if (calendarTapDetails.targetElement == CalendarElement.header ||
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      return;
    }

    /// Navigates the calendar to day view,
    /// when we tap on month cells in mobile.
    if (_calendarController.view == CalendarView.month) {
      _calendarController.view = CalendarView.day;
    } else {
      final DateTime selectedDate = calendarTapDetails.date!;

      //This is what takes you to the appointment editor
      if (calendarTapDetails.appointments != null) {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => AppointmentSelector(
                  AppointmentDataSource(Provider.of<AppState>(context)
                      .allAppointments(_selectedGroups, _selectedEvents)),
                  selectedDate,
                  selectedGroups:
                      _selectedGroups.isEmpty ? null : _selectedGroups,
                  selectedEvents:
                      _selectedEvents.isEmpty ? null : _selectedEvents)),
        ).then((value) {
          setState(() {});
        });
      } else {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => AppointmentEditor(
                    AppointmentDataSource(Provider.of<AppState>(context)
                        .allAppointments(_selectedGroups, _selectedEvents)),
                    null,
                    selectedDate,
                  )),
        ).then((value) {
          setState(() {});
        });
      }
    }
  }

// This determines if we send the user to the master calendar or user calendar
  Widget _getCalendar(BuildContext context, String group) {
    if (widget.master) {
      return Consumer<AppState>(builder: (context, appState, child) {
        return _getMasterCalender(
            _calendarController,
            AppointmentDataSource(
                appState.allAppointments(_selectedGroups, _selectedEvents)),
            _onViewChanged,
            _onCalendarTapped);
      });
    } else {
      return Consumer<AppState>(builder: (context, appState, child) {
        return _getLakeNixonCalender(
          _calendarController,
          AppointmentDataSource(appState.appointmentsByGroup(group)),
          _onViewChanged,
          _onCalendarTapped,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //var test = [MultiSelectItem("test", "test")];
    final Widget calendar = Theme(

        /// The key set here to maintain the state, when we change
        /// the parent of the widget
        key: _globalKey,
        data: Theme.of(context),
        child: _getCalendar(context, widget.group.name));
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: const FlexibleSpaceBar(),
          title: Text("${widget.group.name} calendar",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          actions: [
            MultiSelectDialogField(
              title: const Text("Filter Groups"),
              items: createCheckboxGroups(appState.groups),
              initialValue: _selectedGroups,
              chipDisplay: MultiSelectChipDisplay<Group>.none(),
              buttonIcon: const Icon(Icons.filter_list),
              buttonText: const Text('Groups'),
              onConfirm: (results) {
                setState(() {
                  _selectedGroups = results;
                  //assignments[widget.group] = _selectedGroups;
                });
              },
            ),
            MultiSelectDialogField(
              title: const Text("Filter Events"),
              items: createCheckboxEvents(appState.events),
              initialValue: _selectedEvents,
              chipDisplay: MultiSelectChipDisplay<String>.none(),
              buttonIcon: const Icon(Icons.filter_list),
              buttonText: const Text('Events'),
              onConfirm: (results) {
                setState(() {
                  _selectedEvents = results;
                  //assignments[widget.group] = _selectedGroups;
                });
              },
            ),
          ],
        ),
        body: Row(children: <Widget>[
          Expanded(
            child: Container(color: theme, child: calendar),
          ),
        ]),
      );
    });
  }
}

dynamic tapped(bool user, dynamic tap) {
  if (user == true) {
    return null;
  } else {
    return tap;
  }
}

SfCalendar _getLakeNixonCalender(
    [CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
    dynamic calendarTapCallback]) {
  return SfCalendar(
    controller: calendarController,
    dataSource: calendarDataSource,
    allowedViews: _allowedViews,
    onViewChanged: viewChangedCallback,
    allowDragAndDrop: true,
    showDatePickerButton: true,
    monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 60),
        startHour: 7,
        endHour: 18,
        nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday]),
    onTap: tapped(false, calendarTapCallback),
  );
}

SfCalendar _getMasterCalender(
    [CalendarController? calendarController,
    CalendarDataSource? calendarDataSource,
    ViewChangedCallback? viewChangedCallback,
    dynamic calendarTapCallback]) {
  return SfCalendar(
    controller: calendarController,
    dataSource: calendarDataSource,
    allowedViews: _allowedViews,
    onViewChanged: viewChangedCallback,
    allowDragAndDrop: true,
    showDatePickerButton: true,
    monthViewSettings: const MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
    timeSlotViewSettings: const TimeSlotViewSettings(
        minimumAppointmentDuration: Duration(minutes: 60),
        startHour: 7,
        endHour: 18,
        nonWorkingDays: <int>[DateTime.saturday, DateTime.sunday]),
    onTap: tapped(false, calendarTapCallback),
  );
}

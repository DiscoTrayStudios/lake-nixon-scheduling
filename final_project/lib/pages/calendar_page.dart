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

//late bool isUser;

/// A page to display a calendar with appointments, colorcoded by group.
///
/// Can display a single group, or all of the groups, with filters for events and
/// groups.
class CalendarPage extends StatefulWidget {
  /// A page to display a calendar with appointments, colorcoded by group.
  ///
  /// Can display a single group, or all of the groups based off of the value of
  /// this.master], with filters for events and groups. [this.isUser] determines
  /// whether the user should have write access to the calendar. In the case of a
  /// single group calendar, [this.group] indicates the group.
  const CalendarPage(
      {super.key,
      required this.title,
      required this.group,
      required this.isUser,
      required this.master});

  final String title;

  /// The group to be displayed on a single group calendar.
  final Group group;

  /// Whether the user is a user or admin.
  final bool isUser;

  /// Whether the calendar is the master calendar.
  final bool master;
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

/// The views that the calendar can be set to.
///
/// Includes day and workWeek, in either a standard calendar
/// or timeline view.
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

  //AppointmentDataSource _activities = AppointmentDataSource(<Appointment>[]);

  /// The current view that the calendar is set to.
  ///
  /// e.g. workWeek
  late CalendarView _currentView;

  //bool isUser = true;
  //var isUser;

  /// Global key used to maintain the state, when we change the parent of the
  /// widget.
  final GlobalKey _globalKey = GlobalKey();
  final ScrollController _controller = ScrollController();

  /// The controller for the calendar.
  final CalendarController _calendarController = CalendarController();

  // unused group
  //LakeNixonActivity? _selectedAppointment;
  Appointment? _selectedAppointment;
  List<DropdownMenuItem<String>> firebaseActivities = [];
  List<Appointment> savedActivities = [];

  /// The groups selected by the filter.
  ///
  /// If empty, then the groups should not be filtered.
  List<Group> _selectedGroups = [];

  /// The activities selected by the filter.
  ///
  /// If empty, then the activities should not be filtered.
  List<String> _selectedActivities = [];

  //bool get user => widget.isUser;
  //bool user = widget.isUser;

  /// Initializes the state for the calendar page.
  ///
  /// Sets the default [_currentView].
  @override
  void initState() {
    _currentView = CalendarView.workWeek;
    _calendarController.view = _currentView;
    bool user = widget.isUser;
    //_checkAuth();
    // getActivities();
    //getSavedActivities();
    // _activities = AppointmentDataSource(_getDataSource(widget.group));

    super.initState();
  }

  /// Updates page state when calendar view is changed.
  ///
  /// A callback used by the calendar.
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

  /// Handles clicking on the calendar.
  ///
  /// When an empty timeslot is clicked, the user is navigated to the
  /// [AppointmentEditor]. If a timeslot that is not empty is clicked, the user
  /// is navigated to the [AppointmentSelector]. Also handles taps on other parts
  /// of the calendar such as the header.
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
                      .allAppointments(_selectedGroups, _selectedActivities)),
                  selectedDate,
                  selectedGroups:
                      _selectedGroups.isEmpty ? null : _selectedGroups,
                  selectedActivities: _selectedActivities.isEmpty
                      ? null
                      : _selectedActivities)),
        ).then((value) {
          setState(() {});
        });
      } else {
        Navigator.push<Widget>(
          context,
          MaterialPageRoute<Widget>(
              builder: (BuildContext context) => AppointmentEditor(
                    AppointmentDataSource(Provider.of<AppState>(context)
                        .allAppointments(_selectedGroups, _selectedActivities)),
                    null,
                    selectedDate,
                  )),
        ).then((value) {
          setState(() {});
        });
      }
    }
  }

  /// Determines whether to send user to single group or master calendar.
  ///
  /// Creates a calendar widget depending on the value of [widget.master].
  Widget _getCalendar(BuildContext context, String group) {
    if (widget.master) {
      return Consumer<AppState>(builder: (context, appState, child) {
        return _getMasterCalender(
            _calendarController,
            AppointmentDataSource(
                appState.allAppointments(_selectedGroups, _selectedActivities)),
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
              title: const Text("Filter Activities"),
              items: createCheckboxActivities(appState.activities),
              initialValue: _selectedActivities,
              chipDisplay: MultiSelectChipDisplay<String>.none(),
              buttonIcon: const Icon(Icons.filter_list),
              buttonText: const Text('Activities'),
              onConfirm: (results) {
                setState(() {
                  _selectedActivities = results;
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

// should not be used.
dynamic tapped(bool user, dynamic tap) {
  if (user == true) {
    return null;
  } else {
    return tap;
  }
}

/// Creates a single group calendar using default parameters.
///
/// Simplifies calendar api to only expose the controller, the data source, and
/// the viewchanged and tap callbacks.
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

/// Creates a master calendar using default parameters.
///
/// Simplifies calendar api to only expose the controller, the data source, and
/// the viewchanged and tap callbacks.
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

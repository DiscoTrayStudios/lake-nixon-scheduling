import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/theme.dart';
import 'package:final_project/widgets/appointment_info_popup.dart';
import 'package:final_project/objects/lake_appointment.dart';
import 'package:final_project/objects/lake_event_arranger.dart';
import 'package:final_project/objects/multi_select_dialog_helpers.dart';
import 'package:final_project/objects/screen_arguments.dart';

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
      {super.key, required this.title, this.group, required this.isUser});

  final String title;

  /// The group to be displayed on a single group calendar.
  final Group? group;

  /// Whether the user is a user or admin.
  final bool isUser;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  _CalendarPageState();

  bool _isDayView = false;

  DateTime _focusedDay = DateTime.now().withoutTime;

  /// The groups selected by the filter.
  ///
  /// If empty, then the groups should not be filtered.
  List<Group> _selectedGroups = [];

  /// The activities selected by the filter.
  ///
  /// If empty, then the activities should not be filtered.
  List<String> _selectedActivities = [];

  /// Initializes the state for the calendar page.
  ///
  /// Sets the default [_currentView].
  @override
  void initState() {
    super.initState();
  }

  /// A callback for when an empty space is tapped.
  ///
  /// If the user an admin, it checks if there are any appointments in the
  /// selected timeslot and sends the user to the appointment selector. Otherwise,
  /// the user is sent to the appointment editor.
  ///
  /// If the user is not an admin, it does nothing.
  void Function(DateTime) onTapEmpty(AppState appState) {
    return ((DateTime date) {
      if (date.hour >= 7 && date.hour < 18 && !widget.isUser) {
        if (appState.getApptsAtTime(date).isEmpty) {
          setState(() {
            Navigator.pushNamed(context, '/appointmentEditorPage',
                arguments: AppointmentEditorArguments(selectedDate: date));
          });
        } else {
          setState(() {
            Navigator.pushNamed(context, '/appointmentSelectorPage',
                arguments: AppointmentSelectorArguments(
                    selectedDate: date,
                    selectedActivities: _selectedActivities.isEmpty
                        ? appState.activities
                            .map((activity) => activity.name)
                            .toList()
                        : _selectedActivities,
                    selectedGroups: _selectedGroups.isEmpty
                        ? appState.groups
                        : _selectedGroups));
          });
        }
      }
    });
  }

  /// A callback for when an event is tapped.
  ///
  /// If the user is an admin, they are sent to the appointment selector. Otherwise,
  /// they are shown a popup with info about the event.
  void Function(List<CalendarEventData<LakeAppointment>>, DateTime) onTapEvent(
      AppState appState) {
    return ((List<CalendarEventData<LakeAppointment>> selectedEvents,
        DateTime date) {
      if (!widget.isUser) {
        setState(() {
          Navigator.pushNamed(context, '/appointmentSelectorPage',
              arguments: AppointmentSelectorArguments(
                  selectedDate: selectedEvents.first.startTime!,
                  selectedActivities: _selectedActivities.isEmpty
                      ? appState.activities
                          .map((activity) => activity.name)
                          .toList()
                      : _selectedActivities,
                  selectedGroups: _selectedGroups.isEmpty
                      ? appState.groups
                      : _selectedGroups));
        });
      } else {
        appointmentInfoPopup(context, selectedEvents[0].event!);
      }
    });
  }

  void onPageChange(DateTime date, int page) {
    _focusedDay = date;
  }

  /// Converts a list of `LakeAppointment`s to a list of `CalendarEventData<LakeAppointment>`s.
  ///
  /// This converts appointments to a form used by the calendar library.
  List<CalendarEventData<LakeAppointment>> lakeAppointmentsToEvents(
      List<LakeAppointment> appointments) {
    List<CalendarEventData<LakeAppointment>> out = [];
    for (LakeAppointment app in appointments) {
      CalendarEventData<LakeAppointment> event =
          CalendarEventData<LakeAppointment>(
              title: app.subject!,
              date: app.startTime!,
              startTime: app.startTime!,
              endTime: app.endTime!,
              color: widget.group == null
                  ? app.color!
                  : Theme.of(context).colorScheme.nixonBrown,
              description: app.notes!,
              event: app);
      out.add(event);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: const FlexibleSpaceBar(),
          title: Text(widget.title,
              style: Theme.of(context).textTheme.appBarTitle),
          backgroundColor: Theme.of(context).colorScheme.nixonGreen,
        ),
        body: Row(children: <Widget>[
          Expanded(
              child: Column(children: [
            Consumer<AppState>(
                builder: (BuildContext context, appState, Widget? child) {
              EventController<LakeAppointment> controller =
                  EventController<LakeAppointment>();
              controller.addAll(lakeAppointmentsToEvents(
                  appState.filterAppointments(
                      widget.group == null ? _selectedGroups : [widget.group!],
                      _selectedActivities)));
              return Expanded(
                child: _isDayView
                    ? DayView(
                        initialDay: _focusedDay,
                        onPageChange: onPageChange,
                        eventArranger:
                            const LakeEventArranger<LakeAppointment>(),
                        controller: controller,
                        onDateTap: onTapEmpty(appState),
                        onEventTap: onTapEvent(appState),
                        dateStringBuilder: (DateTime date,
                                {DateTime? secondaryDate}) =>
                            DateFormat('yMMMMEEEEd').format(date),
                        headerStyle: HeaderStyle(
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.background),
                            headerTextStyle:
                                Theme.of(context).textTheme.bodyLarge),
                        scrollOffset: 324,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        heightPerMinute: 0.8)
                    : WeekView(
                        initialDay: _focusedDay,
                        onPageChange: onPageChange,
                        eventArranger:
                            const LakeEventArranger<LakeAppointment>(),
                        controller: controller,
                        onDateTap: onTapEmpty(appState),
                        onEventTap: onTapEvent(appState),
                        headerStringBuilder: (DateTime date,
                            {DateTime? secondaryDate}) {
                          return '${DateFormat('MMMMd').format(date)} to ${DateFormat('yMMMMd').format(secondaryDate!.subtract(const Duration(days: 2)))}';
                        },
                        headerStyle: HeaderStyle(
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).colorScheme.background),
                            headerTextStyle:
                                Theme.of(context).textTheme.bodyLarge),
                        scrollOffset: 324,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        heightPerMinute: 0.8,
                        showWeekends: false,
                      ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.group == null)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.nixonGreen,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
                        constraints:
                            const BoxConstraints(maxHeight: 60, maxWidth: 150),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: MultiSelectDialogField(
                            decoration: const BoxDecoration(),
                            colorator: (Group group) => group.color,
                            title: Text("Filter Groups",
                                style: Theme.of(context).textTheme.bodyLarge),
                            items: createCheckboxGroups(appState.groups),
                            itemsTextStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            selectedItemsTextStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            initialValue: _selectedGroups,
                            chipDisplay: MultiSelectChipDisplay<Group>.none(),
                            buttonIcon: const Icon(Icons.filter_list,
                                color: Colors.white),
                            buttonText: Text('Groups',
                                style:
                                    Theme.of(context).textTheme.appBarFilter),
                            confirmText: Text('Ok',
                                style: Theme.of(context).textTheme.bodyLarge),
                            cancelText: Text('Cancel',
                                style: Theme.of(context).textTheme.bodyLarge),
                            onConfirm: (results) {
                              setState(() {
                                _selectedGroups = results;
                                //assignments[widget.group] = _selectedGroups;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  if (widget.group == null) const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.nixonGreen,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
                      constraints:
                          const BoxConstraints(maxHeight: 60, maxWidth: 150),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: MultiSelectDialogField(
                          decoration: const BoxDecoration(),
                          colorator: (_) =>
                              Theme.of(context).colorScheme.nixonGreen,
                          title: Text("Filter Activities",
                              style: Theme.of(context).textTheme.bodyLarge),
                          items: createCheckboxActivities(appState.activities),
                          itemsTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          selectedItemsTextStyle:
                              Theme.of(context).textTheme.bodyMedium,
                          initialValue: _selectedActivities,
                          chipDisplay: MultiSelectChipDisplay<String>.none(),
                          buttonIcon: const Icon(Icons.filter_list,
                              color: Colors.white),
                          buttonText: Text('Activities',
                              style: Theme.of(context).textTheme.appBarFilter),
                          confirmText: Text('Ok',
                              style: Theme.of(context).textTheme.bodyLarge),
                          cancelText: Text('Cancel',
                              style: Theme.of(context).textTheme.bodyLarge),
                          onConfirm: (results) {
                            setState(() {
                              _selectedActivities = results;
                              //assignments[widget.group] = _selectedGroups;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.nixonGreen,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      constraints: const BoxConstraints(
                          maxHeight: 60,
                          maxWidth: 60,
                          minHeight: 60,
                          minWidth: 60),
                      child: IconButton(
                          color: Colors.white,
                          icon: Icon(_isDayView
                              ? Icons.view_day_outlined
                              : Icons.calendar_view_month),
                          onPressed: () {
                            setState(() {
                              _isDayView = !_isDayView;
                            });
                          })),
                ],
              ),
            ),
          ])),
        ]),
      );
    });
  }
}

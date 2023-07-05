import 'package:final_project/objects/multi_select_dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import 'package:final_project/pages/appointment_editor.dart';
import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/theme.dart';

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

class _CalendarPageState extends State<CalendarPage> {
  _CalendarPageState();

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: const FlexibleSpaceBar(),
          title: Text(widget.group.name,
              style: Theme.of(context).textTheme.appBarTitle),
          backgroundColor: Theme.of(context).colorScheme.nixonGreen,
        ),
        body: Row(children: <Widget>[
          Expanded(
            child: Container(
                color: theme,
                child: Stack(children: [
                  //calendar,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.nixonGreen,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
                            constraints: const BoxConstraints(
                                maxHeight: 60, maxWidth: 150),
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
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.nixonGreen,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 5),
                            constraints: const BoxConstraints(
                                maxHeight: 60, maxWidth: 150),
                            child: MultiSelectDialogField(
                              decoration: const BoxDecoration(),
                              colorator: (_) =>
                                  Theme.of(context).colorScheme.nixonGreen,
                              title: Text("Filter Activities",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              items:
                                  createCheckboxActivities(appState.activities),
                              itemsTextStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              selectedItemsTextStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              initialValue: _selectedActivities,
                              chipDisplay:
                                  MultiSelectChipDisplay<String>.none(),
                              buttonIcon: const Icon(Icons.filter_list,
                                  color: Colors.white),
                              buttonText: Text('Activities',
                                  style:
                                      Theme.of(context).textTheme.appBarFilter),
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
                        ],
                      ),
                    ),
                  ),
                ])),
          ),
        ]),
      );
    });
  }
}

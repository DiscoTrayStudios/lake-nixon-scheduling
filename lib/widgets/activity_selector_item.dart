import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/objects/activity.dart';
import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnPressedCallback = Function(int);
typedef OnDeleteCallback = Function(BuildContext, Activity, AppState);

/// An item used in the activity editor to display individual activities.
///
/// Handles taps on the icon as well as on the delete button. Displays the name,
/// minimum age, and maximum number of groups at all times, and only displays the
/// description when selected.
class ActivitySelectorItem extends StatelessWidget {
  /// An item used in the activity editor to display individual activities.
  ///
  /// Handles taps on the icon as well as on the delete button. Displays the name,
  /// minimum age, and maximum number of groups at all times, and only displays the
  /// description when [this.selected] is true. Takes data from [this.activity].
  ///
  /// [this.onPressed] and [this.onDelete] are the callbacks for tapping the activity
  /// and deleting it.
  const ActivitySelectorItem(
      this.activity, this.selected, this.index, this.onPressed, this.onDelete,
      {super.key});

  final Activity activity;

  final bool selected;

  final int index;

  final OnPressedCallback onPressed;

  final OnDeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Color.lerp(
                  Theme.of(context).colorScheme.nixonBrown, Colors.white, 0.3)!,
              width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(activity.name,
                style: Theme.of(context).textTheme.bodyLarge),
            subtitle: Column(
              children: [
                if (selected)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text('- Age ${activity.ageMin}+'),
                          Text('- No more than ${activity.groupMax} groups'),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(activity.desc),
                          const SizedBox(
                            height: 10,
                          ),
                        ]),
                  ),
                if (selected)
                  Consumer<AppState>(
                      builder: ((BuildContext context, AppState appState, _) {
                    return ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            )),
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.error)),
                        child: Text('Delete',
                            style: Theme.of(context).textTheme.titleLarge),
                        onPressed: () => onDelete(context, activity, appState));
                  }))
              ],
            ),
            onTap: () => onPressed(index),
          ),
        ));
  }
}

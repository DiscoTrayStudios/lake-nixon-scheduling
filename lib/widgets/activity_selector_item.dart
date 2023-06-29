import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/activity.dart';
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
    return ListTile(
      title: Text(activity.name, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Column(
        children: [
          Row(children: [
            Text('Minimum age: ${activity.ageMin}'),
            const Spacer(),
            Text('Maximum # of groups: ${activity.groupMax}'),
            const Spacer(flex: 2)
          ]),
          if (selected)
            Column(children: [
              const SizedBox(
                height: 10,
              ),
              Text(activity.desc),
              const SizedBox(
                height: 10,
              ),
              Consumer<AppState>(
                  builder: ((BuildContext context, AppState appState, _) {
                return ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.error)),
                    child: Text('Delete',
                        style: Theme.of(context).textTheme.titleLarge),
                    onPressed: () => onDelete(context, activity, appState));
              }))
            ])
        ],
      ),
      onTap: () => onPressed(index),
    );
  }
}

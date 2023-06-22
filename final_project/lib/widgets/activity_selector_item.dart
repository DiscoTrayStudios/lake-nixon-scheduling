import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/activity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnPressedCallback = Function(int);
typedef OnDeleteCallback = Function(Activity, AppState);

class ActivitySelectorItem extends StatelessWidget {
  const ActivitySelectorItem(
      this.event, this.selected, this.index, this.onPressed, this.onDelete,
      {super.key});

  final Activity event;

  final bool selected;

  final int index;

  final OnPressedCallback onPressed;

  final OnDeleteCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.name),
      subtitle: Column(
        children: [
          Row(children: [
            Text('Minimum age: ${event.ageMin}'),
            const Spacer(),
            Text('Maximum # of groups: ${event.groupMax}'),
            const Spacer(flex: 2)
          ]),
          if (selected)
            Row(
              children: [
                Text(event.desc),
                const Spacer(),
                Consumer<AppState>(
                    builder: ((BuildContext context, AppState appState, _) {
                  return IconButton(
                      icon: Icon(Icons.delete_forever,
                          color: Theme.of(context).colorScheme.error),
                      onPressed: () => onDelete(event, appState));
                }))
              ],
            )
        ],
      ),
      onTap: () => onPressed(index),
    );
  }
}

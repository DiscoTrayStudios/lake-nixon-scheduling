import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/multi_select_dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GroupSelector extends StatefulWidget {
  const GroupSelector(this.availableGroups, this.selectedGroups, this.onConfirm,
      {super.key});

  final List<Group> availableGroups;

  final List<Group> selectedGroups;

  final OnConfirmCallback onConfirm;

  @override
  State<GroupSelector> createState() => _GroupSelectorState();
}

typedef OnConfirmCallback = Function(List<Group>);

class _GroupSelectorState extends State<GroupSelector> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      //This is where the group select field is
      title: MultiSelectDialogField(
        title: Text("Assign Groups",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                color: Theme.of(context).colorScheme.secondary)),
        buttonText: Text("Assign Groups",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
                color: Theme.of(context).colorScheme.secondary)),
        colorator: (group) => group.color,
        items: createCheckboxGroups(widget.availableGroups),
        initialValue: widget.selectedGroups,
        onConfirm: (results) => widget.onConfirm(results),
      ),
    );
  }
}

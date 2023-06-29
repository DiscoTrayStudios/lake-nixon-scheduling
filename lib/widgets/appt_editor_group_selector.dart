import 'package:final_project/objects/group.dart';
import 'package:final_project/objects/multi_select_dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

// Should be stateless

/// A multi select menu with a chip display to select groups.
///
/// Can take filtered lists of groups, as well as default selections.
class GroupSelector extends StatefulWidget {
  /// A multi select menu with a chip display to select groups.
  ///
  /// [this.availableGroups] should be a list of all groups available in a particular
  /// time range. [this.selectedGroups] are the default group selections, and should
  /// not include groups not in [this.availableGroups]. [this.onConfirm] is the
  /// function callback for updating the selected groups.
  const GroupSelector(this.availableGroups, this.selectedGroups, this.onConfirm,
      {super.key});

  /// The groups available to be selected.
  final List<Group> availableGroups;

  /// The currently selected groups.
  final List<Group> selectedGroups;

  /// A callback triggered when the selected groups are updated.
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
        title:
            Text("Assign Groups", style: Theme.of(context).textTheme.bodyLarge),
        buttonText:
            Text("Assign Groups", style: Theme.of(context).textTheme.bodyLarge),
        colorator: (group) => group.color,
        chipDisplay: MultiSelectChipDisplay<Group>(
            textStyle: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.onPrimary)),
        items: createCheckboxGroups(widget.availableGroups),
        initialValue: widget.selectedGroups,
        onConfirm: (results) => widget.onConfirm(results),
      ),
    );
  }
}

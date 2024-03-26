import 'package:lake_nixon_scheduling/objects/activity.dart';
import 'package:lake_nixon_scheduling/objects/group.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

/// Creates checkboxes for each group in [groups].
List<MultiSelectItem<Group>> createCheckboxGroups(List<Group> groups) {
  var items = groups
      .map((group) =>
          MultiSelectItem<Group>(group, '${group.name} - Age ${group.age}'))
      .toList();
  return items;
}

/// Creates checkboxes for each activity in [activities].
List<MultiSelectItem<String>> createCheckboxActivities(
    List<Activity> activities) {
  var items = activities
      .map((activity) => MultiSelectItem<String>(activity.name, activity.name))
      .toList();
  return items;
}

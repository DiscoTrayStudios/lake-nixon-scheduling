import 'package:final_project/objects/activity.dart';
import 'package:final_project/objects/group.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

List<MultiSelectItem<Group>> createCheckboxGroups(List<Group> groups) {
  var items =
      groups.map((group) => MultiSelectItem<Group>(group, group.name)).toList();
  return items;
}

List<MultiSelectItem<String>> createCheckboxActivities(
    List<Activity> activities) {
  var items = activities
      .map((activity) => MultiSelectItem<String>(activity.name, activity.name))
      .toList();
  return items;
}

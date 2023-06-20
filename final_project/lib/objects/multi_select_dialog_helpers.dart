import 'package:final_project/objects/event.dart';
import 'package:final_project/objects/group.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

List<MultiSelectItem<Group>> createCheckboxGroups(List<Group> groups) {
  var items =
      groups.map((group) => MultiSelectItem<Group>(group, group.name)).toList();
  return items;
}

List<MultiSelectItem<String>> createCheckboxEvents(List<Event> events) {
  var items = events
      .map((event) => MultiSelectItem<String>(event.name, event.name))
      .toList();
  return items;
}

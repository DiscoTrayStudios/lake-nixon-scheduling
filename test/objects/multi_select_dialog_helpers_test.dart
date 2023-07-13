import 'package:final_project/objects/multi_select_dialog_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/objects/activity.dart';
import 'package:final_project/objects/group.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

void main() {
  test('createCheckBoxGroups creates checkboxes for the groups', () {
    List<Group> groups = const [
      Group(age: 10, name: 'Tadpoles', color: Colors.white),
      Group(age: 12, name: 'Froglets', color: Colors.green)
    ];

    List<MultiSelectItem<Group>> groupCheckboxes = createCheckboxGroups(groups);

    expect(groupCheckboxes.length, groups.length);
    expect(groupCheckboxes[0].value, groups[0]);
    expect(groupCheckboxes[1].value, groups[1]);
  });
  test('createCheckBoxActivities creates checkboxes for the activities', () {
    List<Activity> activities = const [
      Activity(name: 'Fishing', ageMin: 5, groupMax: 6, desc: 'Fishing'),
      Activity(
          name: 'Herping', ageMin: 5, groupMax: 6, desc: 'looking for snakes')
    ];

    List<MultiSelectItem<String>> activityCheckboxes =
        createCheckboxActivities(activities);

    expect(activityCheckboxes.length, activities.length);
    expect(activityCheckboxes[0].value, activities[0].name);
    expect(activityCheckboxes[1].value, activities[1].name);
  });
}

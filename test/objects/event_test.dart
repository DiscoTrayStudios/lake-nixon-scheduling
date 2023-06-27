import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/objects/activity.dart';

void main() {
  test('Activity .toString() returns name', () {
    Activity activity = const Activity(
        ageMin: 5, groupMax: 10, name: 'Swimming', desc: "description");

    expect(activity.toString(), 'Swimming');
  });
  test('Schedule class .toString() formatting', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(activityName: 'Swimming', times: timeTable);

    expect(schedule.toString(),
        'Swimming : {1: [Test Group 1, Test Group 2], 3: [Test Group 2, Test Group 4]}');
  });
  test('Schedule getList() returns list length', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(activityName: 'Swimming', times: timeTable);

    expect(schedule.getList('1'), 2);
  });
  test('Schedule getTimes() returns list of groups at that time', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(activityName: 'Swimming', times: timeTable);

    expect(schedule.getTimes('1'), ['Test Group 1', 'Test Group 2']);
  });
  test('Schedule newGroup() sets group at time', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(activityName: 'Swimming', times: timeTable);

    schedule.newGroup('1', 'Test Group 5');

    expect(schedule.getTimes('1'), ['Test Group 5']);
  });
  test('Schedule addGroup adds group to existing time list', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(activityName: 'Swimming', times: timeTable);

    schedule.addGroup('1', 'Test Group 5');

    expect(schedule.getTimes('1'),
        ['Test Group 1', 'Test Group 2', 'Test Group 5']);
  });
}

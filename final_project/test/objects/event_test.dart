import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/objects/event.dart';

void main() {
  test('Event .toString() returns name', () {
    Event event = const Event(
        ageMin: 5, groupMax: 10, name: 'Swimming', desc: "description");

    expect(event.toString(), 'Swimming');
  });
  test('Schedule class .toString() formatting', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(eventName: 'Swimming', times: timeTable);

    expect(schedule.toString(),
        'Swimming : {1: [Test Group 1, Test Group 2], 3: [Test Group 2, Test Group 4]}');
  });
  test('Schedule getList() returns list length', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(eventName: 'Swimming', times: timeTable);

    expect(schedule.getList('1'), 2);
  });
  test('Schedule getTimes() returns list of groups at that time', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(eventName: 'Swimming', times: timeTable);

    expect(schedule.getTimes('1'), ['Test Group 1', 'Test Group 2']);
  });
  test('Schedule newGroup() sets group at time', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(eventName: 'Swimming', times: timeTable);

    schedule.newGroup('1', 'Test Group 5');

    expect(schedule.getTimes('1'), ['Test Group 5']);
  });
  test('Schedule addGroup adds group to existing time list', () {
    Map<String, List<String>> timeTable = {
      '1': ['Test Group 1', 'Test Group 2'],
      '3': ['Test Group 2', 'Test Group 4']
    };

    Schedule schedule = Schedule(eventName: 'Swimming', times: timeTable);

    schedule.addGroup('1', 'Test Group 5');

    expect(schedule.getTimes('1'),
        ['Test Group 1', 'Test Group 2', 'Test Group 5']);
  });
}

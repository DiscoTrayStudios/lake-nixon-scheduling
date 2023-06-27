import 'package:flutter_test/flutter_test.dart';

import 'package:final_project/objects/activity.dart';

void main() {
  test('Activity .toString() returns name', () {
    Activity activity = const Activity(
        ageMin: 5, groupMax: 10, name: 'Swimming', desc: "description");

    expect(activity.toString(), 'Swimming');
  });
}

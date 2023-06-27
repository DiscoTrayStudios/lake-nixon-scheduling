import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';

import 'package:final_project/objects/lake_appointment.dart';

void main() {
  test('LakeAppointment toString formats correctly', () {
    LakeAppointment lappt = LakeAppointment(
        startTime: DateTime.utc(1969, 7, 20, 20),
        endTime: DateTime.utc(1969, 7, 20, 20, 30),
        color: const Color(0xFFFF9000),
        group: 'Test',
        notes: 'Notes',
        subject: 'Swimming');

    expect(lappt.toString(),
        "Start time : 1969-07-20 20:00:00.000Z \n End time : 1969-07-20 20:30:00.000Z \n Color : Color(0xffff9000) \n group : Test \n Subject : Swimming \n");
  });
}

import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../objects/lake_appointment.dart';

void appointmentInfoPopup(
    BuildContext context, LakeAppointment appointment) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          appointment.subject!,
          style: TextStyle(color: Theme.of(context).colorScheme.nixonGreen),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.group!,
                style: Theme.of(context).textTheme.bodyMedium),
            Text(DateFormat('EEE, MMMM d').format(appointment.startTime!),
                style: Theme.of(context).textTheme.bodyMedium),
            Text(
                '${DateFormat('jm').format(appointment.startTime!)} - ${DateFormat('jm').format(appointment.endTime!)}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(
              height: 10,
            ),
            Text(
                Provider.of<AppState>(context)
                    .lookupActivityByName(appointment.subject!)
                    .desc,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )),
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.nixonGreen)),
            onPressed: () {
              Navigator.pop(context);
            },
            child:
                Text('Close', style: Theme.of(context).textTheme.smallButton),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}

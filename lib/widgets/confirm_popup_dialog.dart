import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:flutter/material.dart';

void confirmNavPopup(BuildContext context, String title, String body,
    Future<void> Function(BuildContext context) nav) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.nixonGreen),
        ),
        content: Text(body, style: Theme.of(context).textTheme.bodyMedium),
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                )),
                backgroundColor: MaterialStatePropertyAll<Color>(
                    Theme.of(context).colorScheme.nixonGreen)),
            key: const Key("OKButton"),
            onPressed: () {
              nav(context);
            },
            child: Text('Yes', style: Theme.of(context).textTheme.smallButton),
          ),
          const SizedBox(width: 20),
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
            child: Text('No', style: Theme.of(context).textTheme.smallButton),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}

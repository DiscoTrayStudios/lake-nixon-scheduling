import 'package:flutter/material.dart';

void confirmNavPopup(BuildContext context, String title, String body,
    Future<void> Function(BuildContext context) nav) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        content: Text(body),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          TextButton(
            key: const Key("OKButton"),
            onPressed: () {
              nav(context);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}

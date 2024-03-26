import 'package:lake_nixon_scheduling/objects/app_state.dart';
import 'package:lake_nixon_scheduling/objects/screen_arguments.dart';
import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({Key? key}) : super(key: key);

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  Future<void> masterPush() async {
    await Navigator.pushNamed(context, '/calendarPage',
        arguments: CalendarArguments(
          title: "Master Calendar",
          isUser: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //automaticallyImplyLeading: false,
          title: Text("Master Calendar",
              style: Theme.of(context).textTheme.appBarTitle),
          backgroundColor: Theme.of(context).colorScheme.nixonGreen,
        ),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Calendar Options',
                      style: Theme.of(context).textTheme.pageHeader,
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        )),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.nixonGreen)),
                    child: Text(
                      "View Activities",
                      style: Theme.of(context).textTheme.largeButton,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/activityEditorPage');
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        )),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.nixonGreen)),
                    child: Text("View Calendar",
                        style: Theme.of(context).textTheme.largeButton),
                    onPressed: () {
                      masterPush();
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: ElevatedButton(
                    key: const Key('logOutNavButton'),
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        )),
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.nixonBrown)),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
                      child: Text("Log Out",
                          style: Theme.of(context).textTheme.smallButton),
                    ),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .auth
                          .signOut();
                      Navigator.of(context).pushReplacementNamed('/loginPage');
                    },
                  ),
                )
              ],
            )));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/objects/theme.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Lake Nixon Admin",
                style: Theme.of(context).textTheme.appBarTitle),
            backgroundColor: Theme.of(context).colorScheme.nixonGreen),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text('Admin Options',
                        style: Theme.of(context).textTheme.pageHeader)),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 80,
                      child: ElevatedButton(
                        key: const Key('groupsNavButton'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.nixonGreen)),
                        child: Text("Groups",
                            style: Theme.of(context).textTheme.largeButton),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/groupsPage');
                        },
                      ),
                    )),
                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    key: const Key('masterCalendarNavButton'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.nixonGreen)),
                    child: Text("Master Calendar",
                        style: Theme.of(context).textTheme.largeButton),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/masterPage');
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: ElevatedButton(
                    key: const Key('logOutNavButton'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.nixonBrown)),
                    child: Text("Log Out",
                        style: Theme.of(context).textTheme.smallButton),
                    onPressed: () {
                      Provider.of<AppState>(context, listen: false)
                          .auth
                          .signOut();
                      Navigator.of(context).pushReplacementNamed('/loginPage');
                    },
                  ),
                ),
              ],
            )));
  }
}

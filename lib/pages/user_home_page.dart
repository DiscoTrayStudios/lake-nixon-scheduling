import 'package:final_project/objects/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> groupPagePush() async {
    await Navigator.pushNamed(context, '/groupsPage');
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> logoutScreenPush() async {
    await Navigator.pushReplacementNamed(context, '/loginScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Welcome to Lake Nixon!",
              style: Theme.of(context).textTheme.appBarTitle,
            )),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                const Image(
                  image: AssetImage('images/lakenixonlogo.png'),
                ),
                Container(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 80,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Theme.of(context).colorScheme.nixonGreen)),
                        child: Text(
                          'Select Group',
                          style: Theme.of(context).textTheme.largeButton,
                        ),
                        onPressed: () {
                          groupPagePush();
                        },
                      ),
                    )),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Theme.of(context).colorScheme.nixonBrown)),
                    child: Text(
                      "Logout",
                      style: Theme.of(context).textTheme.smallButton,
                    ),
                    onPressed: () {
                      logout();
                      logoutScreenPush();
                    },
                  ),
                ),
              ],
            )));
  }
}

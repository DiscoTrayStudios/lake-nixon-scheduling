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
    await Navigator.pushReplacementNamed(context, '/loginPage');
  }

  @override
  Widget build(BuildContext context) {
    Size? size = MediaQuery.of(context).size;
    bool isHandset = size.width < 600;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Welcome to Lake Nixon!",
              style: Theme.of(context).textTheme.appBarTitle,
            )),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Flex(
              direction: isHandset ? Axis.vertical : Axis.horizontal,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight:
                        isHandset ? (size.height / 2) - 20 : size.height - 20,
                    maxWidth:
                        isHandset ? size.width - 20 : (size.width / 2) - 20,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: const Image(
                    image: AssetImage('images/lakenixonlogo.png'),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width:
                          isHandset ? size.width - 20 : (size.width / 2) - 20,
                      padding: const EdgeInsets.all(10),
                      height: 80,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            )),
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
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              )),
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
                    ),
                  ],
                ),
              ],
            )));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:final_project/pages/start_page.dart';
import 'package:final_project/pages/user_splash_screen.dart';

class UserSplashScreen extends StatefulWidget {
  const UserSplashScreen({super.key});

  @override
  State<UserSplashScreen> createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  bool admin = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> userPagePush() async {
    await Navigator.pushNamed(context, '/userSplashPage');
    //await Navigator.of(context).push(
    //MaterialPageRoute(builder: (context) => const StartPage()),
    //);
  }

  Future<void> startPagePush() async {
    await Navigator.pushNamed(context, '/startPage');
  }

  void _checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();

    setState(() {
      admin = snap['admin'];
    });

    if (admin) {
      startPagePush();
    } else {
      userPagePush();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: <Widget>[
        Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
            child: Text(
              'Authenticating',
              style: TextStyle(
                  //nixongreen
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                  fontSize:
                      Theme.of(context).textTheme.headlineLarge!.fontSize),
            )),
      ])),
    );
  }
}

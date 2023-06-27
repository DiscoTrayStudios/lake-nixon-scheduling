import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:final_project/pages/admin_home_page.dart';
import 'package:final_project/pages/user_home_page.dart';

class AuthSplashScreen extends StatefulWidget {
  const AuthSplashScreen({super.key});

  @override
  State<AuthSplashScreen> createState() => _AuthSplashScreenState();
}

class _AuthSplashScreenState extends State<AuthSplashScreen> {
  bool admin = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> userPagePush() async {
    await Navigator.pushReplacementNamed(context, '/userSplashPage');
    //await Navigator.of(context).push(
    //MaterialPageRoute(builder: (context) => const StartPage()),
    //);
  }

  Future<void> startPagePush() async {
    await Navigator.pushReplacementNamed(context, '/startPage');
  }

  void _checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();

    admin = snap['admin'];

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

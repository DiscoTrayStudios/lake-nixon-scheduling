import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/objects/app_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _checkAuth(context);
    });
  }

  Future<void> userPagePush() async {
    Navigator.pushReplacementNamed(context, '/userSplashPage');
  }

  Future<void> startPagePush() async {
    await Navigator.pushReplacementNamed(context, '/startPage');
  }

  void _checkAuth(BuildContext context) async {
    User? user = Provider.of<AppState>(context, listen: false).auth.currentUser;

    final DocumentSnapshot snap =
        await Provider.of<AppState>(context, listen: false)
            .firestore
            .collection("users")
            .doc(user?.uid)
            .get();

    try {
      if (snap['admin']) {
        startPagePush();
      } else {
        userPagePush();
      }
    } on StateError catch (_) {
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
              style: Theme.of(context).textTheme.displaySmall,
            )),
      ])),
    );
  }
}

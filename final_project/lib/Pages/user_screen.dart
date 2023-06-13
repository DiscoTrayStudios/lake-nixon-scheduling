import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/Pages/start_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user_splash_screen.dart';

class UserSplashScreen extends StatefulWidget {
  const UserSplashScreen({super.key});

  @override
  State<UserSplashScreen> createState() => _UserSplashScreenState();
}

class _UserSplashScreenState extends State<UserSplashScreen> {
  String role = "user";

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> userPagePush() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
    //await Navigator.of(context).push(
    //MaterialPageRoute(builder: (context) => const StartPage()),
    //);
  }

  Future<void> startPagePush() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const StartPage()),
    );
  }

  void _checkAuth() async {
    User? user = FirebaseAuth.instance.currentUser;

    final DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get();

    setState(() {
      role = snap['role'];
    });

    if (role == 'user') {
      userPagePush();
    } else {
      startPagePush();
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
            child: const Text(
              'Authenticating',
              style: TextStyle(
                  fontFamily: 'Fruit',
                  //nixongreen
                  color: Color.fromRGBO(81, 146, 78, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
      ])),
    );
  }
}

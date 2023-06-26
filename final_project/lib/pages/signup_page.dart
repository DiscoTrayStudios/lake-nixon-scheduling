import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:final_project/pages/login_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    child: const Image(
                        image: AssetImage('images/lakenixonlogo.png'))),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .fontSize),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Theme.of(context).colorScheme.secondary)),
                      child: Text(
                        'Create',
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headlineLarge!
                                .fontSize),
                      ),
                      onPressed: () async {
                        bool success = false;
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                          success = true;
                          User? user = FirebaseAuth.instance.currentUser;

                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(user?.uid)
                              .set({'admin': false});
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            Fluttertoast.showToast(
                                msg: "Password entered is too weak",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                textColor:
                                    Theme.of(context).colorScheme.onError,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize);
                            const Text('The password provided is too weak.');
                          } else if (e.code == 'email-already-in-use') {
                            Fluttertoast.showToast(
                                msg: "An account already exists for that email",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 3,
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                textColor:
                                    Theme.of(context).colorScheme.onError,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .fontSize);
                            const Text(
                                'The account already exists for that email.');
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        }
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<
                                        Color>(
                                    Theme.of(context).colorScheme.tertiary)),
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Back',
                            ))))
              ],
            )));
  }
}

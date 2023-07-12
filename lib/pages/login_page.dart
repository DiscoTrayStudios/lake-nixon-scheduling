import 'package:final_project/objects/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:final_project/objects/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() {
    if (FirebaseAuth.instance.currentUser != null) {
      //groupPagePush();
      Provider.of<AppState>(context, listen: false);
      Navigator.pushReplacementNamed(context, '/authSplashPage');
    }
  }

  Future<void> forgotPassword() async {
    await Navigator.pushNamed(
      context,
      '/forgotPasswordPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isHandset = size.width < 600;
    return Scaffold(
        body: SizedBox(
            width: size.width,
            height: size.height,
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Flex(
                      direction: isHandset ? Axis.vertical : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            constraints: BoxConstraints(
                              maxHeight: isHandset
                                  ? (size.height / 2) - 20
                                  : size.height - 20,
                              maxWidth: isHandset
                                  ? size.width - 20
                                  : (size.width / 2) - 20,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Image(
                                image: AssetImage('images/lakenixonlogo.png'))),
                        Column(
                          children: <Widget>[
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Sign in',
                                  style:
                                      Theme.of(context).textTheme.displaySmall,
                                )),
                            Container(
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                maxWidth: isHandset
                                    ? size.width - 20
                                    : (size.width / 2) - 20,
                              ),
                              child: TextField(
                                controller: emailController,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'E-mail',
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              constraints: BoxConstraints(
                                maxWidth: isHandset
                                    ? size.width - 20
                                    : (size.width / 2) - 20,
                              ),
                              child: TextField(
                                obscureText: true,
                                controller: passwordController,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                forgotPassword();
                              },
                              child: Text('Forgot Password',
                                  style:
                                      Theme.of(context).textTheme.mediumButton),
                            ),
                            Container(
                                width: isHandset
                                    ? size.width - 20
                                    : (size.width / 2) - 20,
                                height: 80,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                      )),
                                      backgroundColor:
                                          MaterialStatePropertyAll<Color>(
                                              Theme.of(context)
                                                  .colorScheme
                                                  .primary)),
                                  child: Text(
                                    'Login',
                                    style:
                                        Theme.of(context).textTheme.largeButton,
                                  ),
                                  onPressed: () async {
                                    try {
                                      await FirebaseAuth.instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        Fluttertoast.showToast(
                                            msg:
                                                "User not found under that email address",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            textColor: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .fontSize);
                                        debugPrint(
                                            'No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        // probably should not say something like this for security
                                        Fluttertoast.showToast(
                                            msg:
                                                "Incorrect password for that email",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .error,
                                            textColor: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .fontSize);
                                        debugPrint(
                                            'Wrong password provided for that user.');
                                      }
                                    }

                                    login();
                                  },
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Need an account?',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                TextButton(
                                  child: Text(
                                    'Sign up',
                                    style: Theme.of(context)
                                        .textTheme
                                        .mediumButton,
                                  ),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, '/signupPage');
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    )))));
  }
}

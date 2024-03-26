import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Flex(
                      direction: isHandset ? Axis.vertical : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            constraints: BoxConstraints(
                              maxHeight: isHandset
                                  ? (size.height / 2) - 60
                                  : size.height - 20,
                              maxWidth: isHandset
                                  ? size.width - 20
                                  : (size.width / 2) - 20,
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(0),
                            child: const Image(
                                image: AssetImage('images/lakenixonlogo.png'))),
                        Column(
                          children: [
                            Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Sign up',
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
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              constraints: BoxConstraints(
                                maxWidth: isHandset
                                    ? size.width - 20
                                    : (size.width / 2) - 20,
                              ),
                              child: TextField(
                                obscureText: true,
                                controller: confirmPasswordController,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Confirm Password',
                                ),
                              ),
                            ),
                            Container(
                                height: 80,
                                width: isHandset
                                    ? size.width - 20
                                    : (size.width / 2) - 20,
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
                                    'Create',
                                    style:
                                        Theme.of(context).textTheme.largeButton,
                                  ),
                                  onPressed: () {
                                    if (confirmPasswordController.text ==
                                        passwordController.text) {
                                      bool success = false;
                                      try {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                        success = true;
                                      } on FirebaseAuthException catch (e) {
                                        if (e.code == 'weak-password') {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Password entered is too weak",
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
                                          const Text(
                                              'The password provided is too weak.');
                                        } else if (e.code ==
                                            'email-already-in-use') {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "An account already exists for that email",
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
                                          const Text(
                                              'The account already exists for that email.');
                                        }
                                      } catch (e) {
                                        debugPrint(e.toString());
                                      }
                                      if (success) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Passwords must match.",
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
                                      const Text('Passwords must match.');
                                    }
                                  },
                                )),
                            Container(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            )),
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .nixonBrown)),
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Back',
                                            style: Theme.of(context)
                                                .textTheme
                                                .smallButton)))),
                          ],
                        )
                      ],
                    )))));
  }
}

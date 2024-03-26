import 'package:lake_nixon_scheduling/objects/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
              children: [
                Container(
                    constraints: BoxConstraints(
                      maxHeight:
                          isHandset ? (size.height / 2) - 20 : size.height - 20,
                      maxWidth:
                          isHandset ? size.width - 20 : (size.width / 2) - 20,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Image(
                        image: AssetImage('images/lakenixonlogo.png'))),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('Forgot Password?',
                          textAlign: TextAlign.right,
                          style: Theme.of(context).textTheme.displaySmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text(
                        'Enter your email below to be sent a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      constraints: BoxConstraints(
                        maxWidth:
                            isHandset ? size.width - 20 : (size.width / 2) - 20,
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: Theme.of(context).textTheme.headlineSmall,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              )),
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Theme.of(context).colorScheme.nixonGreen)),
                          onPressed: () async {
                            if (_emailController.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please enter an email",
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
                            } else if (!_emailController.text.contains("@")) {
                              Fluttertoast.showToast(
                                  msg:
                                      "Please enter an email with proper format",
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
                            } else {
                              try {
                                FirebaseAuth.instance.sendPasswordResetEmail(
                                    email: _emailController.text);

                                debugPrint("Test");
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  Fluttertoast.showToast(
                                      msg:
                                          "User not found under that email address",
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
                                  debugPrint('No user found for that email.');
                                } else if (e.code == 'invalid-email') {
                                  Fluttertoast.showToast(
                                      msg: "Improper email format",
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
                                } else if (e.code == 'internal-error') {
                                  Fluttertoast.showToast(
                                      msg: "Please input in email format",
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
                                }
                              }
                              Fluttertoast.showToast(
                                  msg: "Email sent to reset password",
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
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            "Send",
                            style: Theme.of(context).textTheme.smallButton,
                          ),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                )),
                                backgroundColor: MaterialStatePropertyAll<
                                        Color>(
                                    Theme.of(context).colorScheme.nixonBrown)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Back",
                                style: Theme.of(context).textTheme.smallButton))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '(Note: Also check junk mailbox for link).',
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

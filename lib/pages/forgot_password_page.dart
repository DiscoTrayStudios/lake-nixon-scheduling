import 'package:final_project/objects/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _key = GlobalKey<FormState>();
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
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 50.0, bottom: 25.0),
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0),
                      child: const Image(
                          image: AssetImage('images/lakenixonlogo.png'))),
                  Text('Forgot Password?',
                      textAlign: TextAlign.right,
                      style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your email below to be sent a link to reset your password.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _emailController,
                    style: Theme.of(context).textTheme.headlineSmall,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
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
                            textColor: Theme.of(context).colorScheme.onError,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontSize);
                      } else if (!_emailController.text.contains("@")) {
                        Fluttertoast.showToast(
                            msg: "Please enter an email with proper format",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 3,
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            textColor: Theme.of(context).colorScheme.onError,
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
                                msg: "User not found under that email address",
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
                            textColor: Theme.of(context).colorScheme.onError,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .fontSize);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Submit",
                      style: Theme.of(context).textTheme.smallButton,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '(Note: Also check junk mailbox for link).',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

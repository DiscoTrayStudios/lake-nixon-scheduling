import 'package:final_project/Objects/AppState.dart';
import 'package:final_project/Pages/CalendarPage.dart';
import 'package:final_project/Pages/StartPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Pages/GroupPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:final_project/Pages/LoginPage.dart';

// Initialize firebase and run the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: ((context) => AppState()),
    child: const MyApp(),
  ));
}

// Main app class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // check if user is logged in. If so, send to start page
  // else, send to login screen
  Widget checkLogin() {
    if (FirebaseAuth.instance.currentUser != null) {
      return const StartPage();
      //return GroupPage(title: "List of groups");
    } else {
      return const LoginScreen();
    }
  }

  // builds the app, calling check login to determine what page to use
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: CalendarPage(title: 'Calendar Page'),
        //home: GroupPage(title: "List of groups"),
        home: checkLogin());
  }
}

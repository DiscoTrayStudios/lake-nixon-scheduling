import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/objects/screen_arguments.dart';
import 'package:final_project/pages/activity_editor.dart';
import 'package:final_project/pages/appointment_editor.dart';
import 'package:final_project/pages/appointment_selector.dart';
import 'package:final_project/pages/calendar_page.dart';
import 'package:final_project/pages/forgot_password_page.dart';
import 'package:final_project/pages/master_page.dart';
import 'package:final_project/pages/signup_page.dart';
import 'package:final_project/pages/user_screen.dart';
import 'package:final_project/pages/user_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/pages/start_page.dart';
import 'package:final_project/firebase_options.dart';
import 'package:final_project/pages/login_page.dart';
import 'package:final_project/objects/theme.dart';
import 'package:final_project/pages/group_page.dart';

// Initialize firebase and run the app
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: ((context) =>
        AppState(FirebaseFirestore.instance, FirebaseAuth.instance)),
    child: const MyApp(),
  ));
}

// Main app class
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // check if user is logged in. If so, send to start page
  // else, send to login screen

  // builds the app, calling check login to determine what page to use
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: lakeNixonTheme(),
        //home: CalendarPage(title: 'Calendar Page'),
        //home: GroupPage(title: "List of groups"),
        home: checkLogin(FirebaseAuth.instance),
        routes: {
          '/groupsPage': (context) => const GroupPage(title: 'List of Groups'),
          '/masterPage': (context) => const MasterPage(),
          '/loginPage': (context) => const LoginScreen(),
          '/appointmentEditorPage': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as AppointmentEditorArguments;
            return AppointmentEditor(args.appointment, args.selectedDate);
          },
          '/appointmentSelectorPage': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as AppointmentSelectorArguments;
            return AppointmentSelector(args.selectedDate,
                selectedGroups: args.selectedGroups,
                selectedActivities: args.selectedActivities);
          },
          '/calendarPage': (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as CalendarArguments;
            return CalendarPage(
                title: args.title,
                group: args.group,
                isUser: args.isUser,
                master: args.master);
          },
          '/forgotPasswordPage': (context) => const ForgotPassword(),
          '/authSplashPage': (context) => const UserSplashScreen(),
          '/userSplashPage': (context) => const SplashScreen(),
          '/signupPage': (context) => const SignupScreen(),
          '/activityEditorPage': (context) => ActivityEditor(),
        });
  }
}

Widget checkLogin(auth) {
  if (auth.currentUser != null) {
    return const StartPage();
    //return GroupPage(title: "List of groups");
  } else {
    return const LoginScreen();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/objects/screen_arguments.dart';
import 'package:final_project/pages/activity_editor.dart';
import 'package:final_project/pages/appointment_editor.dart';
import 'package:final_project/pages/appointment_selector.dart';
import 'package:final_project/pages/calendar_page.dart';
import 'package:final_project/pages/forgot_password_page.dart';
import 'package:final_project/pages/master_page.dart';
import 'package:final_project/pages/signup_page.dart';
import 'package:final_project/pages/auth_splash_screen.dart';
import 'package:final_project/pages/user_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:final_project/objects/app_state.dart';
import 'package:final_project/pages/admin_home_page.dart';
import 'package:final_project/firebase_options.dart';
import 'package:final_project/pages/login_page.dart';
import 'package:final_project/objects/theme.dart';
import 'package:final_project/pages/group_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ChangeNotifierProvider(
    create: ((context) =>
        AppState(FirebaseFirestore.instance, FirebaseAuth.instance)),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: lakeNixonTheme(),
        home: checkLogin(Provider.of<AppState>(context).auth),
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
          '/authSplashPage': (context) => const AuthSplashScreen(),
          '/userSplashPage': (context) => const UserHomePage(),
          '/signupPage': (context) => const SignupScreen(),
          '/activityEditorPage': (context) => const ActivityEditor(),
          '/startPage': (context) => const AdminHomePage()
        });
  }
}

Widget checkLogin(FirebaseAuth auth) {
  if (auth.currentUser != null) {
    return const AuthSplashScreen();
  } else {
    return const LoginScreen();
  }
}

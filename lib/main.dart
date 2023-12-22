import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled4/home/Rate.dart';
import 'package:untitled4/tasko/add_project.dart';
import 'package:untitled4/tasko/Navigation%20.dart';
import 'package:untitled4/home/completed.dart';
import 'package:untitled4/home/notcompleted.dart';
import 'package:untitled4/forget.dart';
import 'package:untitled4/Auth/login.dart';
import 'package:untitled4/splash.dart';
import 'package:untitled4/Auth/Register.dart';
import 'package:untitled4/team/team.dart';
import 'package:firebase_core/firebase_core.dart';
import 'onbording.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
// kero125
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, initialRoute: '/', routes: {
      '/': (context) => const splash(),
      "Register": (context) => const Register(),
      "login": (context) => const login(myauth: ''),
      "forgetpass": (context) => const forget(),
      "add": (context) => const AddProject(),
      "home_Page": (context) => const nav(),
      "onbording": (context) => const onbording(),
      "completed": (context) => const completed(),
      "notcompleted": (context) => const notcompleted(),
      "rate": (context) => const MyHomePage(),
      // "task": (context) => const task(),
      "team": (context) => const team(),
      // "taskadd": (context) => const taskadd(),
    });
  }
}

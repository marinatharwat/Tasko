import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled4/team/task_model.dart';

import '../notification_service.dart';
import 'Dashboard.dart';
import 'Notifications.dart';
import 'project.dart';

class nav extends StatefulWidget {
  const nav({Key? key}) : super(key: key);
  @override
  State<nav> createState() => _navState();
}

class _navState extends State<nav> {
  int index = 0;
  final Screens = [
    const Dachboard(),
    const Projects(),
    const Notifications(),
  ];
  @override
  void initState() {
    ProjectTasks.collectionReference.where('userId', arrayContainsAny: [FirebaseAuth.instance.currentUser?.uid]).orderBy('createdAt', descending: true).snapshots().listen((doc) async {
          if (doc.docs.isNotEmpty) {
            print("+++++++++++++++++++++++++");
            final pref = SharedPreferences.getInstance();
            final task = await pref.then((value) => value.getBool(doc.docs.first.id));
            if (task == null || task == false) {
              print("Notification Sent");
              await pref.then((value) => value.setBool(doc.docs.first.id, true));
              await NotificationService().showNotification(doc.docs.first.id.codeUnitAt(index), "New Task", "You have been assigend to new task", DateTime.now(), const Duration(seconds: 4));
            }
          }
          print("-----------------------------");
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(indicatorColor: Colors.blue, labelTextStyle: MaterialStateProperty.all(const TextStyle(fontSize: 14))),
        child: NavigationBar(height: 60, backgroundColor: Colors.white, selectedIndex: index, onDestinationSelected: (index) => setState(() => this.index = index), destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Project'),
          NavigationDestination(icon: Icon(Icons.notifications_active), label: 'Notifications'),
        ]),
      ),
    );
  }
}

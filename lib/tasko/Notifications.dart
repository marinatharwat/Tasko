import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../home/task.dart';
import '../team/task_model.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.blueGrey[100], title: const Text("Notifications", style: TextStyle(color: Colors.black)), centerTitle: true),
      body: FutureBuilder(
        future: ProjectTasks.getAllTasks(FirebaseAuth.instance.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<ProjectTasks> tasks = snapshot.data as List<ProjectTasks>;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                final task = tasks[i];
                return ListTask(task: task);
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

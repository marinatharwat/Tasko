import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/home/task.dart';

import '../team/task_model.dart';

class notcompleted extends StatefulWidget {
  const notcompleted({Key? key}) : super(key: key);

  @override
  State<notcompleted> createState() => _notcompletedState();
}

class _notcompletedState extends State<notcompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 218, 129, 124),
        title: const Text(
          "Not Complete",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ProjectTasks.collectionReference.where("userId", arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid]).where("isCompleted", isEqualTo: false).get(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final List<ProjectTasks> tasks = snapshot.data!.docs.map((doc) => ProjectTasks.fromMap(doc.data() as Map<String, dynamic>)).toList();
            return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, i) {
                  final task = tasks[i];
                  return ListTask(task: task);
                });
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }),
      ),
    );
  }
}

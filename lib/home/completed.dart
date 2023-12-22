import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/home/task.dart';
import 'package:untitled4/team/task_model.dart';

class completed extends StatefulWidget {
  const completed({Key? key}) : super(key: key);

  @override
  State<completed> createState() => _completedState();
}

class _completedState extends State<completed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 124, 218, 140),
        title: const Text(
          "Completed",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ProjectTasks.collectionReference.where("userId", arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid]).where("isCompleted", isEqualTo: true).get(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final List<ProjectTasks> tasks = snapshot.data!.docs.map((doc) => ProjectTasks.fromMap(doc.data() as Map<String, dynamic>)).toList();
            var documents = snapshot.data!.docs;
            for (var i = 0; i < documents.length; i++) {
              print(documents[i].data());
            }
            return ListView.builder(
                itemCount: documents.length,
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

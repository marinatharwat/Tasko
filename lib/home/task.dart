import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import '../curd.task/edittask.dart';
import '../team/task_model.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

List tasks = [];
final fireStore = FirebaseFirestore.instance;
final projectsref = FirebaseFirestore.instance.collection("project").snapshots();
@override
CollectionReference tasksref = FirebaseFirestore.instance.collection("project").doc('1JTVeC4WfvQSNGrzq5ou').collection('tasks');

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 198, 233, 255),
        title: const Text(
          "Tasks",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ProjectTasks.collectionReference.where("userId", arrayContainsAny: [FirebaseAuth.instance.currentUser!.uid]).get(),
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

delete() {
  return Container(
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    color: Colors.red,
    child: const Icon(
      Icons.delete,
      color: Colors.white,
    ),
  );
}

class ListTask extends StatefulWidget {
  ProjectTasks task;

  ListTask({super.key, required this.task});

  @override
  State<ListTask> createState() => _ListTaskState();
}

class _ListTaskState extends State<ListTask> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: widget.task.isCompleted,
        onChanged: (value) async {
          setState(() {
            widget.task.isCompleted = value!;
          });
          await widget.task.save().showCustomProgressDialog(context);
        },
        title: Text(widget.task.title, style: const TextStyle(fontSize: 20)),
        isThreeLine: true,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.note,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Start at: ",
                  style: TextStyle(fontSize: 15, color: Colors.green),
                ),
                Text(
                  DateFormat.yMd().format(widget.task.startTime),
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "End at: ",
                  style: TextStyle(fontSize: 15, color: Colors.red),
                ),
                Text(
                  DateFormat.yMd().format(widget.task.endTime),
                  style: const TextStyle(fontSize: 15),
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

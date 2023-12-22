// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled4/home/task.dart';
import '../curd.task/edittask.dart';
import '../tasko/project_model.dart';
import '../team/task_model.dart';

class ProjectView extends StatefulWidget {
  final Project project;
  const ProjectView({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed("home_Page");
          },
        ),
        title: const Text("view project", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "project title :",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(widget.project.title, style: Theme.of(context).textTheme.headlineSmall),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Note:",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(widget.project.note, style: Theme.of(context).textTheme.headlineSmall),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "Start Date:",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(DateFormat('yyyy-MM-dd').format(widget.project.startDate!), style: Theme.of(context).textTheme.headline5),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Text(
                    "End Date:",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(DateFormat('yyyy-MM-dd').format(widget.project.dueDate!), style: Theme.of(context).textTheme.headlineSmall),
                ],
              )),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder<QuerySnapshot>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final tasks = snapshot.data!.docs.map((e) => ProjectTasks.fromMap(e.data() as Map<String, dynamic>)).toList();
                if (tasks.isEmpty) {
                  return const Center(child: Text("No Task"));
                }
                return ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      if (task.userId.contains(FirebaseAuth.instance.currentUser!.uid)) {
                        return ListTask(task: task);
                      } else {
                        return CheckboxListTile(value: task.isCompleted, onChanged: null, title: Text(task.title));
                      }
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
            future: ProjectTasks.collectionReference.where("projectId", isEqualTo: widget.project.id).get(),
          ),
          if (widget.project.userid == FirebaseAuth.instance.currentUser!.uid)
            Center(
              child: Column(children: [
                ElevatedButton(
                    onPressed: () async {
                      final tasks = await widget.project.getTasks();
                      if (tasks.isEmpty || tasks.every((element) => element.isCompleted == true)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("The project is done"),
                        ));
                        Navigator.of(context).pushNamed("home_Page");
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("You can't delete this project because it has uncompleted tasks"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Ok"))
                                ],
                              );
                            });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text("Done project")),
              ]),
            ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/team/task_model.dart';

import '../curd/projectEdit.dart';
import '../curd/viewproject.dart';
import 'project_model.dart';

class Projects extends StatefulWidget {
  const Projects({Key? key}) : super(key: key);

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  Future<List<Project>> getProjects() async {
    final documents = Project.collection.where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
    List<Project> projects = (await documents).docs.map((doc) => Project.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    final secondProject = await ProjectTasks.getAllProjects(FirebaseAuth.instance.currentUser!.uid);
    final addedIds = <String>{};
    for (final project in projects) {
      addedIds.add(project.id);
    }
    for (final project in secondProject) {
      if (!addedIds.contains(project.id)) {
        projects.add(project);
        addedIds.add(project.id);
      }
    }
    return projects;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 244, 244, 168),
          elevation: 0,
          title: const Text(
            'Project',
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          centerTitle: true),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("add");
        },
      ),
      body: FutureBuilder(
        future: getProjects(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            final List<Project> projects = snapshot.data as List<Project>;
            return ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, i) {
                  final project = projects[i];
                  if (project.userid == FirebaseAuth.instance.currentUser?.uid) {
                    return Dismissible(
                        background: const Card(
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (diretion) async {
                          await project.delete();
                        },
                        key: UniqueKey(),
                        child: listproject(project: project));
                  }
                  return listproject(project: project);
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

class listproject extends StatelessWidget {
  final Project project;
  listproject({required this.project});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return ProjectView(
            project: project,
          );
        }));
      }),
      child: Card(
        child: ListTile(
          title: Text(project.title),
          trailing: (project.userid == FirebaseAuth.instance.currentUser?.uid)
              ? IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                      return editproject(project: project);
                    }));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 47, 176, 60),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

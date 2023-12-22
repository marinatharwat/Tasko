import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../curd.task/edittask.dart';
import '../tasko/project_model.dart';
import '../team/task_model.dart';
import '../team/taskadd.dart';

class editproject extends StatefulWidget {
  Project project;
  editproject({Key? key, required this.project}) : super(key: key);

  @override
  State<editproject> createState() => _editprojectState();
}

class _editprojectState extends State<editproject> {
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("home_Page");
              },
            ),
            title: const Text("Edit project", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Form(
              key: formstate,
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 230),
                    child: const Text("Project Title", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 2.5, left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: widget.project.title,
                              onChanged: (val) {
                                widget.project.title = val;
                              },
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter tittle';
                                }
                              }),
                              decoration: InputDecoration(contentPadding: const EdgeInsets.only(left: 10), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 250),
                    child: const Text("Note", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 2.5, left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            initialValue: widget.project.note,
                            onChanged: (val) {
                              widget.project.note = val;
                            },
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Note';
                              }
                              return null;
                            }),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            minLines: 2,
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            autofocus: false,
                          ))
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 230),
                    child: const Text("Start Date", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: DateFormat("dd-MM-yyyy").format(widget.project.startDate ?? DateTime.now()),
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter start data';
                                }
                                return null;
                              }),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.calendar_today),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickeDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
                                if (pickeDate != null) {
                                  setState(() {
                                    widget.project.startDate = pickeDate;
                                  });
                                } else {
                                  print("not selected");
                                }
                              },
                            ),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 230),
                    child: const Text("Due Data", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextFormField(
                            initialValue: DateFormat("dd-MM-yyyy").format(widget.project.dueDate ?? DateTime.now()),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Due data';
                              }
                              return null;
                            }),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.calendar_today),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickeDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2101));
                              if (pickeDate != null) {
                                setState(() {
                                  widget.project.dueDate = pickeDate;
                                });
                              } else {
                                print("not selected");
                              }
                            },
                          ))
                        ],
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add Task", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => taskadd(project: widget.project)));
                          },
                          icon: const Icon(Icons.add)),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  FutureBuilder<QuerySnapshot>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final tasks = snapshot.data!.docs.map((e) => ProjectTasks.fromMap(e.data() as Map<String, dynamic>)).toList();
                        if (tasks.isEmpty) {
                          return const Center(child: Text("No Task"));
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              final task = tasks[index];
                              return ListTile(
                                title: Text(task.title),
                                subtitle: Text(task.note),
                                trailing: IconButton(
                                  onPressed: () {
                                    setState(() async {
                                      await task.delete();
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => taskedit(
                                            task: task,
                                            project: widget.project,
                                          )));
                                },
                              );
                            });
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                    future: ProjectTasks.collectionReference.where("projectId", isEqualTo: widget.project.id).get(),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 200, top: 2),
                    child: Column(children: [
                      ElevatedButton(
                          onPressed: () async {
                            await widget.project.save();
                          },
                          child: const Text("Edit project"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          )),
                    ]),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

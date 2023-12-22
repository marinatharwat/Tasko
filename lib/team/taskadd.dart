import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:untitled4/tasko/project.dart';
import 'package:untitled4/tasko/project_model.dart';
import 'package:untitled4/team/task_model.dart';
import 'package:uuid/uuid.dart';

class taskadd extends StatefulWidget {
  Project project;
  taskadd({super.key, required this.project});

  @override
  State<taskadd> createState() => _taskaddState();
}

class _taskaddState extends State<taskadd> {
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();

  ProjectTasks task = ProjectTasks(id: const Uuid().v1(), projectId: '', title: '', createdAt: DateTime.now(), isCompleted: false, note: '', startTime: DateTime.now(), endTime: DateTime.now(), userId: []);
  final format = DateFormat('yyyy-MM-dd');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Task", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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
                  child: const Text("Task Title", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 2.5, left: 5, right: 5),
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (val) {
                              task.title = val;
                            },
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter tittle';
                              }
                              return null;
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
                          onChanged: (val) {
                            task.note = val;
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
                  child: const Text("start Time", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2.5, left: 5, right: 5),
                  padding: const EdgeInsets.only(left: 10),
                  child: DateTimeField(
                      validator: ((value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'Please enter a Start time';
                        }
                        return null;
                      }),
                      format: format,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(Icons.schedule),
                      ),
                      onShowPicker: (context, currentValue) async {
                        final time = await showDatePicker(context: context, initialDate: currentValue ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                        task.startTime = time!;
                        return time;
                      }), //DateTimeField
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 230),
                  child: const Text("End Time", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2.5, left: 5, right: 5),
                  padding: const EdgeInsets.only(left: 10),
                  child: DateTimeField(
                      validator: ((value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'Please enter a End time';
                        }
                        return null;
                      }),
                      format: format,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: const Icon(Icons.schedule),
                      ),
                      onShowPicker: (context, currentValue) async {
                        final time = await showDatePicker(context: context, initialDate: currentValue ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime(2100));
                        task.endTime = time!;
                        return time;
                      }), //DateTimeField
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: const EdgeInsets.only(right: 230),
                  child: const Text("Add member", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
                    padding: const EdgeInsets.only(left: 10),
                    child: FutureBuilder(
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                for (var user in snapshot.data!.docs.where((element) => task.userId.contains(element.id)))
                                  ListTile(
                                    title: Text(user["name"]),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        setState(() {
                                          task.userId.remove(user.id);
                                        });
                                      },
                                    ),
                                  ),
                                DropdownButtonFormField(
                                  validator: ((value) {
                                    if (task.userId.isEmpty) {
                                      return 'Please enter a member';
                                    }
                                    return null;
                                  }),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                    hintText: "Select Member",
                                  ),
                                  items: [
                                    for (var user in snapshot.data!.docs)
                                      DropdownMenuItem(
                                        value: user.id,
                                        child: Text(user["name"]),
                                      ),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      setState(() {
                                        print(val.toString());
                                        task.userId.add(val.toString());
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                        future: FirebaseFirestore.instance.collection("users").get())),
                const SizedBox(
                  height: 60,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 200, top: 2),
                  child: Column(children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (formstate.currentState!.validate()) {
                            task.projectId = widget.project.id;
                            if (!widget.project.tasks.contains(task.id)) {
                              widget.project.tasks.add(task.id);
                            }
                            Future.wait([task.save(), widget.project.save()]).showCustomProgressDialog(context).then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Projects())));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        child: const Text("create Task")),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}

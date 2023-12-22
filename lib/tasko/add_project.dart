import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:untitled4/tasko/project_model.dart';
import 'package:untitled4/team/taskadd.dart';
import 'package:uuid/uuid.dart';

class AddProject extends StatefulWidget {
  const AddProject({Key? key}) : super(key: key);

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  CollectionReference projectsref = FirebaseFirestore.instance.collection("project");
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController startController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  Project project = Project(
    id: const Uuid().v4(),
    title: '',
    note: "",
    dueDate: DateTime.now(),
    startDate: DateTime.now(),
    tasks: [],
    userid: FirebaseAuth.instance.currentUser!.uid,
  );
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
            title: const Text("New Project", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          body: SingleChildScrollView(
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
                              onChanged: (val) {
                                project.title = val;
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
                            onChanged: (val) {
                              project.note = val;
                            },
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Note';
                              }
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
                              controller: startController,
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter start data';
                                }
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
                                    project.startDate = pickeDate;
                                    startController.text = DateFormat.yMd().format(project.startDate!);
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
                            controller: dueController,
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
                                  project.dueDate = pickeDate;
                                  dueController.text = DateFormat.yMd().format(pickeDate);
                                });
                              } else {
                                print("not selected");
                              }
                            },
                          ))
                        ],
                      )),
                  const SizedBox(height: 30),
                  Container(
                    margin: const EdgeInsets.only(left: 200, top: 2),
                    child: Column(children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (formstate.currentState!.validate()) {
                              await project.save().showCustomProgressDialog(context).then((value) => Navigator.of(context).push(MaterialPageRoute(builder: (context) => taskadd(project: project))));
                            } else {
                              print("not valid");
                            }
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                          child: const Text("create project")),
                    ]),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

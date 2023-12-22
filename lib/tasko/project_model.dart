import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../team/task_model.dart';

class Project {
  String id;
  String userid;
  String title;
  String note;
  DateTime? startDate;
  DateTime? dueDate;
  List<String> tasks;

  Project({
    required this.id,
    required this.userid,
    required this.title,
    required this.note,
    required this.startDate,
    required this.dueDate,
    required this.tasks,
  });

  static CollectionReference collection = FirebaseFirestore.instance.collection("project");

  factory Project.fromMap(Map<dynamic, dynamic> data, String documentId) {
    return Project(
      id: data['id'] ?? documentId,
      userid: data['userid'],
      title: data['title'],
      note: data['note'],
      startDate: DateFormat('yyyy-MM-dd').parse(data['startDate'] ?? DateTime.now().toString()),
      dueDate: DateFormat('yyyy-MM-dd').parse(data['dueDate'] ?? DateTime.now().toString()),
      tasks: List<String>.from(data['tasks'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userid': userid,
      'title': title,
      'note': note,
      'startDate': startDate.toString(),
      'dueDate': dueDate.toString(),
      'tasks': tasks,
    };
  }

  Future save() async {
    return await collection.doc(id).set(toMap());
  }

  Future delete() async {
    return await collection.doc(id).delete();
  }

  Future<List<ProjectTasks>> getTasks() async {
    final documents = ProjectTasks.collectionReference.where('projectId', isEqualTo: id).get();
    return (await documents).docs.map((doc) => ProjectTasks.fromMap(doc.data() as Map<dynamic, dynamic>)).toList();
  }

  static Future<List<Project>> getAllProjects(List projectsId) async {
    final documents = await collection.where('id', whereIn: projectsId).get();
    return documents.docs.map((doc) => Project.fromMap(doc.data() as Map<dynamic, dynamic>, doc.id)).toList();
  }
}

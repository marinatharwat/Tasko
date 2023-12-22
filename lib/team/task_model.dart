import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled4/tasko/project_model.dart';

class ProjectTasks {
  String id;
  String projectId;
  String title;
  String note;
  bool isCompleted;
  DateTime startTime;
  DateTime createdAt;
  DateTime endTime;
  List<String> userId;
  ProjectTasks({
    required this.id,
    required this.title,
    required this.note,
    required this.isCompleted,
    required this.startTime,
    required this.endTime,
    required this.projectId,
    required this.createdAt,
    required this.userId,
  });
  static CollectionReference collectionReference = FirebaseFirestore.instance.collection("tasks");
  factory ProjectTasks.fromMap(Map<dynamic, dynamic> data) {
    return ProjectTasks(
      id: data['id'],
      title: data['title'],
      isCompleted: data['isCompleted'],
      note: data['note'],
      startTime: data['startTime'].toDate(),
      endTime: data['endTime'].toDate(),
      createdAt: data['createdAt'].toDate(),
      projectId: data['projectId'],
      userId: data['userId'].cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isCompleted': isCompleted,
      'title': title,
      'note': note,
      'startTime': startTime,
      'endTime': endTime,
      'createdAt': createdAt,
      'projectId': projectId,
      'userId': userId,
    };
  }

  Future<void> save() async {
    return collectionReference.doc(id).set(toMap());
  }

  Future delete() async {
    return collectionReference.doc(id).delete();
  }

  //  get all tasks related to this user
  static Future<List<ProjectTasks>> getAllTasks(String userId) async {
    QuerySnapshot querySnapshot = await collectionReference.where('userId', arrayContainsAny: [userId]).orderBy('createdAt', descending: true).get();
    List<ProjectTasks> tasks = querySnapshot.docs.map((e) => ProjectTasks.fromMap(e.data() as Map<String, dynamic>)).toList();
    return tasks;
  }

  // get all prjects related to tasks of this user
  static Future<List<Project>> getAllProjects(String userId) async {
    final tasks = await getAllTasks(userId);
    final projectsId = tasks.map((e) => e.projectId).toSet().toList();
    List<Project> projects = projectsId.isNotEmpty ? await Project.getAllProjects(projectsId) : [];
    return projects;
  }
}

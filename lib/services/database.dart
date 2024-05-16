import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';

class DatabaseService {

  // collection reference
  final CollectionReference taskCollection = FirebaseFirestore.instance.collection('tasks');

  Future<void> createTask(Task task) async {
    await taskCollection.add({
      'title': task.title,
      'description': task.description,
      'category': task.category,
      'priority': task.priority,
    });
  }
  Future<void> updateTask(Task task) async {
    await taskCollection.doc(task.id).update({
      'title': task.title,
      'description': task.description,
      'category': task.category,
      'priority': task.priority,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await taskCollection.doc(taskId).delete();
  }

  Stream<List<Task>> getTasks() {
    return taskCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Task(
      id: doc.id,
      title: doc['title'],
      description: doc['description'],
      category: doc['category'],
      priority: doc['priority'],
    ))
        .toList());
  }
}
// import 'package:flutter/material.dart';
// import '../models/task.dart';
// import 'database.dart';
//
// class TaskProvider with ChangeNotifier {
//   List<Task> _tasks = [];
//   final DatabaseService _databaseService = DatabaseService();
//
//   TaskProvider() {
//     _fetchTasks();
//   }
//
//   List<Task> get tasks => _tasks;
//
//   Future<void> _fetchTasks() async {
//     final List<Task> fetchedTasks = await _databaseService.getTasks().first;
//     _tasks = fetchedTasks;
//     notifyListeners();
//   }
//
//   Future<void> createTask(Task task) async {
//     await _databaseService.createTask(task);
//     _fetchTasks();
//   }
//
//   Future<void> updateTask(Task task) async {
//     await _databaseService.updateTask(task);
//     _fetchTasks();
//   }
//
//   Future<void> deleteTask(String taskId) async {
//     await _databaseService.deleteTask(taskId);
//     _fetchTasks();
//   }
// }

//task_provider.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import 'database.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  Stream<List<Task>> get tasks => _databaseService.getTasks();

  Future<void> createTask(Task task) async {
    await _databaseService.createTask(task);
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    await _databaseService.deleteTask(taskId);
  }
}

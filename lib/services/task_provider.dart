import 'package:flutter/material.dart';
import '../models/task.dart';
import 'database.dart';

class TaskProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  Stream<List<Task>> getTasks(String userID) {
    return _databaseService.getTasks(userID);
  }

  Future<void> createTask(Task task, String userID) async {
    await _databaseService.createTask(task, userID);
  }

  Future<void> updateTask(Task task) async {
    await _databaseService.updateTask(task);
  }

  Future<void> deleteTask(String taskId) async {
    await _databaseService.deleteTask(taskId);
  }
}

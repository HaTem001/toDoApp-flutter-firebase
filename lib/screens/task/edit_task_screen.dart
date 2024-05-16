import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/services/task_provider.dart';
import '../../models/user.dart';

class EditTaskScreen extends StatefulWidget {
  final Task? task;

  EditTaskScreen({this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _category;
  late String _priority;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _category = widget.task!.category;
      _priority = widget.task!.priority;
      _deadline = widget.task!.deadline ?? DateTime.now();
    } else {
      _title = '';
      _description = '';
      _category = 'Work';
      _priority = 'High';
      _deadline = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              initialValue: _title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              initialValue: _description,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              onSaved: (value) => _description = value!,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Category'),
              value: _category,
              items: <String>['Work', 'Personal', 'Others']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => _category = value!,
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Priority'),
              value: _priority,
              items: <String>['High', 'Medium', 'Low']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) => _priority = value!,
            ),

            ListTile(
              title: Text('Deadline'),
              subtitle: Text(_deadline.toString()),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _deadline,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != _deadline)
                  setState(() {
                    _deadline = picked;
                  });
              },
            ),
            ListTile(
              title: Text('Time'),
              subtitle: Text(_deadline.toString()),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_deadline),
                );
                if (picked != null) {
                  setState(() {
                    _deadline = DateTime(
                      _deadline.year,
                      _deadline.month,
                      _deadline.day,
                      picked.hour,
                      picked.minute,
                    );
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final Task newTask = Task(
                    id: widget.task?.id ?? '', // Use existing task ID if editing
                    title: _title,
                    description: _description,
                    category: _category,
                    priority: _priority,
                    deadline: _deadline, // Assign the selected deadline
                    userID: Provider.of<User?>(context, listen: false)!.uid,
                  );
                  final userID = Provider.of<User?>(context, listen: false)!.uid;
                  if (widget.task == null) {
                    // Create task if task is null (no existing task)
                    Provider.of<TaskProvider>(context, listen: false)
                        .createTask(newTask, userID);
                  } else {
                    // Update task if task is not null (editing existing task)
                    Provider.of<TaskProvider>(context, listen: false)
                        .updateTask(newTask);
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(widget.task == null ? 'Save' : 'Update'), // Change button text based on task existence
            ),
          ],
        ),
      ),
    );
  }
}
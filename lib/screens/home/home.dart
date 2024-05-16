import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/services/task_provider.dart';
import '../task/edit_task_screen.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark background color
      appBar: AppBar(
        title: const Text('ToDo', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[850], // Dark AppBar color
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person,color: Colors.white),
            label: const Text('logout', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: Provider.of<TaskProvider>(context).getTasks(user!.uid), // Pass user's ID to getTasks
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)); // White text color
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tasks available.', style: TextStyle(color: Colors.white)), // White text color
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card( // Use Card for better visibility
                  color: Colors.grey[800], // Dark Card color
                  child: ListTile(
                    title: Text(snapshot.data![index].title, style: TextStyle(color: Colors.white,fontSize: 19)), // White text color
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data![index].description, style: TextStyle(color: Colors.white24)), // White text color
                        Text('Deadline: ${snapshot.data![index].deadline}', style: TextStyle(color: Colors.white24)), // Display deadline
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white), // White icon color
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTaskScreen(task: snapshot.data![index]),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.check, color: Colors.white), // White icon color
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Delete'),
                                  content: const Text('Are you sure you want to delete this task?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        Provider.of<TaskProvider>(context, listen: false)
                                            .deleteTask(snapshot.data![index].id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditTaskScreen()),
          );
        },
        backgroundColor: Colors.white70, // Color that stands out in dark mode
        child: const Icon(Icons.add),
      ),
    );
  }
}
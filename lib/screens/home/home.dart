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
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: const Text('TO DO App'),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('logout'),
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
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No tasks available.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(snapshot.data![index].description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
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
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Provider.of<TaskProvider>(context, listen: false)
                              .deleteTask(snapshot.data![index].id);
                        },
                      ),
                    ],
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

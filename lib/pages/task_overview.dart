import 'dart:async';

import 'package:flutter/material.dart';
import '../utilities/database_helper.dart';

class TaskOverview extends StatefulWidget {
  const TaskOverview({super.key});

  @override
  State<TaskOverview> createState() => _TaskOverviewState();
}

class _TaskOverviewState extends State<TaskOverview> {
  final dbHelper = DatabaseHelper();

  Future<List<Map<String, dynamic>>> _tasks() {
    return dbHelper.queryAllTasks();
  }

  void _setTaskStatus(dynamic row, bool completed) {
    dbHelper.updateTask(
      Map<String, dynamic>.from({'id': row['id'], 'isDone': completed ? 1 : 0}),
    );
  }

  Future<SnackBar> _deleteTask(dynamic row) async {

    int deletedRows = await dbHelper.deleteTask(row['id']);

    if (deletedRows == 1){
      return SnackBar(
        content: Text("Successfully deleted row"),
        backgroundColor: Colors.green,
      );
    } else {
      return SnackBar(
        content: Text("Failed to delete row"),
        backgroundColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _tasks(),
          builder:
              (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot,) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("An Error has occurred: ${snapshot.error}"),
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              final tasksList = snapshot.data!;
              if (tasksList.isEmpty) {
                return Center(child: Text("No tasks yet"));
              } else {
                return ListView.builder(
                  itemCount: tasksList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final task = tasksList[index];
                    final title = task['title'] as String? ?? 'No Title';
                    final description =
                        task['description'] as String? ?? 'No Description';
                    bool isCompleted = (task['isDone'] as int?) == 1;
                    return ListTile(
                      title: Text(title),
                      subtitle: Text(description),
                      leading: Checkbox(
                        value: isCompleted,
                        onChanged: (bool? value) {
                          setState(() {
                            isCompleted = value!;
                            _setTaskStatus(task, isCompleted);
                          });
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Handle edit action
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteTask(task);
                              setState(() {});
                              // Handle delete action
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(child: Text("No tasks yet"));
            }
          },
        )
    );
  }
}

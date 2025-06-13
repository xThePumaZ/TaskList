import 'dart:async';
import 'dart:math';

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

    if (deletedRows == 1) {
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
            (
              BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot,
            ) {
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
                      return ExpansionTile(
                        title: Text("${title} fällig am: "),
                        children: <Widget>[
                          Card(
                            margin: EdgeInsetsDirectional.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  if (description.isNotEmpty)
                                    SelectableText(
                                      description,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  if (description.isNotEmpty)
                                    SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextButton.icon(
                                            onPressed: () {
                                              _setTaskStatus(task, true);
                                              setState(() {});
                                            },
                                            label: Text("Done"),
                                            icon: Icon(Icons.check),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.green,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          TextButton.icon(
                                            onPressed: () {},
                                            label: Text("Edit"),
                                            icon: Icon(Icons.edit),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          _deleteTask(task);
                                          setState(() {});
                                        },
                                        label: Text("Delete"),
                                        icon: Icon(Icons.delete),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                return Center(child: Text("No tasks yet"));
              }
            },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'models/tasks_model.dart';
import 'utilities/database_helper.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  Future<void> _addTask() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.database;


    dbHelper.insertTask(Map<String, dynamic>.from({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'isDone': false,
    }));

    // dbHelper.insertTask(Tasks(
    //   title: _titleController.text,
    //   description: _descriptionController.text,
    //   isDone: false
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.amber, title: Text("Add Task")),

      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(hintText: "Title"),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a Title";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  label: const Text("Task"),
                  labelStyle: const TextStyle(fontSize: 20),
                ),
                maxLines: 10,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _addTask();
                }
              },
              child: const Text("Add Task"),
            ),
          ],
        ),
      ),
    );
  }
}

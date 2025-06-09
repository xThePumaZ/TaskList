import 'package:flutter/material.dart';
import '../utilities/database_helper.dart';

class AddTask extends StatefulWidget {
  final VoidCallback navigateToHome;

  const AddTask({super.key, required this.navigateToHome});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  void _addTask() {
    final dbHelper = DatabaseHelper();
    dbHelper.database;

    dbHelper.insertTask(Map<String, dynamic>.from({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'isDone': false,
    }));

    _titleController.text = '';
    _descriptionController.text = '';

    widget.navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Enter a Title",
                  labelText: "Title",
                  filled: true,
                ),
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
              child: TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Enter a Description",
                  labelText: 'Description'
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a Description";
                  }
                  return null;
                },
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

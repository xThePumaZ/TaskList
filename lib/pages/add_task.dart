// add_task.dart
import 'package:flutter/material.dart';
import 'package:task_list/utilities/database_helper.dart'; // Ensure this path is correct

class AddTask extends StatefulWidget {
  final VoidCallback navigateToHome;

  const AddTask({super.key, required this.navigateToHome});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FocusNode _descriptionFocusNode = FocusNode(); // For focusing next field

  final dbHelper = DatabaseHelper();
  bool _isSaving = false; // To show loading indicator on button

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submitTask() async {
    if (_formKey.currentState!.validate() && !_isSaving) {
      setState(() {
        _isSaving = true; // Start loading
      });

      // No need for _formKey.currentState!.save() if using controllers
      // final title = _titleController.text;
      // final description = _descriptionController.text;

      await dbHelper.insertTask({
        'title': _titleController.text,
        'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null, // Store null if empty
        'isDone': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${_titleController.text}" added!'),
            backgroundColor: Colors.green,
          ),
        );
        _titleController.clear();
        _descriptionController.clear();
        widget.navigateToHome();
      }
    }
    // Ensure _isSaving is reset even if validation fails or save is quick
    if(mounted){
      setState(() {
        _isSaving = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access theme for consistent styling

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Task"),
        elevation: 1, // Subtle shadow for AppBar
      ),
      body: SingleChildScrollView( // Allows scrolling if content overflows
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Title Field
              TextFormField(
                controller: _titleController,
                autofocus: true, // Automatically focus title field
                decoration: InputDecoration(
                  labelText: "Task Title",
                  hintText: "What do you need to do?",
                  prefixIcon: Icon(Icons.title, color: theme.colorScheme.primary),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter a title for your task.";
                  }
                  return null;
                },
                textInputAction: TextInputAction.next, // Next action on keyboard
                onFieldSubmitted: (_) {
                  // Move focus to description when 'next' is pressed
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
              ),

              const SizedBox(height: 24),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  labelText: "Description (Optional)",
                  hintText: "Add more details about your task...",
                  prefixIcon: Icon(Icons.description_outlined, color: theme.colorScheme.secondary),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  // helperText: "Keep it brief or detailed as you need.",
                  alignLabelWithHint: true, // Good for multi-line fields
                ),
                maxLines: 4, // Allow multiple lines for description
                minLines: 2,
                textInputAction: TextInputAction.done, // Done action on keyboard
                // No validator, as it's optional
              ),

              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                icon: _isSaving
                    ? Container( // Show loading indicator
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onPrimary,
                    strokeWidth: 3,
                  ),
                )
                    : Icon(Icons.save_alt_outlined, color: theme.colorScheme.onPrimary),
                label: Text(
                  _isSaving ? 'Saving...' : 'Save Task',
                  style: TextStyle(fontSize: 16, color: theme.colorScheme.onPrimary),
                ),
                onPressed: _isSaving ? null : _submitTask, // Disable button when saving
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary, // Use primary color
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 2, // Subtle shadow for button
                ),
              ),

              const SizedBox(height: 16), // Extra space at the bottom

            ],
          ),
        ),
      ),
    );
  }
}
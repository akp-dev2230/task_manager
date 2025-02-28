import 'package:flutter/material.dart';
import 'package:task_manager/task.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String _taskName = '';
  DateTime? _dueDate;
  String _priority = 'Medium';

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task Name (required).
              TextFormField(
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) => value == null || value.isEmpty ? 'Enter task name' : null,
                onSaved: (value) => _taskName = value!,
              ),
              // Due Date picker.
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _dueDate == null
                          ? 'No due date'
                          : 'Due: ${_dueDate!.month}/${_dueDate!.day}/${_dueDate!.year}',
                    ),
                  ),
                  TextButton(
                    onPressed: () => _selectDueDate(context),
                    child: Text('Select Date', style: TextStyle(color: Colors.blue),),
                  ),
                ],
              ),
              // Priority dropdown.
              DropdownButtonFormField<String>(
                value: _priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low'].map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _priority = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context), child: Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Task newTask = Task(
                name: _taskName,
                dueDate: _dueDate,
                priority: _priority,
              );
              Navigator.pop(context, newTask);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
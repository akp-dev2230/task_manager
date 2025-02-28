import 'package:flutter/material.dart';
import 'package:task_manager/task.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _taskName;
  DateTime? _dueDate;
  late String _priority;

  @override
  void initState() {
    super.initState();
    _taskName = widget.task.name;
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
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
      title: Text('Edit Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Task Name (pre-filled).
              TextFormField(
                initialValue: _taskName,
                decoration: InputDecoration(labelText: 'Task Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter task name' : null,
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
                    child: Text('Select Date'),
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
              Task updatedTask = Task(
                name: _taskName,
                dueDate: _dueDate,
                priority: _priority,
                completed: widget.task.completed,
              );
              Navigator.pop(context, updatedTask);
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

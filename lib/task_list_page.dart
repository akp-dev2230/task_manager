import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/add_task_dialog.dart';
import 'package:task_manager/edit_task_dialog.dart';
import 'package:task_manager/task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> _tasks = [];
  final String _storageKey = 'tasks';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Load tasks from SharedPreferences.
  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString(_storageKey);
    if (tasksString != null) {
      List decoded = jsonDecode(tasksString);
      setState(() {
        _tasks = decoded.map((task) => Task.fromMap(task)).toList();
      });
    }
  }

  // Save tasks to SharedPreferences.
  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksString = jsonEncode(_tasks.map((t) => t.toMap()).toList());
    await prefs.setString(_storageKey, tasksString);
  }

  // Toggle task completion status.
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].completed = !_tasks[index].completed;
    });
    _saveTasks();
  }

  // Delete a task.
  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  // Open the Add Task form.
  Future<void> _openAddTaskForm() async {
    final newTask = await showDialog<Task>(
      context: context,
      builder: (context) => AddTaskDialog(),
    );
    if (newTask != null) {
      setState(() {
        _tasks.add(newTask);
      });
      _saveTasks();
    }
  }

  // Open the Edit Task form.
  Future<void> _openEditTaskForm(int index, Task task) async {
    final updatedTask = await showDialog<Task>(
      context: context,
      builder: (context) => EditTaskDialog(task: task),
    );
    if (updatedTask != null) {
      setState(() {
        _tasks[index] = updatedTask;
      });
      _saveTasks();
    }
  }

  // Format the due date for display.
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.month}/${date.day}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Manager')),
      body: _tasks.isEmpty
          ? Center(child: Text('No tasks available.'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ListTile(
            leading: Checkbox(
              value: task.completed,
              onChanged: (value) => _toggleTaskCompletion(index),
            ),
            title: Text(
              task.name,
              style: TextStyle(
                decoration: task.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.dueDate != null)
                  Text('Due: ${_formatDate(task.dueDate)}'),
                Text('Priority: ${task.priority}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit task icon.
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _openEditTaskForm(index, task),
                ),
                // Delete task icon.
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTaskForm,
        child: Icon(Icons.add),
      ),
    );
  }
}
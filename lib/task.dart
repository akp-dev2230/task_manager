

class Task {
  String name;
  DateTime? dueDate;
  String priority;
  bool completed;

  Task({
    required this.name,
    this.dueDate,
    this.priority = 'Medium',
    this.completed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority,
      'completed': completed,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      name: map['name'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'],
      completed: map['completed'] ?? false,
    );
  }
}








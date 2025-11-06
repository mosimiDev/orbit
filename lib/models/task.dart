import 'package:uuid/uuid.dart';

enum Priority { low, medium, high }

class Task {
  final String id;
  String title;
  bool completed;
  Priority priority;
  DateTime? dueDate;

  Task({
    String? id,
    required this.title,
    this.completed = false,
    this.priority = Priority.medium,
    this.dueDate,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'completed': completed,
    'priority': priority.name,
    'dueDate': dueDate?.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    completed: json['completed'],
    priority: Priority.values.firstWhere((p) => p.name == json['priority']),
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
  );
}

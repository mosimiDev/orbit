import 'task.dart';
import 'package:uuid/uuid.dart';

class Project {
  final String id;
  String name;
  String description;
  List<Task> tasks;

  Project({
    String? id,
    required this.name,
    required this.description,
    List<Task>? tasks,
  })  : id = id ?? const Uuid().v4(),
        tasks = tasks ?? [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    tasks: (json['tasks'] as List)
        .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
        .toList(),
  );
}

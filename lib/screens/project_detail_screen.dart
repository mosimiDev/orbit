import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    final project = projectProvider.projects
        .firstWhere((p) => p.id == projectId, orElse: () => throw Exception('Project not found'));

    return Scaffold(
      appBar: AppBar(title: Text(project.name)),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(project.description,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Tasks', style: Theme.of(context).textTheme.titleLarge),
          ),
          if (project.tasks.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text('No tasks yet.'),
              ),
            )
          else
            ...project.tasks.map(
              (task) => TaskTile(
                task: task,
                onToggle: (isCompleted) async {
                  await projectProvider.toggleTask(projectId, task);
                },
                onEdit: () async {
                  await projectProvider.updateTask(projectId, task);
                },
                onDelete: () async {
                  await projectProvider.deleteTask(projectId, task);
                },
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _showAddTaskDialog(context, projectProvider);
        },
        child: const Icon(Icons.add_task),
      ),
    );
  }

  Future<void> _showAddTaskDialog(
      BuildContext context, ProjectProvider provider) async {
    final titleController = TextEditingController();
    Priority selectedPriority = Priority.medium;
    DateTime? dueDate;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<Priority>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: Priority.values
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => selectedPriority = value);
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dueDate == null
                        ? 'No Due Date'
                        : 'Due: ${dueDate!.toLocal().toString().split(' ')[0]}'),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() => dueDate = picked);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) return;
                  await provider.addTask(
                    projectId,
                    Task(
                      title: titleController.text.trim(),
                      priority: selectedPriority,
                      dueDate: dueDate,
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text('Add')),
          ],
        ),
      ),
    );
  }
}

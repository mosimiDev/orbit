import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../services/ai_service.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final _controller = TextEditingController();
  bool _loading = false;
  List<Map<String, dynamic>> _generatedTasks = [];
  String? _error;

  Future<void> _generateTasks() async {
    setState(() {
      _loading = true;
      _error = null;
      _generatedTasks.clear();
    });
    try {
      final result = await AIService.generateTasks(_controller.text);
      setState(() {
        _generatedTasks = result;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to generate tasks';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = context.watch<ProjectProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Ask AI to plan your tasks...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _generateTasks,
              child: const Text('Generate Tasks'),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_generatedTasks.isNotEmpty)
              Expanded(
                child: ListView(
                  children: _generatedTasks.map((task) {
                    return ListTile(
                      title: Text(task['title']),
                      subtitle: Text('${task['priority']} - ${task['category']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // Create a Task object from the AI-generated data
                          final newTask = Task(
                            id: const Uuid().v4(),
                            title: task['title'] ?? 'Untitled Task',
                            priority: Priority.values.firstWhere(
                              (e) => e.name.toLowerCase() == (task['priority'] as String? ?? 'medium').toLowerCase(),
                              orElse: () => Priority.medium,
                            ),
                            // You might want to handle category as well
                          );

                          projectProvider.addTask(
                            projectProvider.projects.first.id,
                            newTask,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Task added to project!')),
                          );
                        },
                      ),

                      
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

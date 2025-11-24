import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/project_provider.dart';
import '../models/project.dart';

class AddEditProjectScreen extends StatefulWidget {
  final Project? project;
  const AddEditProjectScreen({super.key, this.project});

  @override
  State<AddEditProjectScreen> createState() => _AddEditProjectScreenState();
}

class _AddEditProjectScreenState extends State<AddEditProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.project?.name ?? '');
    _descController =
        TextEditingController(text: widget.project?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProjectProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project == null ? 'Add Project' : 'Edit Project'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Project Name'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Please enter a name' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration:
                    const InputDecoration(labelText: 'Description'),
                
              ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final newProject = Project(
                    id: widget.project?.id,
                    name: _nameController.text.trim(),
                    description: _descController.text.trim(),
                    tasks: widget.project?.tasks ?? [],
                  );
                  if (widget.project == null) {
                    await provider.addProject(newProject);
                  } else {
                    await provider.updateProject(newProject);
                  }
                 
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

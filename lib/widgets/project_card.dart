import 'package:flutter/material.dart';
import '../models/project.dart';


class ProjectCard extends StatelessWidget {
final Project project;
final VoidCallback onTap;
final VoidCallback onDelete;
final VoidCallback onEdit;


const ProjectCard({
super.key,
required this.project,
required this.onTap,
required this.onDelete,
required this.onEdit,
});


@override
Widget build(BuildContext context) {
return Card(
child: ListTile(
onTap: onTap,
title: Text(project.name),
subtitle: Text(project.description.isEmpty ? 'No description' : project.description),
trailing: Row(
mainAxisSize: MainAxisSize.min,
children: [
Text('${project.tasks.length}'),
IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),


],
),
),
);
}
}
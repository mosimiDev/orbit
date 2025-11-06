import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/ai_service.dart';
import 'package:intl/intl.dart';


class TaskTile extends StatelessWidget {
final Task task;
final ValueChanged<bool?> onToggle;
final VoidCallback onEdit;
final VoidCallback onDelete;


const TaskTile({
super.key,
required this.task,
required this.onToggle,
required this.onEdit,
required this.onDelete,
});


Color _priorityColor(Priority p, BuildContext context) {
switch (p) {
case Priority.low:
return Colors.green;
case Priority.medium:
return Colors.orange;
case Priority.high:
return Colors.red;
}
}


Widget _buildTrailingWidgets(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _priorityColor(task.priority, context).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(task.priority.name.toUpperCase()),
        ),
        PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            } else if (value == 'suggest_time') {
              final newTime = await AIService.suggestNewTime(task.title);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Suggested: $newTime')),
              );
            } else if (value == 'ai_assistant') {
              Navigator.pushNamed(context, '/ai-assistant');
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
            const PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
                value: 'suggest_time', child: Text('Suggest New Time')),
            const PopupMenuItem<String>(
              value: 'ai_assistant',
              child: Text('AI Assistant'),
            ),
          ],
        ),
      ],
    );
}

@override
Widget build(BuildContext context) {
return ListTile(
  leading: Checkbox(value: task.completed, onChanged: onToggle),
  title: Text(
    task.title,
    style: TextStyle(
        decoration: task.completed
            ? TextDecoration.lineThrough
            : TextDecoration.none),
  ),
  subtitle: task.dueDate != null
      ? Text('Due: ${DateFormat.yMMMd().format(task.dueDate!)}')
      : null,
  trailing: _buildTrailingWidgets(context),
);
}
}

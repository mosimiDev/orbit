import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../services/local_storage_service.dart';


class ProjectProvider extends ChangeNotifier {
final LocalStorageService _storage = LocalStorageService();
List<Project> _projects = [];


List<Project> get projects => _projects;


ProjectProvider() {
_load();
}


Future<void> _load() async {
_projects = await _storage.loadProjects();
notifyListeners();
}


Future<void> addProject(Project project) async {
_projects.add(project);
await _save();
notifyListeners();
}


Future<void> updateProject(Project project) async {
final i = _projects.indexWhere((p) => p.id == project.id);
if (i != -1) {
_projects[i] = project;
await _save();
notifyListeners();
}
}

Future<void> toggleTask(String projectId, Task task) async {
  try {
    final project = _projects.firstWhere((p) => p.id == projectId);
    final taskIndex = project.tasks.indexWhere((t) => t.id == task.id);
    if (taskIndex != -1) {
      // Toggle the completed status
      project.tasks[taskIndex].completed = !project.tasks[taskIndex].completed;
      notifyListeners();
      await _save();
    }
  } catch (e) {
    // Handle cases where the project or task is not found, if necessary
    print('Error toggling task: $e');
  }
}



Future<void> deleteProject(String id) async {
_projects.removeWhere((p) => p.id == id);
await _save();
notifyListeners();
}


// Task operations
Future<void> addTask(String projectId, Task task) async {
final proj = _projects.firstWhere((p) => p.id == projectId);
proj.tasks.add(task);
await _save();
notifyListeners();
}


Future<void> updateTask(String projectId, Task task) async {
final proj = _projects.firstWhere((p) => p.id == projectId);
final i = proj.tasks.indexWhere((t) => t.id == task.id);
if (i != -1) {
proj.tasks[i] = task;
await _save();
notifyListeners();
}
}

Future<void> doneTask(String projectId, Task task) async {
final proj = _projects.firstWhere((p) => p.id == projectId);
final i = proj.tasks.indexWhere((t) => t.id == task.id);
if (i != -1) {
  // replace the task with the updated task (e.g. with updated completion state)
  proj.tasks[i] = task;
  await _save();
  notifyListeners();
}
}

Future<void> deleteTask(String projectId, Task task) async {
final proj = _projects.firstWhere((p) => p.id == projectId);
proj.tasks.removeWhere((t) => t.id == task.id);
await _save();
notifyListeners();
}

// Persist projects to local storage
Future<void> _save() async {
await _storage.saveProjects(_projects);
}

}
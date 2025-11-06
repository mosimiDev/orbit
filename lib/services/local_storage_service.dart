import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';

class LocalStorageService {
  static const _key = 'projects_data';

  Future<void> saveProjects(List<Project> projects) async {
    final prefs = await SharedPreferences.getInstance();
    final data = projects.map((p) => p.toJson()).toList();
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<List<Project>> loadProjects() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => Project.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}

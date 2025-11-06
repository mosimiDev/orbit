import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<List<Map<String, dynamic>>> generateTasks(String prompt) async {
    // Replace this with your real endpoint or OpenAI key
    final url = Uri.parse('https://mock-ai-api.com/generate-tasks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      // Expected mock response format
      // [{"title":"Design logo","priority":"High","category":"Work"}]
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('AI generation failed');
    }
  }

  static Future<String> suggestNewTime(String taskTitle) async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate AI rescheduling suggestion
    return 'Tomorrow at 10am';
  }
}

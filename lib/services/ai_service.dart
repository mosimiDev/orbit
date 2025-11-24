import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<List<Map<String, dynamic>>> generateTasks(String prompt) async {
    
    final url = Uri.parse('https://ai-gateway.vercel.sh/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('AI generation failed');
    }
  }

  static Future<String> suggestNewTime(String taskTitle) async {
    await Future.delayed(const Duration(seconds: 1));
    
    return 'Suggested new time for "$taskTitle" is tomorrow at 10 AM';
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/strings.dart';

class GeminiService {
  final List<Map<String, dynamic>> _history = [];

  Future<String> sendMessage(String message, {String? projectContext}) async {
    try {
      final contextStr = projectContext != null
          ? 'Project Context: $projectContext\n\n'
          : '';
      final fullMessage = '$contextStr$message';

      _history.add({
        'role': 'user',
        'content': fullMessage,
      });

      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      final messages = [
        {
          'role': 'system',
          'content':
              'You are MaintainIQ AI — expert in software maintenance cost estimation, '
                  'COCOMO model, ROI analysis, and technical debt. '
                  'Always respond in the same language the user writes in (Urdu, English, etc). '
                  'Give detailed, helpful, accurate answers. Never give fake or random numbers.',
        },
        ..._history,
      ];

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${AppStrings.groqApiKey}',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 1024,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        _history.add({
          'role': 'assistant',
          'content': reply,
        });
        return reply;
      } else {
        print('Groq Error: ${response.statusCode} ${response.body}');
        return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print('GeminiService Error: $e');
      return 'Error: $e';
    }
  }
}
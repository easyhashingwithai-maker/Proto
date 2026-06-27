import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_client.dart';

class GeminiClient implements AIClient {
  final String apiKey;

  GeminiClient({required this.apiKey});

  @override
  Future<String> generateResponse(String prompt) async {
    final url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Gemini API Error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Gemini connection error: $e');
    }
  }
}

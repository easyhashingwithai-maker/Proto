import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_client.dart';

class GroqClient implements AIClient {
  final String apiKey;
  final String model;

  GroqClient({required this.apiKey, this.model = 'llama3-8b-8192'});

  @override
  Future<String> generateResponse(String prompt) async {
    const url = 'https://api.groq.com/openai/v1/chat/completions';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': model,
          'messages': [{'role': 'user', 'content': prompt}],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Groq API Error: ${response.body}');
      }
    } catch (e) {
      throw Exception('Groq connection error: $e');
    }
  }
}

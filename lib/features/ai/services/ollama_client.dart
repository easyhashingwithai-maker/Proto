import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_client.dart';

class OllamaClient implements AIClient {
  final String baseUrl;
  final String model;

  OllamaClient({this.baseUrl = 'http://localhost:11434', this.model = 'llama3.2:3b'});

  @override
  Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/generate'),
        body: jsonEncode({
          'model': model,
          'prompt': prompt,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to connect to Ollama: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Ollama connection error: $e');
    }
  }
}

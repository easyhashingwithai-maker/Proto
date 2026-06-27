import 'ollama_client.dart';
import 'gemini_client.dart';
import 'groq_client.dart';
import '../../../core/services/connectivity_service.dart';

enum AIProvider { local, gemini, groq }

class AIOrchestrator {
  final ConnectivityService _connectivity;
  AIProvider _currentProvider = AIProvider.local;

  String? geminiKey;
  String? groqKey;

  AIOrchestrator(this._connectivity);

  void setProvider(AIProvider provider) {
    _currentProvider = provider;
  }

  Future<String> askProto(String prompt) async {
    final isOnline = await _connectivity.isConnected();

    if (!isOnline || _currentProvider == AIProvider.local) {
      return await _tryLocal(prompt);
    }

    try {
      if (_currentProvider == AIProvider.gemini && geminiKey != null) {
        return await GeminiClient(apiKey: geminiKey!).generateResponse(prompt);
      } else if (_currentProvider == AIProvider.groq && groqKey != null) {
        return await GroqClient(apiKey: groqKey!).generateResponse(prompt);
      } else {
        return await _tryLocal(prompt);
      }
    } catch (e) {
      // Fallback to local on cloud failure
      return await _tryLocal(prompt + " (Cloud failed, using local fallback)");
    }
  }

  Future<String> _tryLocal(String prompt) async {
    try {
      return await OllamaClient().generateResponse(prompt);
    } catch (e) {
      return "I'm sorry, I'm having trouble connecting to my local core (Ollama). Please make sure it's running. Error: $e";
    }
  }
}

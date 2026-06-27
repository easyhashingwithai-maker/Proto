import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../features/avatar/ui/proto_avatar.dart';
import '../features/ai/services/ai_orchestrator.dart';
import '../core/services/connectivity_service.dart';
import '../core/theme/proto_theme.dart';
import '../features/code/ui/code_editor_widget.dart';
import '../features/code/ui/file_tree_widget.dart';
import '../features/git/ui/git_status_widget.dart';
import '../features/voice/services/tts_service.dart';

final aiOrchestratorProvider = Provider((ref) => AIOrchestrator(ConnectivityService()));
final ttsServiceProvider = Provider((ref) => TTSService());

class MainDashboard extends ConsumerStatefulWidget {
  const MainDashboard({super.key});

  @override
  ConsumerState<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  int _selectedIndex = 0;
  bool _isSpeaking = false;
  File? _selectedFile;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ttsServiceProvider).setHandler(
        () => setState(() => _isSpeaking = true),
        () => setState(() => _isSpeaking = false),
      );
    });
  }

  void _handleSend([String? customText]) async {
    final text = customText ?? _chatController.text;
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _chatController.clear();
    });

    final response = await ref.read(aiOrchestratorProvider).askProto(text);

    setState(() {
      _messages.add({'role': 'proto', 'content': response});
    });

    await ref.read(ttsServiceProvider).speak(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: ProtoTheme.surface,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.chat), label: Text("Assistant")),
              NavigationRailDestination(icon: Icon(Icons.code), label: Text("Code")),
              NavigationRailDestination(icon: Icon(Icons.hub), label: Text("Git")),
              NavigationRailDestination(icon: Icon(Icons.settings), label: Text("Settings")),
            ],
          ),
          Expanded(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("PROTO SYSTEM", style: TextStyle(fontSize: 24, letterSpacing: 4, color: ProtoTheme.accent)),
          ProtoAvatar(isSpeaking: _isSpeaking),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: return _buildChatView();
      case 1: return _buildCodeView();
      case 2: return const GitStatusWidget();
      case 3: return _buildSettingsView();
      default: return const Center(child: Text("Welcome, Sir."));
    }
  }

  Widget _buildCodeView() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          child: FileTreeWidget(
            rootPath: Directory.current.path,
            onFileSelected: (file) => setState(() => _selectedFile = file),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: _selectedFile == null
              ? const Center(child: Text("Select a file to edit"))
              : ProtoCodeEditor(
                  key: ValueKey(_selectedFile!.path),
                  initialCode: _selectedFile!.readAsStringSync(),
                  language: _selectedFile!.path.split('.').last,
                  onSave: (code) {
                    _selectedFile!.writeAsStringSync(code);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File saved.")));
                  },
                  onAnalyze: (code) {
                    setState(() => _selectedIndex = 0);
                    _handleSend("Analyze this code for bugs:\n\n$code");
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, i) {
              final m = _messages[i];
              final isUser = m['role'] == 'user';
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                decoration: BoxDecoration(
                  color: isUser ? Colors.white.withValues(alpha: 0.05) : ProtoTheme.accent.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isUser ? "YOU" : "PROTO",
                         style: TextStyle(color: isUser ? Colors.white : ProtoTheme.accent, fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 8),
                    Text(m['content'] ?? ""),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _chatController,
            onSubmitted: (_) => _handleSend(),
            decoration: InputDecoration(
              hintText: "Enter command...",
              suffixIcon: IconButton(onPressed: _handleSend, icon: const Icon(Icons.send, color: ProtoTheme.accent)),
              filled: true,
              fillColor: ProtoTheme.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSettingsView() {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        const Text("System Configuration", style: TextStyle(fontSize: 20, color: ProtoTheme.accent)),
        const SizedBox(height: 20),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: const Text("Use Local AI (Ollama)"),
                subtitle: const Text("Offline mode enabled"),
                value: true,
                onChanged: (v) {},
                activeThumbColor: ProtoTheme.accent,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: "Gemini API Key", border: OutlineInputBorder()),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(labelText: "GitHub PAT", border: OutlineInputBorder()),
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

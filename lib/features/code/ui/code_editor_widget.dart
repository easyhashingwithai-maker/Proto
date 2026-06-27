import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';
import '../../../core/theme/proto_theme.dart';

class ProtoCodeEditor extends StatefulWidget {
  final String initialCode;
  final String language;
  final Function(String) onSave;

  const ProtoCodeEditor({
    super.key,
    required this.initialCode,
    required this.language,
    required this.onSave,
  });

  @override
  State<ProtoCodeEditor> createState() => _ProtoCodeEditorState();
}

class _ProtoCodeEditorState extends State<ProtoCodeEditor> {
  late CodeController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = CodeController(
      text: widget.initialCode,
      language: _getLanguage(widget.language),
    );
  }

  dynamic _getLanguage(String lang) {
    switch (lang.toLowerCase()) {
      case 'dart': return dart;
      case 'python': return python;
      case 'javascript': return javascript;
      default: return dart;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CodeTheme(
            data: CodeThemeData(styles: _getCustomTheme()),
            child: SingleChildScrollView(
              child: CodeField(
                controller: _codeController,
                textStyle: const TextStyle(fontFamily: 'monospace'),
                lineNumberStyle: const LineNumberStyle(
                  textStyle: TextStyle(color: ProtoTheme.accent, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
        _buildActionToolbar(),
      ],
    );
  }

  Widget _buildActionToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: ProtoTheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: () => widget.onSave(_codeController.text),
            icon: const Icon(Icons.save),
            label: const Text("Save"),
            style: ElevatedButton.styleFrom(backgroundColor: ProtoTheme.accent),
          ),
        ],
      ),
    );
  }

  Map<String, TextStyle> _getCustomTheme() {
    // Simplified custom theme for syntax highlighting
    return {
      'root': const TextStyle(backgroundColor: Color(0xff0A0A0F), color: Color(0xffE0E0E0)),
      'keyword': const TextStyle(color: Color(0xff00D4FF), fontWeight: FontWeight.bold),
      'string': const TextStyle(color: Color(0xff98c379)),
      'comment': const TextStyle(color: Color(0xff5c6370), fontStyle: FontStyle.italic),
    };
  }
}

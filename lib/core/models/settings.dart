import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class UserSettings {
  Id id = Isar.autoIncrement;

  bool useLocalAI = true;

  String? geminiApiKey;

  String? groqApiKey;

  String? githubPAT;

  String activeModel = 'llama3.2:3b';

  bool voiceEnabled = true;

  String themeMode = 'dark';
}

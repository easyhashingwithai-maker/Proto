import 'package:isar/isar.dart';

part 'chat_message.g.dart';

@collection
class ChatMessage {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime timestamp;

  late String text;

  late bool isUser;

  String? codeSnippet;

  String? language;
}

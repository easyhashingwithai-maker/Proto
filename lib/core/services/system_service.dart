import 'dart:io';
import 'package:process_run/shell.dart';

class SystemService {
  Future<String> runCommand(String command, {String? workingDir}) async {
    if (!Platform.isMacOS && !Platform.isLinux && !Platform.isWindows) {
      return "System commands are only supported on Desktop platforms.";
    }

    try {
      final shell = Shell(workingDirectory: workingDir);
      final results = await shell.run(command);
      return results.map((r) => r.stdout.toString()).join('\n');
    } catch (e) {
      return "Execution Error: $e";
    }
  }

  Future<List<FileSystemEntity>> listFiles(String path) async {
    final dir = Directory(path);
    if (await dir.exists()) {
      return dir.list().toList();
    }
    return [];
  }
}

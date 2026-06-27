import 'package:process_run/shell.dart';

class GitService {
  Future<String> execute(String command, {String? workingDir}) async {
    try {
      final shell = Shell(workingDirectory: workingDir);
      final result = await shell.run("git $command");
      return result.first.stdout.toString();
    } catch (e) {
      throw Exception('Git error: $e');
    }
  }

  Future<void> clone(String url, String path) async {
    await execute('clone $url $path');
  }

  Future<void> commit(String message, {String? workingDir}) async {
    await execute('add .', workingDir: workingDir);
    await execute('commit -m "$message"', workingDir: workingDir);
  }

  Future<void> push(String remote, String branch, {String? workingDir, String? pat}) async {
    await execute('push $remote $branch', workingDir: workingDir);
  }

  Future<List<String>> getStatus({String? workingDir}) async {
    final output = await execute('status --short', workingDir: workingDir);
    return output.split('\n').where((s) => s.isNotEmpty).toList();
  }
}

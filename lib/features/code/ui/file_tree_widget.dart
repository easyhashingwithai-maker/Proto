import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/proto_theme.dart';

class FileTreeWidget extends StatelessWidget {
  final String rootPath;
  final Function(File) onFileSelected;

  const FileTreeWidget({super.key, required this.rootPath, required this.onFileSelected});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FileSystemEntity>>(
      future: Directory(rootPath).list().toList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final items = snapshot.data!;
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final isDir = item is Directory;

            return ListTile(
              leading: Icon(
                isDir ? Icons.folder : Icons.insert_drive_file,
                color: ProtoTheme.accent,
              ),
              title: Text(item.path.split(Platform.pathSeparator).last,
                          style: const TextStyle(fontSize: 14)),
              onTap: () {
                if (!isDir) onFileSelected(item as File);
              },
            );
          },
        );
      },
    );
  }
}

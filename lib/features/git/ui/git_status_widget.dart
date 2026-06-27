import 'package:flutter/material.dart';
import '../../../core/theme/proto_theme.dart';

class GitStatusWidget extends StatelessWidget {
  const GitStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("GIT AUTOMATION", style: TextStyle(fontSize: 18, color: ProtoTheme.accent)),
          const SizedBox(height: 20),
          _buildStatusItem("Branch", "main", Icons.account_tree),
          _buildStatusItem("Status", "Clean", Icons.check_circle),
          const Spacer(),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.sync),
                label: const Text("Sync Repository"),
                style: ElevatedButton.styleFrom(backgroundColor: ProtoTheme.accent),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bug_report),
                label: const Text("Auto-Fix & Push"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatusItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ProtoTheme.accent, size: 20),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(color: ProtoTheme.textSecondary)),
        ],
      ),
    );
  }
}

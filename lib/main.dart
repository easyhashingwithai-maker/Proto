import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/proto_theme.dart';
import 'main_dashboard.dart';

void main() {
  runApp(
    const ProviderScope(
      child: ProtoApp(),
    ),
  );
}

class ProtoApp extends StatelessWidget {
  const ProtoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proto',
      debugShowCheckedModeBanner: false,
      theme: ProtoTheme.darkTheme,
      home: const MainDashboard(),
    );
  }
}

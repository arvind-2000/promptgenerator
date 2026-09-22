import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'prompt/prompt_fetch_service.dart';
import 'prompt/prompt_storage_service.dart';
import 'screens/prompt_list_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await _seedIfEmpty();
  runApp(const PromptLibraryApp());
}

/// Seeds the curated .NET/SQL/PostgreSQL/Dart/Flutter/React/CSS/Bootstrap
/// prompts, plus the Hugging Face general set, the first time the local
/// box is empty. Safe to call on every launch — it's a no-op afterward.
Future<void> _seedIfEmpty() async {
  final storage = PromptStorageService();
  final existing = await storage.getAll();
  if (existing.isNotEmpty) return;

  await storage.seedCurated();
  try {
    final general = await PromptFetchService().fetchAllSeedPrompts();
    await storage.saveAll(general);
  } catch (_) {
    // Offline on first launch — curated prompts are still there.
  }
}

class PromptLibraryApp extends StatelessWidget {
  const PromptLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prompt Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      darkTheme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const PromptListScreen(),
    );
  }
}

// Requires `hive` + `hive_flutter`: add to pubspec.yaml and call
// `await Hive.initFlutter();` once in main() before using this service.
import 'package:hive/hive.dart';

import 'prompt.dart';
import 'seed_prompts.dart';

class PromptStorageService {
  static const _boxName = 'prompts';

  Future<Box> _openBox() => Hive.openBox(_boxName);

  /// Saves the hand-written .NET/SQL/PostgreSQL/Dart/Flutter/React/CSS/
  /// Bootstrap starter prompts from seed_prompts.dart.
  Future<void> seedCurated() => saveAll(curatedSeedPrompts);

  Future<void> savePrompt(Prompt prompt) async {
    final box = await _openBox();
    await box.put(prompt.id, prompt.toJson());
  }

  /// Bulk-saves prompts — use this after fetchAllSeedPrompts() to seed the box.
  Future<void> saveAll(List<Prompt> prompts) async {
    final box = await _openBox();
    final entries = {for (final p in prompts) p.id: p.toJson()};
    await box.putAll(entries);
  }

  Future<List<Prompt>> getAll() async {
    final box = await _openBox();
    return box.values.map((e) => Prompt.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> deletePrompt(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> toggleFavorite(String id) async {
    final box = await _openBox();
    final raw = box.get(id);
    if (raw == null) return;
    final prompt = Prompt.fromJson(Map<String, dynamic>.from(raw as Map));
    prompt.isFavorite = !prompt.isFavorite;
    await box.put(id, prompt.toJson());
  }

  Future<List<Prompt>> search(String query) async {
    final all = await getAll();
    final q = query.toLowerCase();
    return all
        .where(
          (p) =>
              p.act.toLowerCase().contains(q) ||
              p.prompt.toLowerCase().contains(q) ||
              p.tags.any((t) => t.toLowerCase().contains(q)),
        )
        .toList();
  }

  Future<List<Prompt>> getByCategory(String category) async {
    final all = await getAll();
    return all.where((p) => p.category == category).toList();
  }

  /// Filters by tech stack, e.g. PromptStack.flutter.
  Future<List<Prompt>> getByStack(String stack) async {
    final all = await getAll();
    return all.where((p) => p.stack == stack).toList();
  }

  /// Filters by lifecycle stage, e.g. PromptStage.deployment.
  Future<List<Prompt>> getByStage(String stage) async {
    final all = await getAll();
    return all.where((p) => p.stage == stage).toList();
  }

  /// Filters by both stack and stage — e.g. Flutter + UI/Cards.
  Future<List<Prompt>> getByStackAndStage(String stack, String stage) async {
    final all = await getAll();
    return all.where((p) => p.stack == stack && p.stage == stage).toList();
  }
}

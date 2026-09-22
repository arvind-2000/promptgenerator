import 'taxonomy.dart';

/// A single saved AI prompt.
class Prompt {
  final String id;
  final String act; // short title / role, e.g. "Linux Terminal"
  final String prompt; // the actual prompt text
  final List<String> tags;
  String category; // free-form label, e.g. "Imported", "Custom"
  String stack; // tech stack — see PromptStack
  String stage; // lifecycle stage — see PromptStage
  bool isFavorite;
  final DateTime createdAt;

  Prompt({
    required this.id,
    required this.act,
    required this.prompt,
    List<String>? tags,
    this.category = 'General',
    this.stack = PromptStack.general,
    this.stage = PromptStage.other,
    this.isFavorite = false,
    DateTime? createdAt,
  })  : tags = tags ?? [],
        createdAt = createdAt ?? DateTime.now();

  /// Builds a Prompt from one row returned by the Hugging Face
  /// Datasets Server API for fka/awesome-chatgpt-prompts.
  /// Each row looks like: {"row_idx": 0, "row": {"act": "...", "prompt": "..."}}
  factory Prompt.fromHuggingFaceRow(Map<String, dynamic> row) {
    final data = Map<String, dynamic>.from(row['row'] as Map);
    final idx = row['row_idx']?.toString() ??
        DateTime.now().microsecondsSinceEpoch.toString();
    return Prompt(
      id: 'seed_$idx',
      act: (data['act'] ?? 'Untitled').toString(),
      prompt: (data['prompt'] ?? '').toString(),
      tags: const ['seed', 'chatgpt'],
      category: 'Imported',
      stack: PromptStack.general,
      stage: PromptStage.other,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'act': act,
        'prompt': prompt,
        'tags': tags,
        'category': category,
        'stack': stack,
        'stage': stage,
        'isFavorite': isFavorite,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Prompt.fromJson(Map<String, dynamic> json) => Prompt(
        id: json['id'] as String,
        act: json['act'] as String,
        prompt: json['prompt'] as String,
        tags: List<String>.from(json['tags'] ?? const []),
        category: (json['category'] as String?) ?? 'General',
        stack: (json['stack'] as String?) ?? PromptStack.general,
        stage: (json['stage'] as String?) ?? PromptStage.other,
        isFavorite: json['isFavorite'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

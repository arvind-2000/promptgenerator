import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../prompt/prompt.dart';
import '../prompt/prompt_storage_service.dart';
import '../prompt/prompt_template_service.dart';
import 'add_edit_prompt_screen.dart';

/// Interactive Prompt Generator screen:
/// - Detects template variables
/// - Provides dynamic input fields with suggestion chips
/// - Live-renders the interpolated prompt
/// - Allows one-click copying of the finalized prompt
class PromptDetailScreen extends StatefulWidget {
  final Prompt prompt;

  const PromptDetailScreen({super.key, required this.prompt});

  @override
  State<PromptDetailScreen> createState() => _PromptDetailScreenState();
}

class _PromptDetailScreenState extends State<PromptDetailScreen> {
  final _storage = PromptStorageService();
  late final List<PromptVariable> _variables;
  final Map<String, TextEditingController> _controllers = {};
  final TextEditingController _customContextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _variables = PromptTemplateService.extractVariables(widget.prompt.prompt);
    for (final v in _variables) {
      final controller = TextEditingController();
      controller.addListener(() => setState(() {}));
      _controllers[v.name] = controller;
    }
    _customContextController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _customContextController.dispose();
    super.dispose();
  }

  Map<String, String> get _currentValues {
    return {
      for (final entry in _controllers.entries) entry.key: entry.value.text.trim(),
    };
  }

  String get _generatedPrompt {
    String output = PromptTemplateService.interpolate(
      widget.prompt.prompt,
      _currentValues,
    );

    final extra = _customContextController.text.trim();
    if (extra.isNotEmpty) {
      output = '$output\n\nAdditional Requirements:\n$extra';
    }

    return output;
  }

  int get _filledCount {
    return _controllers.values.where((c) => c.text.trim().isNotEmpty).length;
  }

  void _fillSuggestions() {
    setState(() {
      for (final v in _variables) {
        if (v.hint.isNotEmpty && _controllers[v.name]!.text.isEmpty) {
          final choices = _extractChoices(v.hint);
          if (choices.isNotEmpty) {
            _controllers[v.name]!.text = choices.first;
          } else {
            _controllers[v.name]!.text = v.hint;
          }
        }
      }
    });
  }

  void _clearAllVariables() {
    setState(() {
      for (final c in _controllers.values) {
        c.clear();
      }
      _customContextController.clear();
    });
  }

  List<String> _extractChoices(String hint) {
    String clean = hint;
    if (clean.toLowerCase().startsWith('e.g.')) {
      clean = clean.substring(4).trim();
    }
    final parts = clean
        .split(RegExp(r',\s*or\s+|\s+or\s+|,\s*'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length < 35)
        .toList();
    return parts.length > 1 ? parts : const [];
  }

  void _copyToClipboard(String text, {String message = 'Ready prompt copied to clipboard!'}) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasVars = _variables.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.prompt.act),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Prompt',
            onPressed: () async {
              final edited = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => AddEditPromptScreen(existing: widget.prompt),
                ),
              );
              if (edited == true && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete Prompt?'),
                  content: Text('Are you sure you want to delete "${widget.prompt.act}"?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(ctx).pop(true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await _storage.deletePrompt(widget.prompt.id);
                if (context.mounted) Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
        children: [
          // Tags & Metadata Row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              Chip(
                label: Text(widget.prompt.stack),
                avatar: const Icon(Icons.code, size: 16),
              ),
              Chip(
                label: Text(widget.prompt.stage),
                avatar: const Icon(Icons.layers_outlined, size: 16),
              ),
              if (hasVars)
                Chip(
                  backgroundColor: scheme.tertiaryContainer,
                  label: Text(
                    '$_filledCount/${_variables.length} parameters filled',
                    style: TextStyle(color: scheme.onTertiaryContainer),
                  ),
                  avatar: Icon(Icons.tune, size: 16, color: scheme.onTertiaryContainer),
                ),
              ...widget.prompt.tags.map((t) => Chip(label: Text('#$t'))),
            ],
          ),
          const SizedBox(height: 16),

          // Parameter Customization Form
          if (hasVars) ...[
            Row(
              children: [
                Icon(Icons.tune, size: 20, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Customize Parameters',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.auto_fix_high, size: 16),
                  label: const Text('Suggestions'),
                  onPressed: _fillSuggestions,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Clear'),
                  onPressed: _clearAllVariables,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: scheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: _variables.map((v) {
                    final controller = _controllers[v.name]!;
                    final choices = _extractChoices(v.hint);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: v.name,
                              hintText: v.hint.isNotEmpty ? 'e.g. ${v.hint}' : null,
                              isDense: true,
                              border: const OutlineInputBorder(),
                              suffixIcon: controller.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 18),
                                      onPressed: () => controller.clear(),
                                    )
                                  : null,
                            ),
                          ),
                          if (choices.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: choices.map((choice) {
                                final isSelected = controller.text.trim() == choice;
                                return ActionChip(
                                  visualDensity: VisualDensity.compact,
                                  label: Text(choice, style: const TextStyle(fontSize: 11)),
                                  backgroundColor: isSelected ? scheme.primaryContainer : null,
                                  onPressed: () {
                                    controller.text = choice;
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],

          // Optional Extra Context
          Row(
            children: [
              Icon(Icons.add_comment_outlined, size: 18, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                'Custom Requirements (Optional)',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _customContextController,
            decoration: const InputDecoration(
              hintText: 'e.g. Must include error handling, write comprehensive docstrings...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 18),

          // Live Generated Output Header
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 20, color: scheme.primary),
              const SizedBox(width: 8),
              Text(
                'Ready-to-Use Prompt',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                tooltip: 'Copy Generated Prompt',
                onPressed: () => _copyToClipboard(_generatedPrompt),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Output Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: SelectableText(
              _generatedPrompt,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
          const SizedBox(height: 12),

          // Quick Template Inspector
          if (hasVars)
            ExpansionTile(
              title: const Text('View Original Template', style: TextStyle(fontSize: 13)),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    widget.prompt.prompt,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _copyToClipboard(_generatedPrompt),
        icon: const Icon(Icons.content_copy_rounded),
        label: const Text('Copy Generated Prompt'),
      ),
    );
  }
}

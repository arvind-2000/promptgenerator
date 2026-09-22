import 'package:flutter/material.dart';
import 'package:promptgenerator/prompt/taxonomy.dart';

import '../prompt/prompt.dart';
import '../prompt/prompt_storage_service.dart';
import '../prompt/prompt_template_service.dart';

/// Form for creating a new prompt, or editing one (pass `existing`).
class AddEditPromptScreen extends StatefulWidget {
  final Prompt? existing;

  const AddEditPromptScreen({super.key, this.existing});

  @override
  State<AddEditPromptScreen> createState() => _AddEditPromptScreenState();
}

class _AddEditPromptScreenState extends State<AddEditPromptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = PromptStorageService();

  late final TextEditingController _actController;
  late final TextEditingController _promptController;
  late final TextEditingController _tagsController;
  late String _stack;
  late String _stage;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _actController = TextEditingController(text: existing?.act ?? '');
    _promptController = TextEditingController(text: existing?.prompt ?? '');
    _tagsController =
        TextEditingController(text: existing?.tags.join(', ') ?? '');
    _stack = existing?.stack ?? PromptStack.general;
    _stage = existing?.stage ?? PromptStage.other;

    _promptController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _actController.dispose();
    _promptController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final prompt = Prompt(
      id: widget.existing?.id ??
          'custom_${DateTime.now().microsecondsSinceEpoch}',
      act: _actController.text.trim(),
      prompt: _promptController.text.trim(),
      tags: tags,
      category: widget.existing?.category ?? 'Custom',
      stack: _stack,
      stage: _stage,
      isFavorite: widget.existing?.isFavorite ?? false,
      createdAt: widget.existing?.createdAt,
    );

    await _storage.savePrompt(prompt);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    final detectedVars =
        PromptTemplateService.extractVariables(_promptController.text);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Prompt' : 'New Prompt')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _actController,
              decoration: const InputDecoration(
                labelText: 'Title / Act',
                hintText: 'e.g. Flutter State Machine Scaffold',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'Prompt Template',
                hintText:
                    'Use {VariableName} or {Variable, e.g. Hint} to create customizable parameters.',
                helperText:
                    'Dynamic tokens like {ProjectName} will become input fields in the generator.',
                helperMaxLines: 2,
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            if (detectedVars.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.tune, size: 16, color: scheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    'Detected Parameters (${detectedVars.length}):',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: detectedVars.map((v) {
                  return Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(v.name, style: const TextStyle(fontSize: 11)),
                    backgroundColor: scheme.tertiaryContainer,
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 14),
            TextFormField(
              controller: _tagsController,
              decoration: const InputDecoration(
                labelText: 'Tags (comma-separated)',
                hintText: 'e.g. flutter, scaffold, state-management',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _stack,
              decoration: const InputDecoration(
                labelText: 'Stack',
                border: OutlineInputBorder(),
              ),
              items: PromptStack.all
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _stack = v!),
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              initialValue: _stage,
              decoration: const InputDecoration(
                labelText: 'Stage',
                border: OutlineInputBorder(),
              ),
              items: PromptStage.all
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _stage = v!),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Save Prompt Template'),
            ),
          ],
        ),
      ),
    );
  }
}

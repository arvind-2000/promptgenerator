import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../prompt/prompt.dart';
import '../prompt/prompt_storage_service.dart';
import 'add_edit_prompt_screen.dart';
import 'prompt_card.dart';
import 'prompt_detail_screen.dart';
import 'stack_stage_filter.dart';

/// Home screen: search + stack/stage filters + the card list.
class PromptListScreen extends StatefulWidget {
  const PromptListScreen({super.key});

  @override
  State<PromptListScreen> createState() => _PromptListScreenState();
}

class _PromptListScreenState extends State<PromptListScreen> {
  final _storage = PromptStorageService();
  final _searchController = TextEditingController();

  List<Prompt> _all = [];
  List<Prompt> _visible = [];
  String? _stack;
  String? _stage;
  bool _favoritesOnly = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prompts = await _storage.getAll();
    setState(() {
      _all = prompts;
      _loading = false;
    });
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _visible = _all.where((p) {
        final matchesStack = _stack == null || p.stack == _stack;
        final matchesStage = _stage == null || p.stage == _stage;
        final matchesFavorite = !_favoritesOnly || p.isFavorite;
        final matchesQuery =
            query.isEmpty ||
            p.act.toLowerCase().contains(query) ||
            p.prompt.toLowerCase().contains(query) ||
            p.tags.any((t) => t.toLowerCase().contains(query));
        return matchesStack && matchesStage && matchesFavorite && matchesQuery;
      }).toList();
    });
  }

  Future<void> _toggleFavorite(Prompt prompt) async {
    await _storage.toggleFavorite(prompt.id);
    await _load();
  }

  void _copyPrompt(Prompt prompt) {
    Clipboard.setData(ClipboardData(text: prompt.prompt));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prompt copied')));
  }

  Future<void> _openDetail(Prompt prompt) async {
    final changed = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => PromptDetailScreen(prompt: prompt)));
    if (changed == true) _load();
  }

  Future<void> _addPrompt() async {
    final added = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const AddEditPromptScreen()));
    if (added == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prompt Library'),
        actions: [
          IconButton(
            icon: Icon(_favoritesOnly ? Icons.star : Icons.star_border),
            tooltip: 'Favorites only',
            onPressed: () {
              setState(() => _favoritesOnly = !_favoritesOnly);
              _applyFilters();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPrompt,
        tooltip: 'New prompt',
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search prompts, tags...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onChanged: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(height: 10),
                StackStageFilter(
                  selectedStack: _stack,
                  selectedStage: _stage,
                  onStackChanged: (v) {
                    setState(() => _stack = v);
                    _applyFilters();
                  },
                  onStageChanged: (v) {
                    setState(() => _stage = v);
                    _applyFilters();
                  },
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: _visible.isEmpty
                      ? const Center(child: Text('No prompts match those filters'))
                      : ListView.builder(
                          itemCount: _visible.length,
                          itemBuilder: (context, index) {
                            final prompt = _visible[index];
                            return PromptCard(
                              prompt: prompt,
                              onTap: () => _openDetail(prompt),
                              onFavoriteToggle: () => _toggleFavorite(prompt),
                              onCopy: () => _copyPrompt(prompt),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}

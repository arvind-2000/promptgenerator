import 'package:flutter/material.dart';

import '../prompt/taxonomy.dart';

/// Two horizontally-scrolling chip rows: tech stack on top, lifecycle
/// stage below. Selecting the already-selected chip clears that filter.
class StackStageFilter extends StatelessWidget {
  final String? selectedStack;
  final String? selectedStage;
  final ValueChanged<String?> onStackChanged;
  final ValueChanged<String?> onStageChanged;

  const StackStageFilter({
    super.key,
    required this.selectedStack,
    required this.selectedStage,
    required this.onStackChanged,
    required this.onStageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChipRow(options: PromptStack.all, selected: selectedStack, onSelected: onStackChanged),
        const SizedBox(height: 6),
        _ChipRow(options: PromptStage.all, selected: selectedStage, onSelected: onStageChanged),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<String> options;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _ChipRow({required this.options, required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelected(isSelected ? null : option),
            ),
          );
        }).toList(),
      ),
    );
  }
}

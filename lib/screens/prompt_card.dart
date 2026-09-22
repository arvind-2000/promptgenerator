import 'package:flutter/material.dart';

import '../prompt/prompt.dart';
import '../prompt/prompt_template_service.dart';

/// The reusable "card" used everywhere a prompt is listed.
class PromptCard extends StatelessWidget {
  final Prompt prompt;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onCopy;

  const PromptCard({
    super.key,
    required this.prompt,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    final variables = PromptTemplateService.extractVariables(prompt.prompt);
    final isTemplate = variables.isNotEmpty;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      prompt.act,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      prompt.isFavorite ? Icons.star : Icons.star_border,
                      color: prompt.isFavorite ? Colors.amber : null,
                    ),
                    onPressed: onFavoriteToggle,
                    tooltip: 'Favorite',
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                prompt.prompt,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.75)),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _Badge(text: prompt.stack),
                  const SizedBox(width: 6),
                  _Badge(text: prompt.stage),
                  if (isTemplate) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: scheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.tune, size: 12, color: scheme.onTertiaryContainer),
                          const SizedBox(width: 4),
                          Text(
                            '${variables.length} ${variables.length == 1 ? 'var' : 'vars'}',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: scheme.onTertiaryContainer),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: onCopy,
                    tooltip: 'Copy raw prompt',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: scheme.onPrimaryContainer)),
    );
  }
}

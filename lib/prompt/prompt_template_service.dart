/// Represents a dynamic variable placeholder inside a prompt template.
class PromptVariable {
  /// The full token as found in the text, e.g. `{MigrationTool, e.g. Flyway or EF Core}`.
  final String rawToken;

  /// Clean variable name, e.g. `MigrationTool`.
  final String name;

  /// Optional hint or recommended options, e.g. `Flyway or EF Core` or `CSS, Tailwind, or Bootstrap`.
  final String hint;

  const PromptVariable({
    required this.rawToken,
    required this.name,
    this.hint = '',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptVariable &&
          runtimeType == other.runtimeType &&
          rawToken == other.rawToken &&
          name == other.name;

  @override
  int get hashCode => rawToken.hashCode ^ name.hashCode;
}

/// Service to detect, parse, and interpolate dynamic variables in prompt templates.
class PromptTemplateService {
  static final RegExp _placeholderRegex = RegExp(r'\{([^}]+)\}');

  /// Checks if the given prompt contains any dynamic variables.
  static bool hasVariables(String text) {
    return _placeholderRegex.hasMatch(text);
  }

  /// Extracts unique dynamic variables from the prompt text in order of appearance.
  static List<PromptVariable> extractVariables(String text) {
    final matches = _placeholderRegex.allMatches(text);
    final seen = <String>{};
    final variables = <PromptVariable>[];

    for (final match in matches) {
      final rawToken = match.group(0)!;
      final inner = match.group(1)!.trim();

      String name = inner;
      String hint = '';

      if (inner.contains(', e.g. ')) {
        final parts = inner.split(', e.g. ');
        name = parts[0].trim();
        hint = parts.length > 1 ? parts[1].trim() : '';
      } else if (inner.contains(', or ')) {
        // e.g. "CSS, Tailwind, or Bootstrap" or "Vercel, Netlify, or GitHub Pages"
        name = inner.split(',')[0].trim();
        hint = inner;
      } else if (inner.contains(':')) {
        final parts = inner.split(':');
        name = parts[0].trim();
        hint = parts.length > 1 ? parts[1].trim() : '';
      }

      if (!seen.contains(rawToken)) {
        seen.add(rawToken);
        variables.add(PromptVariable(
          rawToken: rawToken,
          name: name,
          hint: hint,
        ));
      }
    }

    return variables;
  }

  /// Substitutes variable values into the template.
  /// If a value is missing or empty, it retains the placeholder token (or uses hint if [fillEmptyWithHint] is true).
  static String interpolate(
    String template,
    Map<String, String> values, {
    bool fillEmptyWithHint = false,
  }) {
    final variables = extractVariables(template);
    String result = template;

    for (final variable in variables) {
      final val = values[variable.name]?.trim() ?? values[variable.rawToken]?.trim();
      if (val != null && val.isNotEmpty) {
        result = result.replaceAll(variable.rawToken, val);
      } else if (fillEmptyWithHint && variable.hint.isNotEmpty) {
        result = result.replaceAll(variable.rawToken, variable.hint);
      }
    }

    return result;
  }
}

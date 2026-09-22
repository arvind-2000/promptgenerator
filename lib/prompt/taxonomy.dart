/// Tech-stack categorization for prompts.
class PromptStack {
  static const dotnet = '.NET';
  static const sql = 'SQL';
  static const postgres = 'PostgreSQL';
  static const dart = 'Dart';
  static const flutter = 'Flutter';
  static const react = 'React';
  static const css = 'CSS';
  static const bootstrap = 'Bootstrap';
  static const general = 'General';

  static const all = [
    dotnet,
    sql,
    postgres,
    dart,
    flutter,
    react,
    css,
    bootstrap,
    general,
  ];
}

/// Lifecycle-stage categorization for prompts.
class PromptStage {
  static const scratch = 'From Scratch';
  static const helpers = 'Helper Functions';
  static const uiCards = 'UI / Cards';
  static const deployment = 'Deployment';
  static const other = 'Other';

  static const all = [scratch, helpers, uiCards, deployment, other];
}

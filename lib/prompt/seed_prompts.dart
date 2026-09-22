import 'package:promptgenerator/prompt/prompt.dart';
import 'package:promptgenerator/prompt/taxonomy.dart';

/// Hand-written starter prompts covering common stacks and lifecycle
/// stages. These are not pulled from any external API — they're a
/// small seed set to bootstrap the .NET / SQL / PostgreSQL / Dart /
/// Flutter / React / CSS / Bootstrap categories. Add your own
/// alongside them as you go.
final List<Prompt> curatedSeedPrompts = [
  // ---- .NET ----
  Prompt(
    id: 'dotnet_scratch_1',
    act: '.NET Web API Scaffold',
    prompt:
        'Scaffold a new ASP.NET Core Web API project named {ProjectName} '
        'using .NET 8, minimal APIs, EF Core with SQL Server, and a clean '
        'folder structure (Controllers, Services, Repositories, DTOs). '
        'Include Swagger and a basic health-check endpoint.',
    tags: const ['dotnet', 'webapi', 'scaffold'],
    category: 'Custom',
    stack: PromptStack.dotnet,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'dotnet_helpers_1',
    act: '.NET Extension Methods',
    prompt:
        'Write a set of C# extension methods for {ClassName} that handle '
        'null-checking, pagination of an IQueryable<T>, and converting a '
        'DateTime to a UTC ISO 8601 string.',
    tags: const ['dotnet', 'csharp', 'helpers'],
    category: 'Custom',
    stack: PromptStack.dotnet,
    stage: PromptStage.helpers,
  ),
  Prompt(
    id: 'dotnet_deploy_1',
    act: '.NET CI/CD to Azure',
    prompt:
        'Write a GitHub Actions workflow that builds a .NET 8 Web API, '
        'runs unit tests, publishes a Docker image, and deploys it to Azure '
        'App Service on push to main.',
    tags: const ['dotnet', 'cicd', 'azure'],
    category: 'Custom',
    stack: PromptStack.dotnet,
    stage: PromptStage.deployment,
  ),

  // ---- SQL ----
  Prompt(
    id: 'sql_scratch_1',
    act: 'SQL Schema Design',
    prompt:
        'Design a normalized relational schema (3NF) for '
        '{DomainDescription}, including primary/foreign keys, and generate '
        'the CREATE TABLE statements.',
    tags: const ['sql', 'schema'],
    category: 'Custom',
    stack: PromptStack.sql,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'sql_helpers_1',
    act: 'SQL Paginated Search Procedure',
    prompt:
        'Write a reusable stored procedure that performs paginated '
        'search across {TableName} with optional filters, sorting, and '
        'returns the total row count.',
    tags: const ['sql', 'stored-procedure'],
    category: 'Custom',
    stack: PromptStack.sql,
    stage: PromptStage.helpers,
  ),

  // ---- PostgreSQL ----
  Prompt(
    id: 'postgres_scratch_1',
    act: 'Postgres Migrations',
    prompt:
        'Write a set of PostgreSQL migration scripts (using '
        '{MigrationTool, e.g. Flyway or EF Core}) to create the schema for '
        '{DomainDescription}, including indexes on foreign keys.',
    tags: const ['postgres', 'migrations'],
    category: 'Custom',
    stack: PromptStack.postgres,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'postgres_helpers_1',
    act: 'Postgres Audit Upsert Function',
    prompt:
        'Write a PL/pgSQL function that upserts a row into {TableName} '
        'and logs the change into an audit table with old/new values as '
        'JSONB.',
    tags: const ['postgres', 'plpgsql'],
    category: 'Custom',
    stack: PromptStack.postgres,
    stage: PromptStage.helpers,
  ),
  Prompt(
    id: 'postgres_deploy_1',
    act: 'Postgres Docker Compose',
    prompt:
        'Write a docker-compose.yml that runs PostgreSQL 16 with a '
        'persistent volume, an initial seed script, and health checks, '
        'ready for local development.',
    tags: const ['postgres', 'docker'],
    category: 'Custom',
    stack: PromptStack.postgres,
    stage: PromptStage.deployment,
  ),

  // ---- Dart ----
  Prompt(
    id: 'dart_scratch_1',
    act: 'Dart Package Scaffold',
    prompt:
        'Scaffold a new Dart package named {PackageName} with a clean '
        'lib/ structure, pubspec.yaml, an example/ folder, and a basic unit '
        'test setup using package:test.',
    tags: const ['dart', 'package', 'scaffold'],
    category: 'Custom',
    stack: PromptStack.dart,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'dart_helpers_1',
    act: 'Dart Validation Extensions',
    prompt:
        'Write a set of Dart extension methods on String and List<T> '
        'for common validation (isEmail, isNotNullOrEmpty) and null-safe '
        'access.',
    tags: const ['dart', 'helpers'],
    category: 'Custom',
    stack: PromptStack.dart,
    stage: PromptStage.helpers,
  ),

  // ---- Flutter ----
  Prompt(
    id: 'flutter_scratch_1',
    act: 'Flutter App Scaffold',
    prompt:
        'Scaffold a new Flutter app named {AppName} using go_router for '
        'navigation, Provider (or Riverpod) for state management, and a '
        'clean lib/ structure (models, services, screens, widgets).',
    tags: const ['flutter', 'scaffold'],
    category: 'Custom',
    stack: PromptStack.flutter,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'flutter_helpers_1',
    act: 'Flutter UI Helper Functions',
    prompt:
        'Write a set of Flutter helper functions for showing a loading '
        'dialog, a snackbar, and safely navigating with go_router, all '
        'reusable across screens.',
    tags: const ['flutter', 'helpers'],
    category: 'Custom',
    stack: PromptStack.flutter,
    stage: PromptStage.helpers,
  ),
  Prompt(
    id: 'flutter_ui_1',
    act: 'Flutter Reusable Card Widget',
    prompt:
        'Build a reusable Flutter widget called {WidgetName}Card that '
        'displays a title, subtitle, leading icon, and trailing action '
        'button, following Material 3 styling, with a tap callback.',
    tags: const ['flutter', 'widget', 'card'],
    category: 'Custom',
    stack: PromptStack.flutter,
    stage: PromptStage.uiCards,
  ),
  Prompt(
    id: 'flutter_deploy_1',
    act: 'Flutter Store Deployment',
    prompt:
        'Write step-by-step instructions and the exact commands to '
        'build and deploy a Flutter app to the Google Play Store (release '
        'AAB) and Apple App Store (release IPA), including versioning and '
        'signing.',
    tags: const ['flutter', 'deployment'],
    category: 'Custom',
    stack: PromptStack.flutter,
    stage: PromptStage.deployment,
  ),

  // ---- React ----
  Prompt(
    id: 'react_scratch_1',
    act: 'React App Scaffold',
    prompt:
        'Scaffold a new React app named {AppName} using Vite and '
        'TypeScript, React Router, and a clean src/ structure (components, '
        'hooks, pages, services).',
    tags: const ['react', 'scaffold'],
    category: 'Custom',
    stack: PromptStack.react,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'react_helpers_1',
    act: 'React Custom Hook',
    prompt:
        'Write a custom React hook called use{HookName} that handles '
        '{DataFetchingLogic}, including loading, error, and retry state.',
    tags: const ['react', 'hooks'],
    category: 'Custom',
    stack: PromptStack.react,
    stage: PromptStage.helpers,
  ),
  Prompt(
    id: 'react_ui_1',
    act: 'React Reusable Card Component',
    prompt:
        'Build a reusable React component called {ComponentName}Card '
        'that takes title, description, image, and an onClick prop, styled '
        'with {CSS, Tailwind, or Bootstrap}.',
    tags: const ['react', 'component', 'card'],
    category: 'Custom',
    stack: PromptStack.react,
    stage: PromptStage.uiCards,
  ),
  Prompt(
    id: 'react_deploy_1',
    act: 'React Deployment Pipeline',
    prompt:
        'Write a GitHub Actions workflow that builds a React + Vite app '
        'and deploys the static output to {Vercel, Netlify, or GitHub '
        'Pages} on push to main.',
    tags: const ['react', 'cicd'],
    category: 'Custom',
    stack: PromptStack.react,
    stage: PromptStage.deployment,
  ),

  // ---- CSS ----
  Prompt(
    id: 'css_ui_1',
    act: 'CSS Responsive Card Grid',
    prompt:
        'Write plain CSS for a responsive card component with a '
        'hover-lift effect, rounded corners, a shadow, and a fixed-ratio '
        'image, using CSS Grid for a 3-column layout that collapses to 1 '
        'column on mobile.',
    tags: const ['css', 'card', 'grid'],
    category: 'Custom',
    stack: PromptStack.css,
    stage: PromptStage.uiCards,
  ),
  Prompt(
    id: 'css_helpers_1',
    act: 'CSS Utility Classes',
    prompt:
        'Write a set of reusable CSS utility classes (spacing, flex, '
        'text truncation) following a BEM-like naming convention, without '
        'a framework.',
    tags: const ['css', 'utilities'],
    category: 'Custom',
    stack: PromptStack.css,
    stage: PromptStage.helpers,
  ),

  // ---- Bootstrap ----
  Prompt(
    id: 'bootstrap_scratch_1',
    act: 'Bootstrap Project Setup',
    prompt:
        'Set up a new project using Bootstrap 5 via CDN, including a '
        'responsive navbar, a container-based grid layout, and a custom '
        'SCSS override file for the primary color palette.',
    tags: const ['bootstrap', 'scaffold'],
    category: 'Custom',
    stack: PromptStack.bootstrap,
    stage: PromptStage.scratch,
  ),
  Prompt(
    id: 'bootstrap_ui_1',
    act: 'Bootstrap Card Deck',
    prompt:
        'Build a Bootstrap 5 card component with an image-top, title, '
        'text, and two footer buttons, arranged in a responsive 3-per-row '
        'layout using the grid system.',
    tags: const ['bootstrap', 'card'],
    category: 'Custom',
    stack: PromptStack.bootstrap,
    stage: PromptStage.uiCards,
  ),
];

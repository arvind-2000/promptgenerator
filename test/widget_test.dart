import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promptgenerator/prompt/prompt.dart';
import 'package:promptgenerator/prompt/taxonomy.dart';
import 'package:promptgenerator/screens/prompt_card.dart';
import 'package:promptgenerator/screens/prompt_detail_screen.dart';

void main() {
  group('PromptCard Widget Tests', () {
    testWidgets('renders prompt details and parameter badge for templates', (WidgetTester tester) async {
      final prompt = Prompt(
        id: 'test_1',
        act: 'Test Scaffold API',
        prompt: 'Create an API named {ProjectName} using {Database, e.g. Postgres}.',
        stack: PromptStack.dotnet,
        stage: PromptStage.scratch,
      );

      bool tapped = false;
      bool favoriteToggled = false;
      bool copied = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PromptCard(
              prompt: prompt,
              onTap: () => tapped = true,
              onFavoriteToggle: () => favoriteToggled = true,
              onCopy: () => copied = true,
            ),
          ),
        ),
      );

      expect(find.text('Test Scaffold API'), findsOneWidget);
      expect(find.text('.NET'), findsOneWidget);
      expect(find.text('From Scratch'), findsOneWidget);
      expect(find.text('2 vars'), findsOneWidget);

      await tester.tap(find.text('Test Scaffold API'));
      expect(tapped, isTrue);

      await tester.tap(find.byTooltip('Favorite'));
      expect(favoriteToggled, isTrue);

      await tester.tap(find.byTooltip('Copy raw prompt'));
      expect(copied, isTrue);
    });
  });

  group('PromptDetailScreen Generator Tests', () {
    testWidgets('populates parameters and generates live preview in real time', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final prompt = Prompt(
        id: 'test_gen',
        act: 'React Hook Generator',
        prompt: 'Build a hook use{HookName} with {DataFetchingLogic, e.g. TanStack Query or SWR}.',
        stack: PromptStack.react,
        stage: PromptStage.helpers,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: PromptDetailScreen(prompt: prompt),
        ),
      );

      // Verify parameters are detected and inputs rendered
      expect(find.text('Customize Parameters'), findsOneWidget);
      expect(find.text('Ready-to-Use Prompt'), findsOneWidget);
      expect(find.text('HookName'), findsOneWidget);
      expect(find.text('DataFetchingLogic'), findsOneWidget);

      // Verify initial preview contains template placeholders (findRichText: true for SelectableText)
      expect(
        find.text(
          'Build a hook use{HookName} with {DataFetchingLogic, e.g. TanStack Query or SWR}.',
          findRichText: true,
        ),
        findsOneWidget,
      );

      // Enter value in HookName field
      final hookField = find.widgetWithText(TextField, 'HookName');
      await tester.enterText(hookField, 'UserProfile');
      await tester.pump();

      // Check live updated preview
      expect(
        find.text(
          'Build a hook useUserProfile with {DataFetchingLogic, e.g. TanStack Query or SWR}.',
          findRichText: true,
        ),
        findsOneWidget,
      );

      // Test suggestion chip selection
      expect(find.text('TanStack Query'), findsOneWidget);
      await tester.tap(find.text('TanStack Query'));
      await tester.pump();

      // Check fully generated prompt
      expect(
        find.text(
          'Build a hook useUserProfile with TanStack Query.',
          findRichText: true,
        ),
        findsOneWidget,
      );
    });
  });
}

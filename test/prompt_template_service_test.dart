import 'package:flutter_test/flutter_test.dart';
import 'package:promptgenerator/prompt/prompt_template_service.dart';

void main() {
  group('PromptTemplateService', () {
    test('hasVariables detects template placeholders accurately', () {
      expect(
        PromptTemplateService.hasVariables('Scaffold a project named {ProjectName}'),
        isTrue,
      );
      expect(
        PromptTemplateService.hasVariables('Plain prompt with no brackets'),
        isFalse,
      );
    });

    test('extractVariables extracts simple, hint, and choice variables', () {
      const template =
          'Scaffold {ProjectName} using {MigrationTool, e.g. Flyway or EF Core} and {CSS, Tailwind, or Bootstrap}. Another {ProjectName} reference.';

      final variables = PromptTemplateService.extractVariables(template);

      expect(variables.length, 3);

      expect(variables[0].name, 'ProjectName');
      expect(variables[0].rawToken, '{ProjectName}');
      expect(variables[0].hint, '');

      expect(variables[1].name, 'MigrationTool');
      expect(variables[1].rawToken, '{MigrationTool, e.g. Flyway or EF Core}');
      expect(variables[1].hint, 'Flyway or EF Core');

      expect(variables[2].name, 'CSS');
      expect(variables[2].rawToken, '{CSS, Tailwind, or Bootstrap}');
      expect(variables[2].hint, 'CSS, Tailwind, or Bootstrap');
    });

    test('interpolate replaces variables with user provided values', () {
      const template =
          'Create a Web API named {ProjectName} for class {ClassName}. Re-verify {ProjectName}.';

      final interpolated = PromptTemplateService.interpolate(
        template,
        {
          'ProjectName': 'InventoryService',
          'ClassName': 'ProductController',
        },
      );

      expect(
        interpolated,
        'Create a Web API named InventoryService for class ProductController. Re-verify InventoryService.',
      );
    });

    test('interpolate preserves unreplaced variables when values are empty', () {
      const template = 'Scaffold {ProjectName} with {MigrationTool, e.g. Flyway or EF Core}';

      final interpolated = PromptTemplateService.interpolate(
        template,
        {'ProjectName': 'MyApp'},
        fillEmptyWithHint: false,
      );

      expect(
        interpolated,
        'Scaffold MyApp with {MigrationTool, e.g. Flyway or EF Core}',
      );
    });

    test('interpolate fills hints when fillEmptyWithHint is enabled', () {
      const template = 'Scaffold {ProjectName} with {MigrationTool, e.g. Flyway or EF Core}';

      final interpolated = PromptTemplateService.interpolate(
        template,
        {'ProjectName': 'MyApp'},
        fillEmptyWithHint: true,
      );

      expect(interpolated, 'Scaffold MyApp with Flyway or EF Core');
    });
  });
}

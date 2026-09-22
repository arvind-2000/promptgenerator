import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:promptgenerator/prompt/prompt_fetch_service.dart';

class _RenamedDatasetClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final responseBody = utf8.encode(
      jsonEncode({'error': 'The dataset has been renamed. Please use the current dataset name.'}),
    );
    return http.StreamedResponse(
      Stream.value(responseBody),
      404,
      headers: {'content-type': 'application/json'},
    );
  }
}

void main() {
  test('fetchAllSeedPrompts handles renamed dataset gracefully', () async {
    final service = PromptFetchService(client: _RenamedDatasetClient());

    final prompts = await service.fetchAllSeedPrompts();

    expect(prompts, isEmpty);
  });
}

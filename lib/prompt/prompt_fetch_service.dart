import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:promptgenerator/prompt/prompt.dart';

/// Pulls seed prompts from the public, free Hugging Face Datasets Server
/// API — no API key required for public datasets.
class PromptFetchService {
  static const _baseUrl = 'https://datasets-server.huggingface.co/rows';
  static const _dataset = 'fka/awesome-chatgpt-prompts';

  final http.Client _client;

  PromptFetchService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Prompt>> fetchSeedPrompts({int offset = 0, int length = 100}) async {
    final uri = Uri.parse(
      '$_baseUrl?dataset=$_dataset&config=default&split=train&offset=$offset&length=$length',
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      return [];
    }

    final Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
    final List<dynamic> rows = body['rows'] as List<dynamic>? ?? [];
    return rows.map((row) => Prompt.fromHuggingFaceRow(row as Map<String, dynamic>)).toList();
  }

  /// Pages through the whole dataset (~170 prompts) until an empty page comes back.
  Future<List<Prompt>> fetchAllSeedPrompts() async {
    final all = <Prompt>[];
    int offset = 0;
    const pageSize = 100;

    while (true) {
      try {
        final page = await fetchSeedPrompts(offset: offset, length: pageSize);
        if (page.isEmpty) break;
        all.addAll(page);
        offset += pageSize;
      } catch (_) {
        break;
      }
    }
    return all;
  }
}

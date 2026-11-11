import 'dart:convert';

import 'package:http/http.dart' as http;

import '../client.dart';

/// Lightweight Serverpod HTTP RPC caller for talking to any of the 5 backend
/// branches from one Flutter Web app, reusing the active client's auth header.
class MultiBackendRpc {
  static Future<dynamic> call({
    required String baseUrl,
    required String endpoint,
    required String method,
    Map<String, dynamic> args = const {},
    bool includeAuth = true,
  }) async {
    final normalized = normalizeServerUrl(baseUrl);
    final url = Uri.parse('$normalized$endpoint/$method');
    final authHeader = includeAuth
        ? await client.authKeyProvider?.authHeaderValue
        : null;

    final response = await http
        .post(
          url,
          body: jsonEncode(args),
          headers: {
            'authorization': ?authHeader,
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'HTTP ${response.statusCode} from $endpoint/$method: '
        '${response.body.isEmpty ? "Request failed" : response.body}',
      );
    }

    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}

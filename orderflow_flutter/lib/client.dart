import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:orderflow_client/orderflow_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

Client? _client;

/// Active Serverpod client targeting the currently selected backend URL.
Client get client {
  final current = _client;
  if (current == null) {
    throw StateError('Client not initialized. Call initializeClient() first.');
  }
  return current;
}

/// Notifies widgets whenever the active backend URL or client instance changes.
final ValueNotifier<String> serverUrlNotifier = ValueNotifier<String>(
  'http://localhost:8080/',
);

String normalizeServerUrl(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return 'http://localhost:8080/';
  final withScheme =
      trimmed.startsWith('http://') || trimmed.startsWith('https://')
          ? trimmed
          : 'http://$trimmed';
  return withScheme.endsWith('/') ? withScheme : '$withScheme/';
}

/// Initializes or switches the global [client] to [overrideUrl] (or the default
/// configured server URL from `assets/config.json` / `--dart-define=SERVER_URL`).
Future<void> initializeClient({String? overrideUrl}) async {
  final resolvedUrl = normalizeServerUrl(
    overrideUrl ?? await getServerUrl(),
  );

  _client?.close();
  final nextClient = Client(resolvedUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
  _client = nextClient;
  serverUrlNotifier.value = resolvedUrl;
  unawaited(nextClient.auth.initialize());
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

/// A single logged RPC call or connection event shown in the web console.
class RpcLogEntry {
  final DateTime timestamp;
  final String action;
  final String serverUrl;
  final bool isError;
  final String payload;

  RpcLogEntry({
    required this.timestamp,
    required this.action,
    required this.serverUrl,
    required this.isError,
    required this.payload,
  });
}

String prettyJson(Object? value) {
  if (value == null) return 'null';
  try {
    return const JsonEncoder.withIndent('  ').convert(value);
  } catch (_) {
    return value.toString();
  }
}

/// Shared Flutter Web dashboard shell with runtime backend URL switching,
/// greeting health ping, authentication dialog, and an RPC output log.
class BackendShell extends StatefulWidget {
  final String patternTag;
  final String patternTitle;
  final String patternDescription;
  final List<RpcLogEntry> logs;
  final VoidCallback onClearLogs;
  final void Function(String action, Object? result, {bool isError}) onLog;
  final VoidCallback? onClientChanged;
  final bool showAuth;
  final Widget child;

  const BackendShell({
    super.key,
    required this.patternTag,
    required this.patternTitle,
    required this.patternDescription,
    required this.logs,
    required this.onClearLogs,
    required this.onLog,
    required this.child,
    this.onClientChanged,
    this.showAuth = false,
  });

  @override
  State<BackendShell> createState() => _BackendShellState();
}

class _BackendShellState extends State<BackendShell> {
  late final TextEditingController _urlController;
  bool _pinging = false;
  bool? _connected;
  String? _statusMessage;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: serverUrlNotifier.value);
    serverUrlNotifier.addListener(_syncUrlField);
    client.auth.authInfoListenable.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    serverUrlNotifier.removeListener(_syncUrlField);
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    _urlController.dispose();
    super.dispose();
  }

  void _syncUrlField() {
    if (_urlController.text != serverUrlNotifier.value) {
      _urlController.text = serverUrlNotifier.value;
    }
    setState(() {});
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _connectToUrl(String rawUrl) async {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    await initializeClient(overrideUrl: rawUrl);
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    widget.onClientChanged?.call();
    await _pingBackend();
  }

  Future<void> _pingBackend() async {
    setState(() {
      _pinging = true;
      _statusMessage = 'Checking connection...';
    });
    try {
      final greeting = await client.greeting.hello('OrderFlow Web');
      widget.onLog('greeting.hello', greeting.toJson());
      if (mounted) {
        setState(() {
          _connected = true;
          _statusMessage = greeting.message;
        });
      }
    } catch (e) {
      widget.onLog('greeting.hello', '$e', isError: true);
      if (mounted) {
        setState(() {
          _connected = false;
          _statusMessage = 'Unreachable';
        });
      }
    } finally {
      if (mounted) setState(() => _pinging = false);
    }
  }

  Future<void> _openAuthDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Serverpod Authentication'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: SignInWidget(
                client: client,
                onAuthenticated: () {
                  widget.onLog('auth.signIn', 'Authenticated successfully');
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                onError: (error) {
                  widget.onLog('auth.signIn', '$error', isError: true);
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _signOut() async {
    await client.auth.signOutDevice();
    widget.onLog('auth.signOutDevice', 'Signed out');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isAuthenticated = client.auth.isAuthenticated;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.patternTag,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'OrderFlow Web · ${widget.patternTitle}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (widget.showAuth)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: isAuthenticated
                  ? FilledButton.tonalIcon(
                      onPressed: _signOut,
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Sign Out'),
                    )
                  : OutlinedButton.icon(
                      onPressed: _openAuthDialog,
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Sign In'),
                    ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildConnectionBar(context, colors, isAuthenticated),
          const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 980;
                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: widget.child,
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(
                        flex: 2,
                        child: _buildLogPanel(context, colors),
                      ),
                    ],
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.child,
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 360,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: _buildLogPanel(context, colors),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionBar(
    BuildContext context,
    ColorScheme colors,
    bool isAuthenticated,
  ) {
    final statusColor = switch (_connected) {
      true => Colors.green,
      false => colors.error,
      null => colors.outline,
    };

    return Container(
      color: colors.surfaceContainerLow,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 320,
            child: TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                isDense: true,
                labelText: 'Serverpod Backend URL',
                hintText: 'http://localhost:8080/',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.dns_outlined, size: 18),
              ),
              onSubmitted: _connectToUrl,
            ),
          ),
          FilledButton.icon(
            onPressed: _pinging ? null : () => _connectToUrl(_urlController.text),
            icon: _pinging
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync, size: 18),
            label: const Text('Connect & Ping'),
          ),
          for (final port in const [8080, 8081, 8082, 8083, 8084])
            ActionChip(
              label: Text(':$port'),
              onPressed: () => _connectToUrl('http://localhost:$port/'),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: statusColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 10, color: statusColor),
                const SizedBox(width: 6),
                Text(
                  _statusMessage ??
                      (_connected == null ? 'Not pinged' : 'Ready'),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          if (widget.showAuth)
            Chip(
              avatar: Icon(
                isAuthenticated ? Icons.verified_user : Icons.person_outline,
                size: 16,
              ),
              label: Text(isAuthenticated ? 'Authenticated' : 'Guest'),
            ),
          Text(
            widget.patternDescription,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogPanel(BuildContext context, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
          child: Row(
            children: [
              const Icon(Icons.terminal, size: 18),
              const SizedBox(width: 8),
              Text(
                'RPC Response Console',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: widget.logs.isEmpty ? null : widget.onClearLogs,
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: widget.logs.isEmpty
              ? Center(
                  child: Text(
                    'Trigger any endpoint to inspect responses here.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: widget.logs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = widget.logs[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: entry.isError
                            ? colors.errorContainer.withValues(alpha: 0.45)
                            : colors.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: entry.isError
                              ? colors.error.withValues(alpha: 0.5)
                              : colors.outlineVariant,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.action,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                              Text(
                                entry.serverUrl,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            entry.payload,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

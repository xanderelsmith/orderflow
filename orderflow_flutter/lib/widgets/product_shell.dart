import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

class ActivityLogItem {
  final DateTime timestamp;
  final String action;
  final bool isError;
  final String detail;

  ActivityLogItem({
    required this.timestamp,
    required this.action,
    required this.isError,
    required this.detail,
  });
}

String prettyPayload(Object? value) {
  if (value == null) return 'null';
  try {
    return const JsonEncoder.withIndent('  ').convert(value);
  } catch (_) {
    return value.toString();
  }
}

/// Clean minimal product web shell for OrderFlow.
/// Keeps server-URL configuration and RPC logs tucked into compact dialogs/sheets
/// so the main canvas feels like a real product web app.
class ProductShell extends StatefulWidget {
  final String editionLabel;
  final String subtitle;
  final bool showAuth;
  final List<ActivityLogItem> activity;
  final VoidCallback onClearActivity;
  final void Function(String action, Object? detail, {bool isError}) onLog;
  final VoidCallback? onClientChanged;
  final Widget child;

  const ProductShell({
    super.key,
    required this.editionLabel,
    required this.subtitle,
    required this.activity,
    required this.onClearActivity,
    required this.onLog,
    required this.child,
    this.showAuth = false,
    this.onClientChanged,
  });

  @override
  State<ProductShell> createState() => _ProductShellState();
}

class _ProductShellState extends State<ProductShell> {
  bool? _connected;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    _pingServer(silent: true);
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _pingServer({bool silent = false}) async {
    if (mounted) setState(() => _checking = true);
    try {
      final res = await client.greeting.hello('OrderFlow');
      if (!silent) widget.onLog('greeting.hello', res.toJson());
      if (mounted) setState(() => _connected = true);
    } catch (e) {
      if (!silent) widget.onLog('greeting.hello', '$e', isError: true);
      if (mounted) setState(() => _connected = false);
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _openServerSettings() async {
    final controller = TextEditingController(text: serverUrlNotifier.value);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Backend Connection'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Serverpod URL',
                    hintText: 'http://localhost:8080/',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final port in const [8080, 8081, 8082, 8083, 8084])
                      ActionChip(
                        label: Text(':$port'),
                        onPressed: () {
                          controller.text = 'http://localhost:$port/';
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final nextUrl = controller.text;
                Navigator.of(dialogContext).pop();
                client.auth.authInfoListenable.removeListener(_onAuthChanged);
                await initializeClient(overrideUrl: nextUrl);
                client.auth.authInfoListenable.addListener(_onAuthChanged);
                widget.onClientChanged?.call();
                await _pingServer();
              },
              child: const Text('Connect'),
            ),
          ],
        );
      },
    );
    controller.dispose();
  }

  Future<void> _openAuthDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign in to OrderFlow'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: SignInWidget(
                client: client,
                onAuthenticated: () {
                  widget.onLog('auth.signIn', 'Signed in');
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                onError: (err) {
                  widget.onLog('auth.signIn', '$err', isError: true);
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

  void _openActivityDrawer() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        final colors = Theme.of(sheetContext).colorScheme;
        return SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.55,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 10),
                child: Row(
                  children: [
                    const Icon(Icons.terminal, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Architecture & RPC Activity',
                      style: Theme.of(sheetContext).textTheme.titleSmall,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: widget.activity.isEmpty
                          ? null
                          : () {
                              widget.onClearActivity();
                              Navigator.of(sheetContext).pop();
                            },
                      child: const Text('Clear'),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: widget.activity.isEmpty
                    ? Center(
                        child: Text(
                          'No backend calls recorded yet.',
                          style: Theme.of(sheetContext).textTheme.bodySmall,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: widget.activity.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = widget.activity[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.isError
                                  ? colors.errorContainer.withValues(alpha: 0.4)
                                  : colors.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.action,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                SelectableText(
                                  item.detail,
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isAuth = client.auth.isAuthenticated;
    final dotColor = switch (_connected) {
      true => Colors.green,
      false => colors.error,
      null => colors.outline,
    };

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: colors.surfaceContainerLow,
        titleSpacing: 24,
        title: Row(
          children: [
            Icon(Icons.storefront_rounded, color: colors.primary),
            const SizedBox(width: 10),
            const Text(
              'OrderFlow',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.editionLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Tooltip(
            message: 'Backend: ${serverUrlNotifier.value}',
            child: TextButton.icon(
              onPressed: _openServerSettings,
              icon: _checking
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.circle, size: 10, color: dotColor),
              label: Text(
                _connected == true
                    ? 'Connected'
                    : _connected == false
                        ? 'Offline'
                        : 'Server',
              ),
            ),
          ),
          IconButton(
            tooltip: 'RPC Activity (${widget.activity.length})',
            onPressed: _openActivityDrawer,
            icon: Badge.count(
              isLabelVisible: widget.activity.isNotEmpty,
              count: widget.activity.length,
              child: const Icon(Icons.terminal_outlined),
            ),
          ),
          if (widget.showAuth) ...[
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: isAuth
                  ? FilledButton.tonalIcon(
                      onPressed: () async {
                        await client.auth.signOutDevice();
                        widget.onLog('auth.signOutDevice', 'Signed out');
                      },
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Account'),
                    )
                  : FilledButton.icon(
                      onPressed: _openAuthDialog,
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Sign In'),
                    ),
            ),
          ] else
            const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 20),
                      widget.child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

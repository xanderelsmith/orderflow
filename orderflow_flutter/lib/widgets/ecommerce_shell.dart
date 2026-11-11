import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';

class ActivityLogItem {
  final DateTime timestamp;
  final String action;
  final String summary;
  final bool isError;
  final String detail;

  ActivityLogItem({
    required this.timestamp,
    required this.action,
    required this.summary,
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

class ShopProduct {
  final String sku;
  final String name;
  final String subtitle;
  final double price;
  final IconData icon;

  const ShopProduct({
    required this.sku,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.icon,
  });
}

const shopCatalog = [
  ShopProduct(
    sku: 'ROAST-01',
    name: 'Ethiopia Single Origin',
    subtitle: '250g Whole Bean · Light Roast',
    price: 18.50,
    icon: Icons.coffee,
  ),
  ShopProduct(
    sku: 'GEAR-02',
    name: 'Pour-Over Glass Dripper',
    subtitle: 'Borosilicate Carafe',
    price: 34.00,
    icon: Icons.local_cafe_outlined,
  ),
  ShopProduct(
    sku: 'SCALE-03',
    name: 'Precision Brew Scale',
    subtitle: '0.1g · USB-C Rechargeable',
    price: 59.00,
    icon: Icons.scale_outlined,
  ),
  ShopProduct(
    sku: 'PACK-04',
    name: 'Explorer Starter Kit',
    subtitle: 'Beans + Dripper + Filters',
    price: 45.00,
    icon: Icons.inventory_2_outlined,
  ),
];

/// Simple E-Commerce storefront shell with a top-bar "Monitor & Logs" button
/// that navigates to a dedicated monitoring and architecture activity screen.
class EcommerceShell extends StatefulWidget {
  final String patternBadge;
  final String architectureTitle;
  final String architectureFlow;
  final String architectureTradeoff;
  final bool showAuth;
  final ValueNotifier<List<ActivityLogItem>> activityNotifier;
  final VoidCallback onClearActivity;
  final void Function(String action, String summary, Object? detail,
      {bool isError}) onLog;
  final VoidCallback? onClientChanged;
  final Widget child;

  const EcommerceShell({
    super.key,
    required this.patternBadge,
    required this.architectureTitle,
    required this.architectureFlow,
    required this.architectureTradeoff,
    required this.activityNotifier,
    required this.onClearActivity,
    required this.onLog,
    required this.child,
    this.showAuth = false,
    this.onClientChanged,
  });

  @override
  State<EcommerceShell> createState() => _EcommerceShellState();
}

class _EcommerceShellState extends State<EcommerceShell> {
  bool? _connected;

  @override
  void initState() {
    super.initState();
    client.auth.authInfoListenable.addListener(_onAuthChanged);
    _ping(silent: true);
  }

  @override
  void dispose() {
    client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) setState(() {});
  }

  Future<bool> _ping({bool silent = false}) async {
    try {
      final res = await client.greeting.hello('OrderFlow Shop');
      if (!silent) {
        widget.onLog('greeting.hello', 'Server health ping OK', res.toJson());
      }
      if (mounted) setState(() => _connected = true);
      return true;
    } catch (e) {
      if (!silent) {
        widget.onLog('greeting.hello', 'Server unreachable', '$e', isError: true);
      }
      if (mounted) setState(() => _connected = false);
      return false;
    }
  }

  Future<void> _openAuthDialog() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Customer Sign In'),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: SignInWidget(
                client: client,
                onAuthenticated: () {
                  widget.onLog(
                    'auth.signIn',
                    'Customer authenticated',
                    {'status': 'signed_in'},
                  );
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                onError: (err) {
                  widget.onLog(
                    'auth.signIn',
                    'Authentication failed',
                    '$err',
                    isError: true,
                  );
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

  void _openMonitoringPage() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MonitoringPage(
          patternBadge: widget.patternBadge,
          architectureTitle: widget.architectureTitle,
          architectureFlow: widget.architectureFlow,
          architectureTradeoff: widget.architectureTradeoff,
          activityNotifier: widget.activityNotifier,
          onClearActivity: widget.onClearActivity,
          initialConnected: _connected,
          onPing: () => _ping(),
          onSwitchServer: (url) async {
            client.auth.authInfoListenable.removeListener(_onAuthChanged);
            await initializeClient(overrideUrl: url);
            client.auth.authInfoListenable.addListener(_onAuthChanged);
            widget.onClientChanged?.call();
            return await _ping();
          },
        ),
      ),
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
            Icon(Icons.local_mall_outlined, color: colors.primary),
            const SizedBox(width: 10),
            const Text(
              'OrderFlow Shop',
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
                widget.patternBadge,
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
          ValueListenableBuilder<List<ActivityLogItem>>(
            valueListenable: widget.activityNotifier,
            builder: (context, items, _) {
              return OutlinedButton.icon(
                onPressed: _openMonitoringPage,
                icon: Badge.count(
                  isLabelVisible: items.isNotEmpty,
                  count: items.length,
                  child: Icon(Icons.monitor_heart_outlined,
                      size: 18, color: dotColor),
                ),
                label: const Text('Monitor & Logs'),
              );
            },
          ),
          const SizedBox(width: 10),
          if (widget.showAuth)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: isAuth
                  ? FilledButton.tonalIcon(
                      onPressed: () async {
                        await client.auth.signOutDevice();
                        widget.onLog(
                          'auth.signOutDevice',
                          'Customer signed out',
                          {'status': 'signed_out'},
                        );
                      },
                      icon: const Icon(Icons.logout, size: 18),
                      label: const Text('Sign Out'),
                    )
                  : FilledButton.icon(
                      onPressed: _openAuthDialog,
                      icon: const Icon(Icons.login, size: 18),
                      label: const Text('Sign In'),
                    ),
            )
          else
            const SizedBox(width: 14),
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
                  child: widget.child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dedicated monitoring, server connection, and activity log page.
class MonitoringPage extends StatefulWidget {
  final String patternBadge;
  final String architectureTitle;
  final String architectureFlow;
  final String architectureTradeoff;
  final ValueNotifier<List<ActivityLogItem>> activityNotifier;
  final VoidCallback onClearActivity;
  final bool? initialConnected;
  final Future<bool> Function() onPing;
  final Future<bool> Function(String url) onSwitchServer;

  const MonitoringPage({
    super.key,
    required this.patternBadge,
    required this.architectureTitle,
    required this.architectureFlow,
    required this.architectureTradeoff,
    required this.activityNotifier,
    required this.onClearActivity,
    required this.initialConnected,
    required this.onPing,
    required this.onSwitchServer,
  });

  @override
  State<MonitoringPage> createState() => _MonitoringPageState();
}

class _MonitoringPageState extends State<MonitoringPage> {
  late final TextEditingController _urlController;
  bool? _connected;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: serverUrlNotifier.value);
    _connected = widget.initialConnected;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _connect(String url) async {
    setState(() => _checking = true);
    final ok = await widget.onSwitchServer(url);
    _urlController.text = serverUrlNotifier.value;
    if (mounted) {
      setState(() {
        _connected = ok;
        _checking = false;
      });
    }
  }

  Future<void> _ping() async {
    setState(() => _checking = true);
    final ok = await widget.onPing();
    if (mounted) {
      setState(() {
        _connected = ok;
        _checking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final statusColor = switch (_connected) {
      true => Colors.green,
      false => colors.error,
      null => colors.outline,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoring & Logs · ${widget.patternBadge}'),
        actions: [
          ValueListenableBuilder<List<ActivityLogItem>>(
            valueListenable: widget.activityNotifier,
            builder: (context, items, _) {
              return TextButton.icon(
                onPressed: items.isEmpty ? null : widget.onClearActivity,
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('Clear Logs'),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1080),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.account_tree_outlined,
                                color: colors.primary),
                            const SizedBox(width: 8),
                            Text(
                              widget.architectureTitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const Spacer(),
                            Chip(
                              avatar: Icon(Icons.circle,
                                  size: 10, color: statusColor),
                              label: Text(_connected == true
                                  ? 'Server Online'
                                  : _connected == false
                                      ? 'Server Offline'
                                      : 'Unknown'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Flow: ${widget.architectureFlow}'),
                        const SizedBox(height: 4),
                        Text(
                          widget.architectureTradeoff,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextField(
                                controller: _urlController,
                                decoration: const InputDecoration(
                                  labelText: 'Backend URL',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onSubmitted: _connect,
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: _checking
                                  ? null
                                  : () => _connect(_urlController.text),
                              icon: const Icon(Icons.sync, size: 18),
                              label: const Text('Connect'),
                            ),
                            OutlinedButton.icon(
                              onPressed: _checking ? null : _ping,
                              icon: const Icon(Icons.network_check, size: 18),
                              label: const Text('Health Ping'),
                            ),
                            for (final port in const [8080, 8081, 8082, 8083, 8084])
                              ActionChip(
                                label: Text(':$port'),
                                onPressed: () =>
                                    _connect('http://localhost:$port/'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Serverpod Insights port: http://localhost:8081/ · Web server port: http://localhost:8082/',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<List<ActivityLogItem>>(
                  valueListenable: widget.activityNotifier,
                  builder: (context, items, _) {
                    final errorCount = items.where((i) => i.isError).length;
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Storefront Activity & RPC Logs (${items.length})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                if (errorCount > 0)
                                  Chip(
                                    label: Text('$errorCount error(s)'),
                                    backgroundColor: colors.errorContainer,
                                  ),
                              ],
                            ),
                            const Divider(height: 20),
                            if (items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 28),
                                child: Center(
                                  child: Text(
                                    'No storefront activities yet. Browse products, checkout, or register a shopper to see live backend logs here.',
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: item.isError
                                          ? colors.errorContainer
                                              .withValues(alpha: 0.4)
                                          : colors.surfaceContainerHighest
                                              .withValues(alpha: 0.5),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: item.isError
                                            ? colors.error.withValues(alpha: 0.5)
                                            : colors.outlineVariant,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              item.isError
                                                  ? Icons.error_outline
                                                  : Icons.check_circle_outline,
                                              size: 16,
                                              color: item.isError
                                                  ? colors.error
                                                  : Colors.green,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${item.summary} · ${item.action}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              item.timestamp
                                                  .toLocal()
                                                  .toIso8601String()
                                                  .substring(11, 19),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
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
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';

import '../client.dart';
import '../widgets/backend_shell.dart';

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _logs = <RpcLogEntry>[];

  final _orderAmountController = TextEditingController(text: '49.99');
  OrderResponse? _lastOrder;

  final _userNameController = TextEditingController(text: 'Grace Hopper');
  final _userEmailController = TextEditingController(text: 'grace@example.com');
  bool _userActive = true;
  List<User> _users = [];

  bool _loading = false;

  @override
  void dispose() {
    _orderAmountController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _addLog(String action, Object? result, {bool isError = false}) {
    setState(() {
      _logs.insert(
        0,
        RpcLogEntry(
          timestamp: DateTime.now(),
          action: action,
          serverUrl: serverUrlNotifier.value,
          isError: isError,
          payload: isError ? '$result' : prettyJson(result),
        ),
      );
    });
  }

  Future<void> _createOrder() async {
    setState(() => _loading = true);
    try {
      final amount = double.tryParse(_orderAmountController.text.trim()) ?? 0;
      final res = await client.order.createOrder(
        CreateOrderRequest(amount: amount),
      );
      setState(() => _lastOrder = res);
      _addLog('order.createOrder', res.toJson());
    } catch (e) {
      _addLog('order.createOrder', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createUser() async {
    setState(() => _loading = true);
    try {
      final created = await client.user.createUser(
        User(
          name: _userNameController.text.trim(),
          email: _userEmailController.text.trim(),
          isActive: _userActive,
        ),
      );
      _addLog('user.createUser', created.toJson());
      await _loadUsers();
    } catch (e) {
      _addLog('user.createUser', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadUsers() async {
    try {
      final list = await client.user.getUsers();
      setState(() => _users = list);
      _addLog('user.getUsers', list.map((u) => u.toJson()).toList());
    } catch (e) {
      _addLog('user.getUsers', e, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackendShell(
      patternTag: '02-layered',
      patternTitle: 'Layered Architecture',
      patternDescription:
          'Endpoint -> Service -> OrderStore -> ORM (OrderEndpoint requires auth).',
      showAuth: true,
      logs: _logs,
      onClearLogs: () => setState(_logs.clear),
      onLog: _addLog,
      onClientChanged: () => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'OrderEndpoint (client.order)',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      const Chip(
                        label: Text('Requires Sign In'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _orderAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Order amount (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _createOrder,
                        icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                        label: const Text('Create Order'),
                      ),
                    ],
                  ),
                  if (_lastOrder != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Last OrderResponse: orderId=${_lastOrder!.orderId}, '
                      'success=${_lastOrder!.success}',
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UserEndpoint (client.user)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextField(
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _userEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilterChip(
                        label: const Text('Active'),
                        selected: _userActive,
                        onSelected: (v) => setState(() => _userActive = v),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _createUser,
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Create User'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loadUsers,
                        icon: const Icon(Icons.refresh, size: 18),
                        label: Text('Load Users (${_users.length})'),
                      ),
                    ],
                  ),
                  if (_users.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    for (final u in _users)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.person_outline),
                        title: Text('${u.name} (${u.email})'),
                        subtitle: Text('id=${u.id} · active=${u.isActive}'),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

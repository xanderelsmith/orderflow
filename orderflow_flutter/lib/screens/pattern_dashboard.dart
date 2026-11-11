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

  final _authNameController = TextEditingController(text: 'Alan Turing');
  final _authEmailController = TextEditingController(text: 'alan@example.com');

  final _itemCountController = TextEditingController(text: '3');
  final _totalPriceController = TextEditingController(text: '79.50');
  List<OrderRecord> _myOrders = [];

  final _paymentOrderIdController = TextEditingController(text: '1');
  final _paymentAmountController = TextEditingController(text: '79.50');

  bool _loading = false;

  @override
  void dispose() {
    _authNameController.dispose();
    _authEmailController.dispose();
    _itemCountController.dispose();
    _totalPriceController.dispose();
    _paymentOrderIdController.dispose();
    _paymentAmountController.dispose();
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

  Future<void> _registerUser() async {
    setState(() => _loading = true);
    try {
      final user = await client.authFeature.register(
        _authNameController.text.trim(),
        _authEmailController.text.trim(),
      );
      _addLog('authFeature.register', user.toJson());
    } catch (e) {
      _addLog('authFeature.register', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _lookupUser() async {
    setState(() => _loading = true);
    try {
      final user = await client.authFeature.lookupByEmail(
        _authEmailController.text.trim(),
      );
      _addLog('authFeature.lookupByEmail', user?.toJson());
    } catch (e) {
      _addLog('authFeature.lookupByEmail', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _placeOrder() async {
    setState(() => _loading = true);
    try {
      final order = await client.orderFeature.placeOrder(
        int.tryParse(_itemCountController.text.trim()) ?? 1,
        double.tryParse(_totalPriceController.text.trim()) ?? 0,
      );
      _addLog('orderFeature.placeOrder', order.toJson());
      await _listMyOrders();
    } catch (e) {
      _addLog('orderFeature.placeOrder', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _listMyOrders() async {
    try {
      final orders = await client.orderFeature.listMyOrders();
      setState(() => _myOrders = orders);
      _addLog(
        'orderFeature.listMyOrders',
        orders.map((o) => o.toJson()).toList(),
      );
    } catch (e) {
      _addLog('orderFeature.listMyOrders', e, isError: true);
    }
  }

  Future<void> _chargeOrder() async {
    setState(() => _loading = true);
    try {
      final payment = await client.paymentFeature.chargeOrder(
        int.tryParse(_paymentOrderIdController.text.trim()) ?? 1,
        double.tryParse(_paymentAmountController.text.trim()) ?? 0,
      );
      _addLog('paymentFeature.chargeOrder', payment.toJson());
    } catch (e) {
      _addLog('paymentFeature.chargeOrder', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackendShell(
      patternTag: '03-vertical-slices',
      patternTitle: 'Package by Feature (Vertical Slices)',
      patternDescription:
          'features/{auth,orders,payments}/ (Orders slice requires auth).',
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
                  Text(
                    'AuthFeatureEndpoint (client.authFeature)',
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
                          controller: _authNameController,
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
                          controller: _authEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _registerUser,
                        icon: const Icon(Icons.person_add, size: 18),
                        label: const Text('Register'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loading ? null : _lookupUser,
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text('Lookup by Email'),
                      ),
                    ],
                  ),
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
                  Row(
                    children: [
                      Text(
                        'OrderFeatureEndpoint (client.orderFeature)',
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
                        width: 140,
                        child: TextField(
                          controller: _itemCountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Item count',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _totalPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Total price (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _placeOrder,
                        icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                        label: const Text('Place Order'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _listMyOrders,
                        icon: const Icon(Icons.list_alt, size: 18),
                        label: Text('My Orders (${_myOrders.length})'),
                      ),
                    ],
                  ),
                  if (_myOrders.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    for (final o in _myOrders)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.receipt_long),
                        title: Text(
                          'Order #${o.id} · ${o.itemCount} items · \$${o.totalPrice}',
                        ),
                        subtitle: Text('userId=${o.userId}'),
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
                    'PaymentFeatureEndpoint (client.paymentFeature)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        child: TextField(
                          controller: _paymentOrderIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Order ID',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _paymentAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Amount (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _chargeOrder,
                        icon: const Icon(Icons.payments_outlined, size: 18),
                        label: const Text('Charge Order'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../client.dart';
import '../widgets/backend_shell.dart';

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _logs = <RpcLogEntry>[];

  final _orderIdController = TextEditingController(text: '101');
  final _emailController = TextEditingController(text: 'explorer@example.com');
  final _amountController = TextEditingController(text: '129.95');

  bool _loading = false;

  @override
  void dispose() {
    _orderIdController.dispose();
    _emailController.dispose();
    _amountController.dispose();
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

  Future<void> _completeCheckout() async {
    setState(() => _loading = true);
    final orderId = int.tryParse(_orderIdController.text.trim()) ?? 101;
    final email = _emailController.text.trim();
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;

    try {
      await client.checkout.completeCheckout(orderId, email, amount);
      _addLog('checkout.completeCheckout', {
        'status': 'dispatched',
        'orderId': orderId,
        'email': email,
        'amount': amount,
        'pubSubChannel': 'order_channel',
        'futureCall': 'SendEmailCall.sendReceipt (1s delay)',
      });
    } catch (e) {
      _addLog('checkout.completeCheckout', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackendShell(
      patternTag: '05-event-driven',
      patternTitle: 'Event-Driven Architecture',
      patternDescription:
          'Publishes OrderCreatedEvent to MessageCentral + schedules SendEmailCall.',
      logs: _logs,
      onClearLogs: () => setState(_logs.clear),
      onLog: _addLog,
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
                    'CheckoutEndpoint (client.checkout)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Calling completeCheckout returns immediately after posting to '
                    'order_channel and queuing a durable 1-second FutureCall.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 130,
                        child: TextField(
                          controller: _orderIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Order ID',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Customer email',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _amountController,
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
                        onPressed: _loading ? null : _completeCheckout,
                        icon: const Icon(Icons.bolt, size: 18),
                        label: const Text('Complete Checkout'),
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

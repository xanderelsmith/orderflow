import 'package:flutter/material.dart';

import '../client.dart';
import '../widgets/ecommerce_shell.dart';

class _DispatchedOrder {
  final int orderId;
  final String email;
  final double amount;

  _DispatchedOrder({
    required this.orderId,
    required this.email,
    required this.amount,
  });
}

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = ValueNotifier<List<ActivityLogItem>>([]);
  final Map<String, int> _cart = {'SCALE-03': 1};
  final List<_DispatchedOrder> _orders = [];

  final _emailController = TextEditingController(text: 'explorer@example.com');
  int _nextOrderId = 1001;
  bool _busy = false;

  @override
  void dispose() {
    _activity.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _log(
    String action,
    String summary,
    Object? detail, {
    bool isError = false,
  }) {
    _activity.value = [
      ActivityLogItem(
        timestamp: DateTime.now(),
        action: action,
        summary: summary,
        isError: isError,
        detail: isError ? '$detail' : prettyPayload(detail),
      ),
      ..._activity.value,
    ];
  }

  int get _cartCount => _cart.values.fold(0, (a, b) => a + b);

  double get _cartTotal {
    var total = 0.0;
    for (final p in shopCatalog) {
      total += (_cart[p.sku] ?? 0) * p.price;
    }
    return total;
  }

  void _adjustQty(String sku, int delta) {
    setState(() {
      final next = (_cart[sku] ?? 0) + delta;
      if (next <= 0) {
        _cart.remove(sku);
      } else {
        _cart[sku] = next;
      }
    });
  }

  Future<void> _checkout() async {
    final email = _emailController.text.trim();
    final total = _cartTotal;
    if (email.isEmpty || total <= 0) return;

    final orderId = _nextOrderId;
    setState(() => _busy = true);
    try {
      await client.checkout.completeCheckout(orderId, email, total);
      setState(() {
        _nextOrderId++;
        _orders.insert(
          0,
          _DispatchedOrder(orderId: orderId, email: email, amount: total),
        );
        _cart.clear();
      });
      _log(
        'checkout.completeCheckout',
        'Dispatched Order #$orderId (\$${total.toStringAsFixed(2)}) for $email',
        {
          'orderId': orderId,
          'email': email,
          'amount': total,
          'pubSubChannel': 'order_channel',
          'futureCall': 'SendEmailCall.sendReceipt (1s delay)',
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order #$orderId dispatched!')),
        );
      }
    } catch (e) {
      _log('checkout.completeCheckout', 'Checkout dispatch failed', e,
          isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EcommerceShell(
      patternBadge: '05 · Event-Driven',
      architectureTitle: 'Pattern 5: Event-Driven Architecture',
      architectureFlow:
          'CheckoutEndpoint → CheckoutService → MessageCentral (order_channel) + SendEmailCall FutureCall',
      architectureTradeoff:
          'Instant client responses and resilient background jobs. Requires handling idempotency and eventual consistency.',
      activityNotifier: _activity,
      onClearActivity: () => _activity.value = [],
      onLog: _log,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth >= 860;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCatalog(context),
              if (_orders.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildOrderReceipts(context),
              ],
            ],
          );
          final right = _buildCartCard(context);
          if (twoCol) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: left),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: right),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              left,
              const SizedBox(height: 20),
              right,
            ],
          );
        },
      ),
    );
  }

  Widget _buildCatalog(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shop Coffee & Gear',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final p in shopCatalog)
                  SizedBox(
                    width: 270,
                    child: Card.outlined(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: colors.primaryContainer,
                                  child: Icon(
                                    p.icon,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '\$${p.price.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              p.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              p.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                IconButton.outlined(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: (_cart[p.sku] ?? 0) > 0
                                      ? () => _adjustQty(p.sku, -1)
                                      : null,
                                  icon: const Icon(Icons.remove, size: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text('${_cart[p.sku] ?? 0}'),
                                ),
                                IconButton.filledTonal(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => _adjustQty(p.sku, 1),
                                  icon: const Icon(Icons.add, size: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Express Checkout',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                Text('$_cartCount item(s)'),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Receipt email',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total'),
                Text(
                  '\$${_cartTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: (_busy || _cartCount <= 0) ? null : _checkout,
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Complete Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderReceipts(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Orders',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Divider(height: 20),
            for (final o in _orders)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.bolt, color: Colors.amber),
                title: Text(
                  'Order #${o.orderId} · \$${o.amount.toStringAsFixed(2)}',
                ),
                subtitle: Text('Receipt emailing to ${o.email}'),
                trailing: const Chip(
                  label: Text('Dispatched'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

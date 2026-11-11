import 'package:flutter/material.dart';

import '../client.dart';
import '../widgets/product_shell.dart';

class _CatalogItem {
  final String sku;
  final String name;
  final double price;
  final IconData icon;

  const _CatalogItem({
    required this.sku,
    required this.name,
    required this.price,
    required this.icon,
  });
}

const _catalog = [
  _CatalogItem(
    sku: 'ROAST-01',
    name: 'Ethiopia Single Origin',
    price: 18.50,
    icon: Icons.coffee,
  ),
  _CatalogItem(
    sku: 'GEAR-02',
    name: 'Pour-Over Glass Dripper',
    price: 34.00,
    icon: Icons.local_cafe_outlined,
  ),
  _CatalogItem(
    sku: 'SCALE-03',
    name: 'Precision Brew Scale',
    price: 59.00,
    icon: Icons.scale_outlined,
  ),
  _CatalogItem(
    sku: 'PACK-04',
    name: 'Explorer Starter Kit',
    price: 45.00,
    icon: Icons.inventory_2_outlined,
  ),
];

class _DispatchedOrder {
  final int orderId;
  final String email;
  final double amount;
  final DateTime dispatchedAt;

  _DispatchedOrder({
    required this.orderId,
    required this.email,
    required this.amount,
    required this.dispatchedAt,
  });
}

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = <ActivityLogItem>[];
  final Map<String, int> _cart = {'PACK-04': 1};
  final List<_DispatchedOrder> _dispatched = [];

  final _emailController = TextEditingController(text: 'explorer@example.com');
  int _nextOrderId = 1001;
  bool _busy = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _log(String action, Object? detail, {bool isError = false}) {
    if (!mounted) return;
    setState(() {
      _activity.insert(
        0,
        ActivityLogItem(
          timestamp: DateTime.now(),
          action: action,
          isError: isError,
          detail: isError ? '$detail' : prettyPayload(detail),
        ),
      );
    });
  }

  double get _cartTotal {
    var total = 0.0;
    for (final item in _catalog) {
      total += (_cart[item.sku] ?? 0) * item.price;
    }
    return total;
  }

  int get _cartCount => _cart.values.fold(0, (a, b) => a + b);

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

  Future<void> _completeCheckout() async {
    final email = _emailController.text.trim();
    final total = _cartTotal;
    if (email.isEmpty || total <= 0) return;

    final orderId = _nextOrderId;
    setState(() => _busy = true);
    try {
      await client.checkout.completeCheckout(orderId, email, total);
      setState(() {
        _nextOrderId++;
        _dispatched.insert(
          0,
          _DispatchedOrder(
            orderId: orderId,
            email: email,
            amount: total,
            dispatchedAt: DateTime.now(),
          ),
        );
        _cart.clear();
      });
      _log('checkout.completeCheckout', {
        'orderId': orderId,
        'email': email,
        'amount': total,
        'messageBusChannel': 'order_channel',
        'futureCall': 'SendEmailCall.sendReceipt (1s delay)',
      });
    } catch (e) {
      _log('checkout.completeCheckout', e, isError: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dispatch failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProductShell(
      editionLabel: 'Async Checkout · Event-Driven',
      subtitle:
          'Instant storefront checkout: responds immediately while broadcasting OrderCreatedEvent on order_channel and queuing SendEmailCall in the background.',
      activity: _activity,
      onClearActivity: () => setState(_activity.clear),
      onLog: _log,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth >= 860;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCatalogCard(context),
              const SizedBox(height: 20),
              _buildDispatchFeed(context),
            ],
          );
          final right = _buildInstantCheckoutCard(context);
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

  Widget _buildCatalogCard(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storefront Catalog',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final item in _catalog)
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
                                    item.icon,
                                    color: colors.onPrimaryContainer,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '\$${item.price.toStringAsFixed(2)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton.outlined(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: (_cart[item.sku] ?? 0) > 0
                                      ? () => _adjustQty(item.sku, -1)
                                      : null,
                                  icon: const Icon(Icons.remove, size: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Text('${_cart[item.sku] ?? 0}'),
                                ),
                                IconButton.filledTonal(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => _adjustQty(item.sku, 1),
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

  Widget _buildInstantCheckoutCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Express Async Checkout',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_cartCount item(s) · Next Order #$_nextOrderId'),
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
                onPressed: (_busy || _cartTotal <= 0) ? null : _completeCheckout,
                icon: const Icon(Icons.bolt, size: 18),
                label: const Text('Complete Checkout'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDispatchFeed(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dispatched Event Pipeline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const Divider(height: 20),
            if (_dispatched.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'Complete a checkout to publish OrderCreatedEvent and queue SendEmailCall.',
                  ),
                ),
              )
            else
              for (final item in _dispatched) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bolt, color: Colors.amber),
                  title: Text(
                    'Order #${item.orderId} · \$${item.amount.toStringAsFixed(2)}',
                  ),
                  subtitle: Text(
                    'Receipt queued for ${item.email} · Broadcast on order_channel',
                  ),
                  trailing: const Chip(
                    label: Text('Queued'),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const Divider(height: 1),
              ],
          ],
        ),
      ),
    );
  }
}

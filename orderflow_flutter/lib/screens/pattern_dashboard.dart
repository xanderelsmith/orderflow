import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../widgets/ecommerce_shell.dart';

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = ValueNotifier<List<ActivityLogItem>>([]);
  final Map<String, int> _cart = {'ROAST-01': 2};
  final Map<int, PaymentRecord> _paidOrders = {};
  List<OrderRecord> _orders = [];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  User? _profileResult;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  void dispose() {
    _activity.dispose();
    _nameController.dispose();
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

  Future<void> _loadOrders() async {
    try {
      final list = await client.orderFeature.listMyOrders();
      if (mounted) setState(() => _orders = list);
      _log(
        'orderFeature.listMyOrders',
        'Loaded ${list.length} order(s) from orders slice',
        list.map((o) => o.toJson()).toList(),
      );
    } catch (e) {
      _log('orderFeature.listMyOrders', 'Failed to load orders', e,
          isError: true);
    }
  }

  Future<void> _placeOrder() async {
    if (_cartCount <= 0) return;
    setState(() => _busy = true);
    try {
      final order = await client.orderFeature.placeOrder(
        _cartCount,
        _cartTotal,
      );
      setState(() => _cart.clear());
      _log(
        'orderFeature.placeOrder',
        'Placed order #${order.id} (${order.itemCount} items, \$${order.totalPrice.toStringAsFixed(2)})',
        order.toJson(),
      );
      await _loadOrders();
    } catch (e) {
      _log('orderFeature.placeOrder', 'Order placement failed', e,
          isError: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _payOrder(OrderRecord order) async {
    final id = order.id;
    if (id == null) return;
    setState(() => _busy = true);
    try {
      final payment = await client.paymentFeature.chargeOrder(
        id,
        order.totalPrice,
      );
      setState(() => _paidOrders[id] = payment);
      _log(
        'paymentFeature.chargeOrder',
        'Captured \$${payment.amount.toStringAsFixed(2)} for Order #$id',
        payment.toJson(),
      );
    } catch (e) {
      _log('paymentFeature.chargeOrder', 'Payment failed', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _registerProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;
    setState(() => _busy = true);
    try {
      final user = await client.authFeature.register(name, email);
      setState(() => _profileResult = user);
      _log('authFeature.register', 'Registered ${user.name}', user.toJson());
    } catch (e) {
      _log('authFeature.register', 'Registration failed', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _lookupProfile() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;
    setState(() => _busy = true);
    try {
      final user = await client.authFeature.lookupByEmail(email);
      setState(() => _profileResult = user);
      _log(
        'authFeature.lookupByEmail',
        user != null ? 'Found ${user.name}' : 'No customer for $email',
        user?.toJson(),
      );
    } catch (e) {
      _log('authFeature.lookupByEmail', 'Lookup failed', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuth = client.auth.isAuthenticated;

    return EcommerceShell(
      patternBadge: '03 · Vertical Slices',
      architectureTitle: 'Pattern 3: Package by Feature (Vertical Slices)',
      architectureFlow:
          'features/auth + features/orders + features/payments (Tier 1)',
      architectureTradeoff:
          'High cognitive locality—models, services, and endpoints live together per capability. Watch out for dumping shared models into common/.',
      showAuth: true,
      activityNotifier: _activity,
      onClearActivity: () => _activity.value = [],
      onLog: _log,
      onClientChanged: _loadOrders,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth >= 860;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCatalog(context),
              const SizedBox(height: 20),
              _buildOrdersCard(context),
            ],
          );
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCartCard(context, isAuth),
              const SizedBox(height: 20),
              _buildCustomerCard(context),
            ],
          );
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

  Widget _buildOrdersCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'My Order History',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _loadOrders,
                  icon: const Icon(Icons.refresh, size: 20),
                ),
              ],
            ),
            const Divider(height: 20),
            if (_orders.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text('No orders yet. Sign in and place an order.'),
                ),
              )
            else
              for (final o in _orders) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text('Order #${o.id} · ${o.itemCount} item(s)'),
                  subtitle: Text('\$${o.totalPrice.toStringAsFixed(2)}'),
                  trailing: _paidOrders.containsKey(o.id)
                      ? Chip(
                          avatar: const Icon(Icons.check_circle,
                              size: 16, color: Colors.green),
                          label: Text(_paidOrders[o.id]!.status.toUpperCase()),
                        )
                      : FilledButton.tonal(
                          onPressed: _busy ? null : () => _payOrder(o),
                          child: const Text('Pay Now'),
                        ),
                ),
                const Divider(height: 1),
              ],
          ],
        ),
      ),
    );
  }

  Widget _buildCartCard(BuildContext context, bool isAuth) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Cart Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                Text('$_cartCount item(s)'),
              ],
            ),
            const SizedBox(height: 12),
            if (!isAuth)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Sign in (top right) to place orders and view order history.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ),
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
                onPressed: (_busy || _cartCount <= 0) ? null : _placeOrder,
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopper Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full name',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: _busy ? null : _registerProfile,
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : _lookupProfile,
                    child: const Text('Lookup'),
                  ),
                ),
              ],
            ),
            if (_profileResult != null) ...[
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.person_outline),
                title: Text(_profileResult!.name),
                subtitle: Text(_profileResult!.email),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

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

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = <ActivityLogItem>[];
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
    _nameController.dispose();
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

  int get _cartCount => _cart.values.fold(0, (a, b) => a + b);

  double get _cartTotal {
    var total = 0.0;
    for (final item in _catalog) {
      total += (_cart[item.sku] ?? 0) * item.price;
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
      _log('orderFeature.listMyOrders', list.map((o) => o.toJson()).toList());
    } catch (e) {
      _log('orderFeature.listMyOrders', e, isError: true);
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
      _log('orderFeature.placeOrder', order.toJson());
      await _loadOrders();
    } catch (e) {
      _log('orderFeature.placeOrder', e, isError: true);
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
      _log('paymentFeature.chargeOrder', payment.toJson());
    } catch (e) {
      _log('paymentFeature.chargeOrder', e, isError: true);
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
      _log('authFeature.register', user.toJson());
    } catch (e) {
      _log('authFeature.register', e, isError: true);
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
      _log('authFeature.lookupByEmail', user?.toJson());
    } catch (e) {
      _log('authFeature.lookupByEmail', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuth = client.auth.isAuthenticated;

    return ProductShell(
      editionLabel: 'Commerce · Vertical Slices',
      subtitle:
          'Three autonomous feature slices: Catalog & Order History (Orders), one-click Payment Capture (Payments), and Customer Profiles (Auth).',
      showAuth: true,
      activity: _activity,
      onClearActivity: () => setState(_activity.clear),
      onLog: _log,
      onClientChanged: _loadOrders,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth >= 860;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCatalogCard(context),
              const SizedBox(height: 20),
              _buildOrdersCard(context),
            ],
          );
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCheckoutCard(context, isAuth),
              const SizedBox(height: 20),
              _buildProfileCard(context),
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
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Refresh orders',
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
              for (final order in _orders) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.receipt_long_outlined),
                  title: Text(
                    'Order #${order.id} · ${order.itemCount} items',
                  ),
                  subtitle: Text('\$${order.totalPrice.toStringAsFixed(2)}'),
                  trailing: _paidOrders.containsKey(order.id)
                      ? Chip(
                          avatar: const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: Colors.green,
                          ),
                          label: Text(
                            _paidOrders[order.id]!.status.toUpperCase(),
                          ),
                        )
                      : FilledButton.tonal(
                          onPressed: _busy ? null : () => _payOrder(order),
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

  Widget _buildCheckoutCard(BuildContext context, bool isAuth) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cart Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            if (!isAuth)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: colors.secondaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Sign in (top right) to place orders and view your history.',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.onSecondaryContainer,
                  ),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$_cartCount item(s)'),
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

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Directory (Auth Slice)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Customer name',
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
                    child: const Text('Register'),
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
                trailing: Chip(
                  label: Text(_profileResult!.isActive ? 'Active' : 'Inactive'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

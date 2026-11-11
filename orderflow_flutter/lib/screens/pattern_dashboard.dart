import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../widgets/product_shell.dart';

class _CatalogItem {
  final String sku;
  final String name;
  final String tag;
  final double price;
  final IconData icon;

  const _CatalogItem({
    required this.sku,
    required this.name,
    required this.tag,
    required this.price,
    required this.icon,
  });
}

const _catalog = [
  _CatalogItem(
    sku: 'ROAST-01',
    name: 'Ethiopia Single Origin',
    tag: '250g Whole Bean',
    price: 18.50,
    icon: Icons.coffee,
  ),
  _CatalogItem(
    sku: 'GEAR-02',
    name: 'Pour-Over Glass Dripper',
    tag: 'Borosilicate',
    price: 34.00,
    icon: Icons.local_cafe_outlined,
  ),
  _CatalogItem(
    sku: 'SCALE-03',
    name: 'Precision Brew Scale',
    tag: '0.1g · USB-C',
    price: 59.00,
    icon: Icons.scale_outlined,
  ),
  _CatalogItem(
    sku: 'PACK-04',
    name: 'Explorer Starter Kit',
    tag: 'Beans + Filters',
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
  final Map<String, int> _cart = {'ROAST-01': 1};
  final List<OrderResponse> _receipts = [];
  List<User> _customers = [];

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
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

  Future<void> _loadCustomers() async {
    try {
      final list = await client.user.getUsers();
      if (mounted) setState(() => _customers = list);
      _log('user.getUsers', list.map((u) => u.toJson()).toList());
    } catch (e) {
      _log('user.getUsers', e, isError: true);
    }
  }

  Future<void> _addCustomer() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;
    setState(() => _busy = true);
    try {
      final created = await client.user.createUser(
        User(name: name, email: email, isActive: true),
      );
      _nameController.clear();
      _emailController.clear();
      _log('user.createUser', created.toJson());
      await _loadCustomers();
    } catch (e) {
      _log('user.createUser', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _checkout() async {
    final total = _cartTotal;
    if (total <= 0) return;
    setState(() => _busy = true);
    try {
      final res = await client.order.createOrder(
        CreateOrderRequest(amount: total),
      );
      setState(() {
        _receipts.insert(0, res);
        _cart.clear();
      });
      _log('order.createOrder', res.toJson());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Order #${res.orderId} confirmed!')),
        );
      }
    } catch (e) {
      _log('order.createOrder', e, isError: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAuth = client.auth.isAuthenticated;

    return ProductShell(
      editionLabel: 'Storefront · Layered',
      subtitle:
          'Adds authenticated storefront checkout (OrderEndpoint -> OrderService -> OrderStore) alongside the customer directory.',
      showAuth: true,
      activity: _activity,
      onClearActivity: () => setState(_activity.clear),
      onLog: _log,
      onClientChanged: () => setState(() {}),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth >= 840;
          final left = _buildCatalog(context);
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCartCard(context, isAuth),
              const SizedBox(height: 20),
              _buildCustomersCard(context),
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
              'Product Catalog',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
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
                            const SizedBox(height: 12),
                            Text(
                              item.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              item.tag,
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
            if (_receipts.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Text(
                'Confirmed Orders (This Session)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              for (final r in _receipts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified, color: Colors.green),
                  title: Text('Order #${r.orderId}'),
                  trailing: Chip(
                    label: Text(r.success ? 'Confirmed' : 'Pending'),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
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
                  'Checkout',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: colors.onSecondaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Sign in using the top-right button before placing an order.',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Order Total'),
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
                onPressed: (_busy || _cartTotal <= 0) ? null : _checkout,
                icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                label: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomersCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Customers (${_customers.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _loadCustomers,
                  icon: const Icon(Icons.refresh, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _busy ? null : _addCustomer,
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Add Customer'),
              ),
            ),
            if (_customers.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              for (final c in _customers)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: const Icon(Icons.person_outline),
                  title: Text(c.name),
                  subtitle: Text(c.email),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

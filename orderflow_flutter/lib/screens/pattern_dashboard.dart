import 'package:flutter/material.dart';

import '../client.dart';
import '../services/multi_backend_rpc.dart';
import '../widgets/ecommerce_shell.dart';

enum BackendPattern {
  simpleMvc(
    badge: '01 · Simple MVC',
    title: 'Pattern 1: Simple MVC',
    flow: 'TaskEndpoint / UserEndpoint → Task.db / User.db',
    tradeoff: 'Fast MVP CRUD. Breaks down when endpoints grow past ~10 files.',
    showAuth: false,
  ),
  layered(
    badge: '02 · Layered',
    title: 'Pattern 2: Layered Architecture',
    flow: 'OrderEndpoint → OrderService → OrderStore → CustomerOrder.db',
    tradeoff: 'Clean separation of auth and logic; suffers from layer scattering.',
    showAuth: true,
  ),
  verticalSlices(
    badge: '03 · Vertical Slices',
    title: 'Pattern 3: Vertical Slices',
    flow: 'features/auth + features/orders + features/payments (Tier 1)',
    tradeoff: 'High cognitive locality per feature; avoid global shared dumpsters.',
    showAuth: true,
  ),
  modularMonolith(
    badge: '04 · Modular Monolith',
    title: 'Pattern 4: Modular Monolith',
    flow: 'BillingEndpoint → BillingService → IdentityFacade → IdentityService',
    tradeoff: 'Strict api/ vs internal/ contracts for larger teams (Tier 2).',
    showAuth: false,
  ),
  eventDriven(
    badge: '05 · Event-Driven',
    title: 'Pattern 5: Event-Driven',
    flow: 'CheckoutEndpoint → MessageCentral (order_channel) + SendEmailCall',
    tradeoff: 'Instant responses & background jobs; requires idempotency.',
    showAuth: false,
  );

  const BackendPattern({
    required this.badge,
    required this.title,
    required this.flow,
    required this.tradeoff,
    required this.showAuth,
  });

  final String badge;
  final String title;
  final String flow;
  final String tradeoff;
  final bool showAuth;
}

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = ValueNotifier<List<ActivityLogItem>>([]);
  final Map<String, int> _cart = {'ROAST-01': 1};
  final List<Map<String, dynamic>> _recentOrders = [];

  BackendPattern _pattern = BackendPattern.simpleMvc;
  late final Map<BackendPattern, String> _urls = {
    for (final p in BackendPattern.values) p: serverUrlNotifier.value,
  };

  final _nameController = TextEditingController(text: 'Ada Lovelace');
  final _emailController = TextEditingController(text: 'ada@example.com');
  final _accountIdController = TextEditingController(text: '1');
  int _nextEventOrderId = 1001;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    serverUrlNotifier.addListener(_rememberUrl);
  }

  @override
  void dispose() {
    serverUrlNotifier.removeListener(_rememberUrl);
    _activity.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _accountIdController.dispose();
    super.dispose();
  }

  void _rememberUrl() {
    _urls[_pattern] = serverUrlNotifier.value;
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

  Future<void> _switchPattern(BackendPattern next) async {
    if (next == _pattern) return;
    _urls[_pattern] = serverUrlNotifier.value;
    setState(() => _pattern = next);
    final url = _urls[next]!;
    if (url != serverUrlNotifier.value) {
      await initializeClient(overrideUrl: url);
      if (mounted) setState(() {});
    }
  }

  Future<dynamic> _call(
    String endpoint,
    String method, [
    Map<String, dynamic> args = const {},
  ]) async {
    return MultiBackendRpc.call(
      baseUrl: serverUrlNotifier.value,
      endpoint: endpoint,
      method: method,
      args: args,
    );
  }

  Future<void> _checkout() async {
    if (_cartCount <= 0) return;
    setState(() => _busy = true);
    final total = _cartTotal;
    final itemsText = [
      for (final p in shopCatalog)
        if ((_cart[p.sku] ?? 0) > 0) '${_cart[p.sku]}x ${p.name}',
    ].join(', ');

    try {
      dynamic res;
      late String action;
      late String summary;

      switch (_pattern) {
        case BackendPattern.simpleMvc:
          action = 'task.createTask';
          res = await _call('task', 'createTask', {
            'task': {
              'title': '$itemsText (\$${total.toStringAsFixed(2)})',
              'isCompleted': false,
              'userId': int.tryParse(_accountIdController.text.trim()) ?? 1,
              'createdAt': DateTime.now().toUtc().toIso8601String(),
            },
          });
          summary = 'Created order task #${res['id']}';
        case BackendPattern.layered:
          action = 'order.createOrder';
          res = await _call('order', 'createOrder', {
            'request': {'amount': total},
          });
          summary = 'Placed layered order #${res['orderId']}';
        case BackendPattern.verticalSlices:
          action = 'orderFeature.placeOrder';
          res = await _call('orderFeature', 'placeOrder', {
            'itemCount': _cartCount,
            'totalPrice': total,
          });
          summary = 'Placed vertical-slice order #${res['id']}';
        case BackendPattern.modularMonolith:
          action = 'billing.issueInvoice';
          final userId = int.tryParse(_accountIdController.text.trim()) ?? 1;
          res = await _call('billing', 'issueInvoice', {
            'userId': userId,
            'amount': total,
          });
          summary =
              'Issued invoice #${res['ledgerEntryId']} for Account #$userId';
        case BackendPattern.eventDriven:
          action = 'checkout.completeCheckout';
          final orderId = _nextEventOrderId++;
          await _call('checkout', 'completeCheckout', {
            'orderId': orderId,
            'email': _emailController.text.trim(),
            'amount': total,
          });
          res = {
            'orderId': orderId,
            'email': _emailController.text.trim(),
            'amount': total,
            'status': 'dispatched',
          };
          summary = 'Dispatched async order #$orderId';
      }

      setState(() {
        _recentOrders.insert(0, {
          'pattern': _pattern.badge,
          'summary': summary,
          'amount': total,
          'raw': res,
        });
        _cart.clear();
      });
      _log(action, summary, res);
    } catch (e) {
      _log('${_pattern.badge}.checkout', 'Checkout failed', e, isError: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Checkout failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _paySliceOrder(Map<String, dynamic> entry) async {
    final raw = entry['raw'];
    if (raw is! Map) return;
    final id = raw['id'];
    final amount = (raw['totalPrice'] as num?)?.toDouble() ?? _cartTotal;
    if (id is! int) return;
    setState(() => _busy = true);
    try {
      final res = await _call('paymentFeature', 'chargeOrder', {
        'orderId': id,
        'amount': amount,
      });
      _log('paymentFeature.chargeOrder', 'Paid Order #$id', res);
      setState(() => entry['paid'] = true);
    } catch (e) {
      _log('paymentFeature.chargeOrder', 'Payment failed', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveShopper() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;
    setState(() => _busy = true);
    try {
      switch (_pattern) {
        case BackendPattern.simpleMvc:
        case BackendPattern.layered:
          final res = await _call('user', 'createUser', {
            'user': {'name': name, 'email': email, 'isActive': true},
          });
          if (res is Map && res['id'] != null) {
            _accountIdController.text = '${res['id']}';
          }
          _log('user.createUser', 'Saved shopper $name', res);
        case BackendPattern.verticalSlices:
          final res = await _call('authFeature', 'register', {
            'name': name,
            'email': email,
          });
          _log('authFeature.register', 'Registered shopper $name', res);
        case BackendPattern.modularMonolith:
          final parts = name.split(' ');
          final res = await _call('identity', 'registerAccount', {
            'email': email,
            'firstName': parts.first,
            'lastName': parts.length > 1 ? parts.sublist(1).join(' ') : '',
          });
          if (res is Map && res['userId'] != null) {
            _accountIdController.text = '${res['userId']}';
          }
          _log('identity.registerAccount', 'Created identity account', res);
        case BackendPattern.eventDriven:
          _log(
            'checkout.email',
            'Updated receipt email to $email',
            {'email': email},
          );
      }
    } catch (e) {
      _log('${_pattern.badge}.customer', 'Customer save failed', e,
          isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EcommerceShell(
      patternBadge: _pattern.badge,
      architectureTitle: _pattern.title,
      architectureFlow: _pattern.flow,
      architectureTradeoff: _pattern.tradeoff,
      showAuth: _pattern.showAuth,
      activityNotifier: _activity,
      onClearActivity: () => _activity.value = [],
      onLog: _log,
      onClientChanged: () => setState(() {}),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Target Backend:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              for (final p in BackendPattern.values)
                ChoiceChip(
                  label: Text(p.badge),
                  selected: p == _pattern,
                  onSelected: (_) => _switchPattern(p),
                ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoCol = constraints.maxWidth >= 860;
              final left = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCatalog(context),
                  if (_recentOrders.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildRecentOrders(context),
                  ],
                ],
              );
              final right = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCartCard(context),
                  const SizedBox(height: 20),
                  _buildShopperCard(context),
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
        ],
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

  Widget _buildRecentOrders(BuildContext context) {
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
            for (final o in _recentOrders)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.receipt_long_outlined),
                title: Text('${o['summary']}'),
                subtitle: Text('${o['pattern']}'),
                trailing: o['pattern'] == BackendPattern.verticalSlices.badge &&
                        o['paid'] != true
                    ? FilledButton.tonal(
                        onPressed: _busy ? null : () => _paySliceOrder(o),
                        child: const Text('Pay Now'),
                      )
                    : Text(
                        '\$${(o['amount'] as double).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
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
                  'Your Cart',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                Text('$_cartCount item(s)'),
              ],
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
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: Text(
                  _pattern == BackendPattern.modularMonolith
                      ? 'Checkout & Issue Invoice'
                      : 'Place Order',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopperCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopper Details',
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
            if (_pattern == BackendPattern.simpleMvc ||
                _pattern == BackendPattern.modularMonolith) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _accountIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Shopper / Account ID',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _busy ? null : _saveShopper,
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: const Text('Save Shopper'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

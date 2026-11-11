import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';

import '../client.dart';
import '../widgets/ecommerce_shell.dart';

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = ValueNotifier<List<ActivityLogItem>>([]);
  final Map<String, int> _cart = {'PACK-04': 1};

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _lookupIdController = TextEditingController(text: '1');

  UserSummary? _activeAccount;
  final List<InvoiceDto> _invoices = [];
  bool _busy = false;

  @override
  void dispose() {
    _activity.dispose();
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _lookupIdController.dispose();
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

  Future<void> _createAccount() async {
    final email = _emailController.text.trim();
    final first = _firstNameController.text.trim();
    final last = _lastNameController.text.trim();
    if (email.isEmpty || first.isEmpty) return;
    setState(() => _busy = true);
    try {
      final summary = await client.identity.registerAccount(email, first, last);
      setState(() {
        _activeAccount = summary;
        _lookupIdController.text = '${summary.userId}';
      });
      _emailController.clear();
      _firstNameController.clear();
      _lastNameController.clear();
      _log(
        'identity.registerAccount',
        'Provisioned account #${summary.userId} (${summary.fullName})',
        summary.toJson(),
      );
    } catch (e) {
      _log('identity.registerAccount', 'Account creation failed', e,
          isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _lookupAccount() async {
    final id = int.tryParse(_lookupIdController.text.trim());
    if (id == null) return;
    setState(() => _busy = true);
    try {
      final summary = await client.identity.getUserSummary(id);
      setState(() => _activeAccount = summary);
      _log(
        'identity.getUserSummary',
        summary != null
            ? 'Loaded UserSummary for ${summary.fullName}'
            : 'No account #$id',
        summary?.toJson(),
      );
    } catch (e) {
      _log('identity.getUserSummary', 'Lookup failed', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _checkoutAndInvoice() async {
    final userId =
        _activeAccount?.userId ?? int.tryParse(_lookupIdController.text.trim());
    final total = _cartTotal;
    if (userId == null || total <= 0) return;

    setState(() => _busy = true);
    try {
      final invoice = await client.billing.issueInvoice(userId, total);
      setState(() {
        _invoices.insert(0, invoice);
        _cart.clear();
      });
      _log(
        'billing.issueInvoice',
        'Issued invoice #${invoice.ledgerEntryId} for Account #$userId (\$${invoice.amount.toStringAsFixed(2)})',
        invoice.toJson(),
      );
    } catch (e) {
      _log('billing.issueInvoice', 'Invoice checkout rejected', e,
          isError: true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invoice rejected: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EcommerceShell(
      patternBadge: '04 · Modular Monolith',
      architectureTitle: 'Pattern 4: Modular Monolith (Tier 2)',
      architectureFlow:
          'BillingEndpoint → BillingService → IdentityFacade → IdentityService',
      architectureTradeoff:
          'Strict api/ vs internal/ module boundaries without microservices overhead. Requires import discipline.',
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
              if (_invoices.isNotEmpty) ...[
                const SizedBox(height: 20),
                _buildInvoicesCard(context),
              ],
            ],
          );
          final right = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCartCard(context),
              const SizedBox(height: 20),
              _buildIdentityCard(context),
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

  Widget _buildInvoicesCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Issued Invoices',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const Divider(height: 20),
            for (final inv in _invoices)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading:
                    const Icon(Icons.verified_outlined, color: Colors.green),
                title: Text(
                  'Invoice #${inv.ledgerEntryId} · Account #${inv.userId}',
                ),
                subtitle: Text('Issued ${inv.issuedAt.toLocal()}'),
                trailing: Text(
                  '\$${inv.amount.toStringAsFixed(2)}',
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
                  'Cart & Invoice Checkout',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                Text('$_cartCount item(s)'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _activeAccount != null
                  ? 'Billed to ${_activeAccount!.fullName} (#${_activeAccount!.userId})'
                  : 'Create or load a customer account below (or uses #${_lookupIdController.text}).',
              style: Theme.of(context).textTheme.bodySmall,
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
                onPressed:
                    (_busy || _cartCount <= 0) ? null : _checkoutAndInvoice,
                icon: const Icon(Icons.receipt_outlined, size: 18),
                label: const Text('Checkout & Issue Invoice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Identity Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lookupIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Account ID',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: _busy ? null : _lookupAccount,
                  child: const Text('Load'),
                ),
              ],
            ),
            if (_activeAccount != null) ...[
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.person_outline),
                title: Text(_activeAccount!.fullName),
                subtitle: Text(_activeAccount!.email),
                trailing: Chip(
                  label: Text(_activeAccount!.isActive ? 'Active' : 'Inactive'),
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
            const Divider(height: 24),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last name',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: _busy ? null : _createAccount,
                icon: const Icon(Icons.badge_outlined, size: 18),
                label: const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

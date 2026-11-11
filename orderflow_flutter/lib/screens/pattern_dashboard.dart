import 'package:flutter/material.dart';
import 'package:orderflow_client/orderflow_client.dart';

import '../client.dart';
import '../widgets/product_shell.dart';

class _PlanOption {
  final String name;
  final String subtitle;
  final double price;

  const _PlanOption(this.name, this.subtitle, this.price);
}

const _plans = [
  _PlanOption('Starter Retainer', 'Monthly Coffee Subscription', 49.00),
  _PlanOption('Studio Supply', 'Office Beans + Filters Pack', 149.00),
  _PlanOption('Enterprise Batch', 'Wholesale Roaster Lot', 499.00),
];

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  final _activity = <ActivityLogItem>[];

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _lookupIdController = TextEditingController(text: '1');

  UserSummary? _activeAccount;
  _PlanOption _selectedPlan = _plans[1];
  final List<InvoiceDto> _issuedInvoices = [];
  bool _busy = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _lookupIdController.dispose();
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
      _log('identity.registerAccount', summary.toJson());
    } catch (e) {
      _log('identity.registerAccount', e, isError: true);
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
      _log('identity.getUserSummary', summary?.toJson());
    } catch (e) {
      _log('identity.getUserSummary', e, isError: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _issueInvoice() async {
    final userId =
        _activeAccount?.userId ?? int.tryParse(_lookupIdController.text.trim());
    if (userId == null) return;
    setState(() => _busy = true);
    try {
      final invoice = await client.billing.issueInvoice(
        userId,
        _selectedPlan.price,
      );
      setState(() => _issuedInvoices.insert(0, invoice));
      _log('billing.issueInvoice', invoice.toJson());
    } catch (e) {
      _log('billing.issueInvoice', e, isError: true);
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
    return ProductShell(
      editionLabel: 'Enterprise · Modular Monolith',
      subtitle:
          'Account provisioning & invoicing across isolated modules: Billing validates accounts strictly through IdentityFacade and returns InvoiceDto.',
      activity: _activity,
      onClearActivity: () => setState(_activity.clear),
      onLog: _log,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final twoCol = constraints.maxWidth >= 860;
          final left = _buildBillingDesk(context);
          final right = _buildIdentityDesk(context);
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

  Widget _buildBillingDesk(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Supply Plan & Issue Invoice',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final plan in _plans)
                  SizedBox(
                    width: 210,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => setState(() => _selectedPlan = plan),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _selectedPlan == plan
                              ? colors.primaryContainer.withValues(alpha: 0.5)
                              : null,
                          border: Border.all(
                            color: _selectedPlan == plan
                                ? colors.primary
                                : colors.outlineVariant,
                            width: _selectedPlan == plan ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plan.subtitle,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '\$${plan.price.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _activeAccount != null
                        ? 'Billed to: ${_activeAccount!.fullName} (#${_activeAccount!.userId})'
                        : 'Select or register an Identity account on the right (or use ID #${_lookupIdController.text}).',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _busy ? null : _issueInvoice,
                  icon: const Icon(Icons.receipt_outlined, size: 18),
                  label: Text(
                    'Issue \$${_selectedPlan.price.toStringAsFixed(0)} Invoice',
                  ),
                ),
              ],
            ),
            if (_issuedInvoices.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 14),
              Text(
                'Issued Ledger Invoices',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              for (final inv in _issuedInvoices)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.verified_outlined,
                      color: Colors.green),
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
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityDesk(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identity Accounts',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
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
                OutlinedButton.icon(
                  onPressed: _busy ? null : _lookupAccount,
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Load'),
                ),
              ],
            ),
            if (_activeAccount != null) ...[
              const SizedBox(height: 12),
              Card.outlined(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      _activeAccount!.fullName.isEmpty
                          ? '?'
                          : _activeAccount!.fullName[0].toUpperCase(),
                    ),
                  ),
                  title: Text(_activeAccount!.fullName),
                  subtitle: Text(_activeAccount!.email),
                  trailing: Chip(
                    label: Text(
                      _activeAccount!.isActive ? 'Active' : 'Inactive',
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Text(
              'Provision New Account',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
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

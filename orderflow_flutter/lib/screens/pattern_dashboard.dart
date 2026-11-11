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

  final _emailController = TextEditingController(text: 'margaret@example.com');
  final _firstNameController = TextEditingController(text: 'Margaret');
  final _lastNameController = TextEditingController(text: 'Hamilton');
  final _lookupUserIdController = TextEditingController(text: '1');
  UserSummary? _summary;

  final _billingUserIdController = TextEditingController(text: '1');
  final _billingAmountController = TextEditingController(text: '149.00');
  InvoiceDto? _invoice;

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _lookupUserIdController.dispose();
    _billingUserIdController.dispose();
    _billingAmountController.dispose();
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

  Future<void> _registerAccount() async {
    setState(() => _loading = true);
    try {
      final summary = await client.identity.registerAccount(
        _emailController.text.trim(),
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );
      setState(() {
        _summary = summary;
        _lookupUserIdController.text = '${summary.userId}';
        _billingUserIdController.text = '${summary.userId}';
      });
      _addLog('identity.registerAccount', summary.toJson());
    } catch (e) {
      _addLog('identity.registerAccount', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _fetchSummary() async {
    setState(() => _loading = true);
    try {
      final id = int.tryParse(_lookupUserIdController.text.trim()) ?? 1;
      final summary = await client.identity.getUserSummary(id);
      setState(() => _summary = summary);
      _addLog('identity.getUserSummary', summary?.toJson());
    } catch (e) {
      _addLog('identity.getUserSummary', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _issueInvoice() async {
    setState(() => _loading = true);
    try {
      final userId = int.tryParse(_billingUserIdController.text.trim()) ?? 1;
      final amount = double.tryParse(_billingAmountController.text.trim()) ?? 0;
      final invoice = await client.billing.issueInvoice(userId, amount);
      setState(() => _invoice = invoice);
      _addLog('billing.issueInvoice', invoice.toJson());
    } catch (e) {
      _addLog('billing.issueInvoice', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackendShell(
      patternTag: '04-modular-monolith',
      patternTitle: 'Modular Monolith',
      patternDescription:
          'modules/{identity,billing}/{api,internal}/ — Billing calls IdentityFacade.',
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
                    'Identity Module (client.identity)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                            labelText: 'First name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                            labelText: 'Last name',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _registerAccount,
                        icon: const Icon(Icons.badge_outlined, size: 18),
                        label: const Text('Register Account'),
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
                          controller: _lookupUserIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'User ID',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _loading ? null : _fetchSummary,
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text('Get UserSummary'),
                      ),
                    ],
                  ),
                  if (_summary != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'UserSummary DTO: userId=${_summary!.userId}, '
                      'fullName=${_summary!.fullName}, active=${_summary!.isActive}',
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
                    'Billing Module (client.billing -> IdentityFacade)',
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
                          controller: _billingUserIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'User ID',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160,
                        child: TextField(
                          controller: _billingAmountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Invoice amount (\$)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: _loading ? null : _issueInvoice,
                        icon: const Icon(Icons.receipt_outlined, size: 18),
                        label: const Text('Issue Invoice'),
                      ),
                    ],
                  ),
                  if (_invoice != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'InvoiceDto: ledgerEntryId=${_invoice!.ledgerEntryId}, '
                      'userId=${_invoice!.userId}, amount=\$${_invoice!.amount}',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../client.dart';
import '../services/multi_backend_rpc.dart';
import '../widgets/backend_shell.dart';

enum BackendPattern {
  simpleMvc(
    tag: '01-simple-mvc',
    title: 'Simple MVC',
    description: 'Endpoints talk directly to Task.db and User.db.',
    showAuth: false,
  ),
  layered(
    tag: '02-layered',
    title: 'Layered Architecture',
    description: 'Endpoint -> Service -> OrderStore -> ORM (Order requires auth).',
    showAuth: true,
  ),
  verticalSlices(
    tag: '03-vertical-slices',
    title: 'Vertical Slices',
    description: 'features/{auth,orders,payments}/ (Orders slice requires auth).',
    showAuth: true,
  ),
  modularMonolith(
    tag: '04-modular-monolith',
    title: 'Modular Monolith',
    description: 'modules/{identity,billing}/{api,internal}/ + platform/.',
    showAuth: false,
  ),
  eventDriven(
    tag: '05-event-driven',
    title: 'Event-Driven',
    description: 'MessageCentral pub-sub + typed FutureCall background jobs.',
    showAuth: false,
  );

  const BackendPattern({
    required this.tag,
    required this.title,
    required this.description,
    required this.showAuth,
  });

  final String tag;
  final String title;
  final String description;
  final bool showAuth;
}

class PatternDashboard extends StatefulWidget {
  const PatternDashboard({super.key});

  @override
  State<PatternDashboard> createState() => _PatternDashboardState();
}

class _PatternDashboardState extends State<PatternDashboard> {
  BackendPattern _selected = BackendPattern.simpleMvc;
  final _logs = <RpcLogEntry>[];
  bool _loading = false;

  /// Per-backend URL map so each pattern can point to its own server/port
  /// (defaults to the active configured server URL, e.g. http://localhost:8080/).
  late final Map<BackendPattern, String> _backendUrls = {
    for (final p in BackendPattern.values) p: serverUrlNotifier.value,
  };

  // 01-simple-mvc controllers
  final _taskTitle = TextEditingController(text: 'Ship MVC backend');
  final _taskUserId = TextEditingController(text: '1');
  bool _taskCompleted = false;

  // 01 & 02 shared user controllers
  final _userName = TextEditingController(text: 'Ada Lovelace');
  final _userEmail = TextEditingController(text: 'ada@example.com');
  bool _userActive = true;

  // 02-layered controllers
  final _layeredOrderAmount = TextEditingController(text: '49.99');

  // 03-vertical-slices controllers
  final _sliceAuthName = TextEditingController(text: 'Alan Turing');
  final _sliceAuthEmail = TextEditingController(text: 'alan@example.com');
  final _sliceItemCount = TextEditingController(text: '3');
  final _sliceTotalPrice = TextEditingController(text: '79.50');
  final _slicePayOrderId = TextEditingController(text: '1');
  final _slicePayAmount = TextEditingController(text: '79.50');

  // 04-modular-monolith controllers
  final _modEmail = TextEditingController(text: 'margaret@example.com');
  final _modFirstName = TextEditingController(text: 'Margaret');
  final _modLastName = TextEditingController(text: 'Hamilton');
  final _modUserId = TextEditingController(text: '1');
  final _modBillingAmount = TextEditingController(text: '149.00');

  // 05-event-driven controllers
  final _evtOrderId = TextEditingController(text: '101');
  final _evtEmail = TextEditingController(text: 'explorer@example.com');
  final _evtAmount = TextEditingController(text: '129.95');

  @override
  void initState() {
    super.initState();
    serverUrlNotifier.addListener(_rememberCurrentUrl);
  }

  @override
  void dispose() {
    serverUrlNotifier.removeListener(_rememberCurrentUrl);
    _taskTitle.dispose();
    _taskUserId.dispose();
    _userName.dispose();
    _userEmail.dispose();
    _layeredOrderAmount.dispose();
    _sliceAuthName.dispose();
    _sliceAuthEmail.dispose();
    _sliceItemCount.dispose();
    _sliceTotalPrice.dispose();
    _slicePayOrderId.dispose();
    _slicePayAmount.dispose();
    _modEmail.dispose();
    _modFirstName.dispose();
    _modLastName.dispose();
    _modUserId.dispose();
    _modBillingAmount.dispose();
    _evtOrderId.dispose();
    _evtEmail.dispose();
    _evtAmount.dispose();
    super.dispose();
  }

  void _rememberCurrentUrl() {
    _backendUrls[_selected] = serverUrlNotifier.value;
  }

  Future<void> _selectPattern(BackendPattern next) async {
    if (next == _selected) return;
    _backendUrls[_selected] = serverUrlNotifier.value;
    setState(() => _selected = next);
    final targetUrl = _backendUrls[next]!;
    if (targetUrl != serverUrlNotifier.value) {
      await initializeClient(overrideUrl: targetUrl);
      if (mounted) setState(() {});
    }
  }

  void _applySequentialPorts() {
    setState(() {
      for (var i = 0; i < BackendPattern.values.length; i++) {
        _backendUrls[BackendPattern.values[i]] =
            'http://localhost:${8080 + i}/';
      }
    });
    initializeClient(overrideUrl: _backendUrls[_selected]);
    _addLog(
      'config.ports',
      {for (final e in _backendUrls.entries) e.key.tag: e.value},
    );
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

  Future<void> _invoke(
    String endpoint,
    String method, [
    Map<String, dynamic> args = const {},
  ]) async {
    setState(() => _loading = true);
    try {
      final result = await MultiBackendRpc.call(
        baseUrl: serverUrlNotifier.value,
        endpoint: endpoint,
        method: method,
        args: args,
      );
      _addLog('$endpoint.$method', result ?? {'status': 'ok'});
    } catch (e) {
      _addLog('$endpoint.$method', e, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 760;

    return Row(
      children: [
        if (isWide)
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= 1240,
            selectedIndex: _selected.index,
            onDestinationSelected: (i) =>
                _selectPattern(BackendPattern.values[i]),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: FilledButton.tonalIcon(
                onPressed: _applySequentialPorts,
                icon: const Icon(Icons.hub_outlined, size: 18),
                label: Text(
                  MediaQuery.sizeOf(context).width >= 1240
                      ? 'Ports :8080–:8084'
                      : ':8080+',
                ),
              ),
            ),
            destinations: [
              for (final p in BackendPattern.values)
                NavigationRailDestination(
                  icon: const Icon(Icons.layers_outlined),
                  selectedIcon: const Icon(Icons.layers),
                  label: Text('${p.tag.substring(0, 2)} · ${p.title}'),
                ),
            ],
          ),
        if (isWide) const VerticalDivider(width: 1),
        Expanded(
          child: BackendShell(
            patternTag: _selected.tag,
            patternTitle: _selected.title,
            patternDescription: _selected.description,
            showAuth: _selected.showAuth,
            logs: _logs,
            onClearLogs: () => setState(_logs.clear),
            onLog: _addLog,
            onClientChanged: () => setState(() {}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isWide) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in BackendPattern.values)
                        ChoiceChip(
                          label: Text(p.tag),
                          selected: p == _selected,
                          onSelected: (_) => _selectPattern(p),
                        ),
                      ActionChip(
                        avatar: const Icon(Icons.hub_outlined, size: 16),
                        label: const Text('Assign :8080–:8084'),
                        onPressed: _applySequentialPorts,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                _buildActivePatternCards(context, colors),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivePatternCards(BuildContext context, ColorScheme colors) {
    return switch (_selected) {
      BackendPattern.simpleMvc => _buildSimpleMvc(context),
      BackendPattern.layered => _buildLayered(context),
      BackendPattern.verticalSlices => _buildVerticalSlices(context),
      BackendPattern.modularMonolith => _buildModularMonolith(context),
      BackendPattern.eventDriven => _buildEventDriven(context),
    };
  }

  Widget _buildSimpleMvc(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionCard(
          context,
          title: 'TaskEndpoint (task.createTask / task.getTasks)',
          children: [
            _field(_taskTitle, 'Task title', width: 230),
            _field(_taskUserId, 'User ID', width: 110, numeric: true),
            FilterChip(
              label: const Text('Completed'),
              selected: _taskCompleted,
              onSelected: (v) => setState(() => _taskCompleted = v),
            ),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('task', 'createTask', {
                        'task': {
                          'title': _taskTitle.text.trim(),
                          'isCompleted': _taskCompleted,
                          'userId': int.tryParse(_taskUserId.text.trim()) ?? 1,
                          'createdAt': DateTime.now().toUtc().toIso8601String(),
                        },
                      }),
              icon: const Icon(Icons.add_task, size: 18),
              label: const Text('Create Task'),
            ),
            OutlinedButton.icon(
              onPressed: _loading ? null : () => _invoke('task', 'getTasks'),
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Get Tasks'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _userCrudCard(context),
      ],
    );
  }

  Widget _buildLayered(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionCard(
          context,
          title: 'OrderEndpoint (order.createOrder) · Requires Sign In',
          children: [
            _field(
              _layeredOrderAmount,
              'Order amount (\$)',
              width: 180,
              decimal: true,
            ),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('order', 'createOrder', {
                        'request': {
                          'amount':
                              double.tryParse(_layeredOrderAmount.text.trim()) ??
                                  0,
                        },
                      }),
              icon: const Icon(Icons.shopping_cart_checkout, size: 18),
              label: const Text('Create Order'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _userCrudCard(context),
      ],
    );
  }

  Widget _userCrudCard(BuildContext context) {
    return _sectionCard(
      context,
      title: 'UserEndpoint (user.createUser / user.getUsers)',
      children: [
        _field(_userName, 'Name', width: 200),
        _field(_userEmail, 'Email', width: 220),
        FilterChip(
          label: const Text('Active'),
          selected: _userActive,
          onSelected: (v) => setState(() => _userActive = v),
        ),
        FilledButton.icon(
          onPressed: _loading
              ? null
              : () => _invoke('user', 'createUser', {
                    'user': {
                      'name': _userName.text.trim(),
                      'email': _userEmail.text.trim(),
                      'isActive': _userActive,
                    },
                  }),
          icon: const Icon(Icons.person_add, size: 18),
          label: const Text('Create User'),
        ),
        OutlinedButton.icon(
          onPressed: _loading ? null : () => _invoke('user', 'getUsers'),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Get Users'),
        ),
      ],
    );
  }

  Widget _buildVerticalSlices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionCard(
          context,
          title: 'Auth Slice (authFeature.register / lookupByEmail)',
          children: [
            _field(_sliceAuthName, 'Name', width: 200),
            _field(_sliceAuthEmail, 'Email', width: 220),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('authFeature', 'register', {
                        'name': _sliceAuthName.text.trim(),
                        'email': _sliceAuthEmail.text.trim(),
                      }),
              icon: const Icon(Icons.person_add, size: 18),
              label: const Text('Register'),
            ),
            OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('authFeature', 'lookupByEmail', {
                        'email': _sliceAuthEmail.text.trim(),
                      }),
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Lookup by Email'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _sectionCard(
          context,
          title:
              'Orders Slice (orderFeature.placeOrder / listMyOrders) · Requires Sign In',
          children: [
            _field(_sliceItemCount, 'Item count', width: 130, numeric: true),
            _field(
              _sliceTotalPrice,
              'Total price (\$)',
              width: 150,
              decimal: true,
            ),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('orderFeature', 'placeOrder', {
                        'itemCount':
                            int.tryParse(_sliceItemCount.text.trim()) ?? 1,
                        'totalPrice':
                            double.tryParse(_sliceTotalPrice.text.trim()) ?? 0,
                      }),
              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
              label: const Text('Place Order'),
            ),
            OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('orderFeature', 'listMyOrders'),
              icon: const Icon(Icons.list_alt, size: 18),
              label: const Text('List My Orders'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _sectionCard(
          context,
          title: 'Payments Slice (paymentFeature.chargeOrder)',
          children: [
            _field(_slicePayOrderId, 'Order ID', width: 130, numeric: true),
            _field(_slicePayAmount, 'Amount (\$)', width: 150, decimal: true),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('paymentFeature', 'chargeOrder', {
                        'orderId':
                            int.tryParse(_slicePayOrderId.text.trim()) ?? 1,
                        'amount':
                            double.tryParse(_slicePayAmount.text.trim()) ?? 0,
                      }),
              icon: const Icon(Icons.payments_outlined, size: 18),
              label: const Text('Charge Order'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModularMonolith(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionCard(
          context,
          title: 'Identity Module (identity.registerAccount / getUserSummary)',
          children: [
            _field(_modEmail, 'Email', width: 220),
            _field(_modFirstName, 'First name', width: 150),
            _field(_modLastName, 'Last name', width: 150),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('identity', 'registerAccount', {
                        'email': _modEmail.text.trim(),
                        'firstName': _modFirstName.text.trim(),
                        'lastName': _modLastName.text.trim(),
                      }),
              icon: const Icon(Icons.badge_outlined, size: 18),
              label: const Text('Register Account'),
            ),
            _field(_modUserId, 'User ID', width: 120, numeric: true),
            OutlinedButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('identity', 'getUserSummary', {
                        'userId': int.tryParse(_modUserId.text.trim()) ?? 1,
                      }),
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Get UserSummary'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _sectionCard(
          context,
          title: 'Billing Module (billing.issueInvoice -> IdentityFacade)',
          children: [
            _field(_modUserId, 'User ID', width: 120, numeric: true),
            _field(
              _modBillingAmount,
              'Invoice amount (\$)',
              width: 160,
              decimal: true,
            ),
            FilledButton.icon(
              onPressed: _loading
                  ? null
                  : () => _invoke('billing', 'issueInvoice', {
                        'userId': int.tryParse(_modUserId.text.trim()) ?? 1,
                        'amount':
                            double.tryParse(_modBillingAmount.text.trim()) ?? 0,
                      }),
              icon: const Icon(Icons.receipt_outlined, size: 18),
              label: const Text('Issue Invoice'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventDriven(BuildContext context) {
    return _sectionCard(
      context,
      title: 'CheckoutEndpoint (checkout.completeCheckout)',
      children: [
        _field(_evtOrderId, 'Order ID', width: 130, numeric: true),
        _field(_evtEmail, 'Customer email', width: 230),
        _field(_evtAmount, 'Amount (\$)', width: 150, decimal: true),
        FilledButton.icon(
          onPressed: _loading
              ? null
              : () => _invoke('checkout', 'completeCheckout', {
                    'orderId': int.tryParse(_evtOrderId.text.trim()) ?? 101,
                    'email': _evtEmail.text.trim(),
                    'amount': double.tryParse(_evtAmount.text.trim()) ?? 0,
                  }),
          icon: const Icon(Icons.bolt, size: 18),
          label: const Text('Complete Checkout'),
        ),
      ],
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    double width = 180,
    bool numeric = false,
    bool decimal = false,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: decimal
            ? const TextInputType.numberWithOptions(decimal: true)
            : numeric
                ? TextInputType.number
                : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
